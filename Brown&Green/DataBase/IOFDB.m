//
//  LinkbookDB.m
//  SporeRx
//
//  Created by ITGC on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IOFDB.h"
#import "ASIDownloadCache.h"
#import <UIKit/UIKit.h>

static IOFDB *lnkbkDB = nil;

@implementation IOFDB
@synthesize dbIOF;
@synthesize mArrCategories,mArrLookups,mArrSubCategories;


#pragma mark -
#pragma mark Database Creation

- (BOOL)OpenSporeRxDatabaseConnection{
	@try{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"IOF.sqlite"];
		if (sqlite3_open([path UTF8String], &dbIOF) == SQLITE_OK) {
			return YES;
		}
		return NO;
	}
	@catch (NSException *ex) {
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:nil 
							  message:[NSString stringWithFormat:@"Error in OpenDatabaseConnection. %@ ",
									   ex.reason] 
							  delegate:nil
							  cancelButtonTitle:@"Ok"
							  otherButtonTitles:nil
							  ];
		[alert show];
		
	}
	return NO;
}

- (BOOL)OpenSporeRxTMPDataBaseConnection{
	@try
    {
		NSString *path = [[NSString stringWithFormat:@"%@/tmp",NSHomeDirectory()] stringByAppendingPathComponent:@"IOF.sqlite"];
		if (sqlite3_open([path UTF8String], &dbIOF) == SQLITE_OK)
        {
            NSLog(@"Database successfully opened");
			return YES;
		}
		return NO;
	}
	@catch (NSException *ex)
    {
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:nil
							  message:[NSString stringWithFormat:@"Error in OpenDatabaseConnection. %@ ",
									   ex.reason]
							  delegate:nil
							  cancelButtonTitle:@"Ok"
							  otherButtonTitles:nil];
		[alert show];
		
	}
	return NO;
}

- (BOOL)CloseSporeRxDatabaseConnection{
	sqlite3_close(self.dbIOF);
	return YES;
}
- (void)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	
	//Process orginal DB
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"IOF.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
	
    if (success) {
		[self OpenSporeRxDatabaseConnection];
		return;
	}
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"IOF.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSLog(@"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
	else {
		[self OpenSporeRxDatabaseConnection];
	}
}
- (void)makeTmpDatabase{
    BOOL success;
    [self CloseSporeRxDatabaseConnection];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
	//Process orginal DB
	NSString *writableDBPath = [[NSString stringWithFormat:@"%@/tmp",NSHomeDirectory()] stringByAppendingPathComponent:@"IOF.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
	
    if (success)
    {
        [fileManager removeItemAtPath:writableDBPath error:&error];
    }
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()] stringByAppendingPathComponent:@"IOF.sqlite"];
    
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    
    if (!success)
	{
        NSLog(@"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
	else
	{
		[self OpenSporeRxTMPDataBaseConnection];
	}
}

- (void)ReplaceWithMainDB{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    [self CloseSporeRxDatabaseConnection];
	//Process orginal DB
	NSString *writableDBPath = [[NSString stringWithFormat:@"%@/tmp",NSHomeDirectory()] stringByAppendingPathComponent:@"IOF.sqlite"];
    
    NSString *maindbDBPath = [[NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()] stringByAppendingPathComponent:@"IOF.sqlite"];
    success = [fileManager fileExistsAtPath:maindbDBPath];
	
    if (success)
    {
        [fileManager removeItemAtPath:maindbDBPath error:&error];
    }
    // The writable database does not exist, so copy the default to the appropriate location.
    
    success = [fileManager copyItemAtPath:writableDBPath toPath:maindbDBPath error:&error];
    
    if (!success)
	{
        NSLog(@"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
	else
	{
		[self OpenSporeRxDatabaseConnection];
	}
}

- (NSMutableArray *)CheckTables{
	NSMutableArray *urlList = [NSMutableArray array];
	@try{
		sqlite3 *db;
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"temp.sqlite"];
		if (sqlite3_open([path UTF8String], &db) == SQLITE_OK) {
			const char *sql = "select name,sql from sqlite_master where type = 'table'";
			sqlite3_stmt *statement;
			if (sqlite3_prepare_v2(db, sql, -1, &statement, NULL) == SQLITE_OK) {
				while (sqlite3_step(statement) == SQLITE_ROW) {
					NSMutableDictionary *dictionarytblInfo = [NSMutableDictionary dictionary];
					[dictionarytblInfo setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] forKey:@"tablename"];
					[dictionarytblInfo setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] forKey:@"sqlstring"];
					[urlList addObject:dictionarytblInfo];
				}
			}
			else{
				NSLog(@"%s",sqlite3_errmsg(db));
			}
			sqlite3_finalize(statement);
		}
		sqlite3_close(db);
		
		{
			NSMutableDictionary *dictionarytblInfo;
			for (dictionarytblInfo in urlList)
			{
				const char *sql = [[dictionarytblInfo valueForKey:@"sqlstring"] UTF8String];
				sqlite3_stmt *statement;
				if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK) {
					sqlite3_step(statement);
				}
				else{
					NSLog(@"%s",sqlite3_errmsg(db));
				}
				sqlite3_finalize(statement);
			}
		}
	}
	@catch (NSException *ex) {
		NSLog(@"Error: in CheckTables %@", ex.reason);
	}
	return urlList;
}

- (void)GetTableDetail:(NSMutableArray *)strTables{
	NSMutableArray *urlList = [NSMutableArray array];
	@try{
		sqlite3 *db;
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"temp.sqlite"];
		if (sqlite3_open([path UTF8String], &db) == SQLITE_OK) {
			NSMutableDictionary *dictionarytblInfo;
			for (dictionarytblInfo in strTables){
				const char *sql = [[NSString stringWithFormat:@"PRAGMA table_info(%@)",[dictionarytblInfo valueForKey:@"tablename"]] UTF8String];
				sqlite3_stmt *statement;
				if (sqlite3_prepare_v2(db, sql, -1, &statement, NULL) == SQLITE_OK) {
					while (sqlite3_step(statement) == SQLITE_ROW) {
						NSString *strQuery = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN",[dictionarytblInfo valueForKey:@"tablename"]];
						//name			
						strQuery = [NSString stringWithFormat:@"%@ %@",strQuery,[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]];
						//type
						strQuery = [NSString stringWithFormat:@"%@ %@",strQuery,[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]];
						//Deafult
						if(sqlite3_column_text(statement, 4) != NULL)
							strQuery = [NSString stringWithFormat:@"%@ DEFAULT %@",strQuery,[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];							
						
						if(sqlite3_column_int(statement, 3) == 1)
							strQuery = [NSString stringWithFormat:@"%@ NOT NULL",strQuery];
						
						if(sqlite3_column_int(statement, 5) == 1)
							strQuery = [NSString stringWithFormat:@"%@ PRIMARY KEY AUTOINCREMENT",strQuery];
						
						[urlList addObject:strQuery];
					}
				}
				else{
					NSLog(@"%s",sqlite3_errmsg(db));
				}
				sqlite3_finalize(statement);
			}
		}
		sqlite3_close(db);
		
		{
			NSString *strQuery;
			for (strQuery in urlList){
				const char *sql = [strQuery UTF8String];
				sqlite3_stmt *statement;
				if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK) {
					sqlite3_step(statement);
				}
				else{
					NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
				}
				sqlite3_finalize(statement);
			}
		}
	}
	@catch (NSException *ex) {
		NSLog(@"Error: in GetTableDetail %@", ex.reason);
	}
}

- (void)UpdateDatabaseIfNeeded {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	// The writable database does not exist, so copy the default to the appropriate location. wil
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"IOF.sqlite"];
	[fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:@"temp.sqlite"] error:&error];
	[fileManager copyItemAtPath:defaultDBPath toPath:[documentsDirectory stringByAppendingPathComponent:@"temp.sqlite"] error:&error];
	[self GetTableDetail:[self CheckTables]];
	[fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:@"temp.sqlite"] error:&error];
}

#pragma mark -
#pragma mark SystemDatabase Task

- (BOOL)insertCategory:(NSMutableArray *)arrServices
{
    BOOL returnValue = NO;
    
    for (NSMutableDictionary *dicService in arrServices)
    {
        {
            const char *sql = "insert or replace into Tbl_Category(cat_id,cat_pid ,cat_name , cat_desc , cat_image, cat_type, cat_active, cat_deleted, cat_date,sort_order) values(?,?,?,?,?,?,?,?,?,?)";
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK)
            {
                if(![[dicService valueForKey:kCatID] isEqual:[NSNull null]])
                sqlite3_bind_int(statement, 1, [[dicService valueForKey:kCatID] intValue]);
                
                if(![[dicService valueForKey:kCatParentID] isEqual:[NSNull null]])
                sqlite3_bind_int(statement, 2, [[dicService valueForKey:kCatParentID] intValue]);
                
                 if(![[dicService valueForKey:kCatName] isEqual:[NSNull null]])
                sqlite3_bind_text(statement, 3,[[dicService valueForKey:kCatName] UTF8String],-1,SQLITE_TRANSIENT);
                
                if(![[dicService valueForKey:kCatDesc] isEqual:[NSNull null]])
                sqlite3_bind_text(statement, 4,[[dicService valueForKey:kCatDesc] UTF8String],-1,SQLITE_TRANSIENT);
                
                if(![[dicService valueForKey:kCatImage] isEqual:[NSNull null]])
                sqlite3_bind_text(statement, 5,[[dicService valueForKey:kCatImage] UTF8String],-1,SQLITE_TRANSIENT);
                
                  if(![[dicService valueForKey:kCatType] isEqual:[NSNull null]])
                sqlite3_bind_text(statement, 6,[[dicService valueForKey:kCatType] UTF8String],-1,SQLITE_TRANSIENT);
                
                if(![[dicService valueForKey:kIORDERFRESHTRAIL] isEqual:[NSNull null]])
                sqlite3_bind_text(statement, 7,[[[dicService valueForKey:kIORDERFRESHTRAIL] valueForKey:kCatActive] UTF8String],-1,SQLITE_TRANSIENT);
                
                 if(![[dicService valueForKey:kIORDERFRESHTRAIL] isEqual:[NSNull null]])
                sqlite3_bind_text(statement, 8,[[[dicService valueForKey:kIORDERFRESHTRAIL] valueForKey:kCatDeleted] UTF8String],-1,SQLITE_TRANSIENT);
                
                if(![[dicService valueForKey:kIORDERFRESHTRAIL] isEqual:[NSNull null]])
                sqlite3_bind_text(statement, 9,[[[dicService valueForKey:kIORDERFRESHTRAIL] valueForKey:kCatDate] UTF8String],-1,SQLITE_TRANSIENT);
                
                 if(![[dicService valueForKey:@"SortOrder"] isEqual:[NSNull null]])
                 sqlite3_bind_int(statement, 10, [[dicService valueForKey:@"SortOrder"] intValue]);

                sqlite3_step(statement);
                returnValue = YES;
            }
            else {
                NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
            }
            sqlite3_finalize(statement);
        }
    }
    
    returnValue = YES;
    return returnValue;
}
- (BOOL)insertSubCategory:(NSMutableArray *)arrServices
{
    BOOL returnValue = NO;
    
    for (NSMutableDictionary *dicService in arrServices) {
        {
            const char *sql = "insert or replace into Tbl_Subcategory(subCat_id,subCat_pid ,subCat_name , subCat_desc , subCat_image, subCat_type, subCat_active, subCat_deleted, subCat_date,sort_order) values(?,?,?,?,?,?,?,?,?,?)";
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK)
            {
                if(![[dicService valueForKey:kCatID] isEqual:[NSNull null]])
                    sqlite3_bind_int(statement, 1, [[dicService valueForKey:kCatID] intValue]);
                
                if(![[dicService valueForKey:kCatParentID] isEqual:[NSNull null]])
                    sqlite3_bind_int(statement, 2, [[dicService valueForKey:kCatParentID] intValue]);
                
                if(![[dicService valueForKey:kCatName] isEqual:[NSNull null]])
                    sqlite3_bind_text(statement, 3,[[dicService valueForKey:kCatName] UTF8String],-1,SQLITE_TRANSIENT);
                
                if(![[dicService valueForKey:kCatDesc] isEqual:[NSNull null]])
                    sqlite3_bind_text(statement, 4,[[dicService valueForKey:kCatDesc] UTF8String],-1,SQLITE_TRANSIENT);
                
                if(![[dicService valueForKey:kCatImage] isEqual:[NSNull null]])
                    sqlite3_bind_text(statement, 5,[[dicService valueForKey:kCatImage] UTF8String],-1,SQLITE_TRANSIENT);
                
                if(![[dicService valueForKey:kCatType] isEqual:[NSNull null]])
                    sqlite3_bind_text(statement, 6,[[dicService valueForKey:kCatType] UTF8String],-1,SQLITE_TRANSIENT);
                
                if(![[dicService valueForKey:kIORDERFRESHTRAIL] isEqual:[NSNull null]])
                    sqlite3_bind_text(statement, 7,[[[dicService valueForKey:kIORDERFRESHTRAIL] valueForKey:kCatActive] UTF8String],-1,SQLITE_TRANSIENT);
                
                if(![[dicService valueForKey:kIORDERFRESHTRAIL] isEqual:[NSNull null]])
                    sqlite3_bind_text(statement, 8,[[[dicService valueForKey:kIORDERFRESHTRAIL] valueForKey:kCatDeleted] UTF8String],-1,SQLITE_TRANSIENT);
                
                if(![[dicService valueForKey:kIORDERFRESHTRAIL] isEqual:[NSNull null]])
                    sqlite3_bind_text(statement, 9,[[[dicService valueForKey:kIORDERFRESHTRAIL] valueForKey:kCatDate] UTF8String],-1,SQLITE_TRANSIENT);
                
                if(![[dicService valueForKey:@"SortOrder"] isEqual:[NSNull null]])
                    sqlite3_bind_int(statement, 10, [[dicService valueForKey:@"SortOrder"] intValue]);
                
                sqlite3_step(statement);
                returnValue = YES;
            }
            else {
                NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
            }
            sqlite3_finalize(statement);
        }
    }
//    [[NSUserDefaults standardUserDefaults]objectForKey:@"subCategoryAdded"]
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"subCategoryAdded"];
    returnValue = YES;
    return returnValue;
}
- (NSMutableArray *)getNotification
    {
    NSMutableArray *arr = [NSMutableArray array];
    {
        const char *sql = "Select noti_tittle,noti_msg,noti_expiryDate,noti_creationDate,noti_Id from Tbl_notification where noti_expiryDate > ? order by noti_creationDate desc ";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_double(statement, 1, [[NSDate date] timeIntervalSince1970]);
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                if (sqlite3_column_text(statement,0)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)] forKey:@"NotificationHeading"];
                }

                if (sqlite3_column_text(statement,1)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)] forKey:@"NotificationMsg"];
                }
                if (sqlite3_column_text(statement,2)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)] forKey:@"ExpiryDate"];
                }

                if (sqlite3_column_text(statement,3)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)] forKey:@"CreatedOn"];
                }

                if (sqlite3_column_text(statement,4)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)] forKey:@"AppNotificationId"];
                }

                [arr addObject:dic];
            }
        }
        else {
            NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
        }
        sqlite3_finalize(statement);
    }

    return arr;
}
- (BOOL)insertNotification:(NSMutableArray *)notificationArr
{
    BOOL returnValue = NO;

    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    for (NSMutableDictionary *dicNotification in notificationArr) {
        {
            const char *sql = "insert into Tbl_notification(noti_tittle,noti_msg,noti_expiryDate,noti_creationDate,noti_Id) values(?,?,?,?,?)";
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK) {

                sqlite3_bind_text(statement, 1,[[dicNotification valueForKey:@"NotificationHeading"] UTF8String],-1,SQLITE_TRANSIENT);
                if (![[dicNotification valueForKey:@"NotificationMsg"] isEqual:[NSNull null]])
                {
                    sqlite3_bind_text(statement, 2,[[dicNotification valueForKey:@"NotificationMsg"] UTF8String],-1,SQLITE_TRANSIENT);

                }
                if(![[dicNotification valueForKey:@"ExpiryDate"] isEqual:[NSNull null]])
                {
                    NSDate *date = [format dateFromString:[dicNotification valueForKey:@"ExpiryDate"]];
                    sqlite3_bind_double(statement, 3, [date timeIntervalSince1970]);
                }
                else{
                    sqlite3_bind_double(statement, 3, [[[NSDate date] dateByAddingTimeInterval:72*3600] timeIntervalSince1970]);
                }

                NSDate *date = [format dateFromString:[dicNotification valueForKey:@"SentTime"]];
                sqlite3_bind_double(statement, 4, [date timeIntervalSince1970]);
                
                if (![[dicNotification valueForKey:@"AppNotificationId"] isEqual:[NSNull null]])
                {
                    NSString *AppId =[NSString stringWithFormat:@"%@",[dicNotification valueForKey:@"AppNotificationId"]] ;
                    sqlite3_bind_text(statement, 5,[AppId UTF8String],-1,SQLITE_TRANSIENT);
                    
                }
                
                sqlite3_step(statement);
                returnValue = YES;
            }
            else {
                NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
            }
            sqlite3_finalize(statement);
        }
    }

    returnValue = YES;
    return returnValue;
}
- (BOOL)insertDate:(NSString *)currentDateService
{
            BOOL returnValue = NO;
            const char *sql = "insert into Tbl_time(time_id,time_time) values(?,?)";
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK)
            {
                sqlite3_bind_int(statement, 1, 1);
                if(![currentDateService isEqual:[NSNull null]])
                    sqlite3_bind_text(statement, 2,[currentDateService  UTF8String],-1,SQLITE_TRANSIENT);
                sqlite3_step(statement);
                returnValue = YES;
            }
            else
            {
                NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
            }
            sqlite3_finalize(statement);
        returnValue = YES;
        return returnValue;
}

- (NSString *)getDateFromDataBase
{
    NSString *dataBaseDate = nil;
    const char *sql = "Select time_time from Tbl_time";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            if (sqlite3_column_text(statement,0))
            {
                dataBaseDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
            }
            
        }
    }
    
    else
    {
        NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
    }
    
    sqlite3_finalize(statement);
    
    return dataBaseDate;
}
- (BOOL)insertLocation:(NSMutableArray *)arrServices{

    BOOL returnValue = NO;
    
    for (NSMutableDictionary *dicService in arrServices) {
        {
            const char *sql = "insert or replace into Tbl_Loc(loc_id,loc_cid ,loc_name ) values(?,?,?)";
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK) {
                if(![[dicService valueForKey:@"LocationID"] isEqual:[NSNull null]])
                    sqlite3_bind_int(statement, 1,[[dicService valueForKey:@"LocationID"] intValue] );
                if(![[dicService valueForKey:@"RefCityId"] isEqual:[NSNull null]])
                    sqlite3_bind_int(statement, 2,[[dicService valueForKey:@"RefCityId"] intValue] );
                if(![[dicService valueForKey:@"LocationName"] isEqual:[NSNull null]])
                    sqlite3_bind_text(statement, 3,[[dicService valueForKey:@"LocationName"] UTF8String],-1,SQLITE_TRANSIENT);
                
                sqlite3_step(statement);
                returnValue = YES;
            }
            else {
                NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
            }
            sqlite3_finalize(statement);
        }
    }
    
    returnValue = YES;
    return returnValue;

}
- (BOOL)insertPrice:(NSMutableArray *)arrServices{
    BOOL returnValue = NO;
    for (NSMutableDictionary *dicService in arrServices  ) {
        {
            const char *sql = "insert or replace into Tbl_Price(price_id,price_pid,price_p,price_cityid,price_cityname ) values(?,?,?,?,?)";
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK) {
                
                if(![[dicService valueForKey:@"ProductPriceID"] isEqual:[NSNull null]])
                    sqlite3_bind_int(statement, 1,[[dicService valueForKey:@"ProductPriceID"] intValue] );
                if(![[dicService valueForKey:@"RefProductID"] isEqual:[NSNull null]])
                    sqlite3_bind_int(statement, 2,[[dicService valueForKey:@"RefProductID"] intValue] );
                
                if(![[dicService valueForKey:@"SalePrice"] isEqual:[NSNull null]])
                    sqlite3_bind_double(statement, 3,[[dicService valueForKey:@"SalePrice"] doubleValue]);
                
                if(![[[dicService valueForKey:@"RefCityID"] valueForKey:@"cityId"] isEqual:[NSNull null]])
                    sqlite3_bind_int(statement, 4,[[[dicService valueForKey:@"RefCityID"] valueForKey:@"cityId"] intValue] );
                
                if(![[[dicService valueForKey:@"RefCityID"]valueForKey:@"cityName"] isEqual:[NSNull null]])
                    sqlite3_bind_text(statement, 5,[[[dicService valueForKey:@"RefCityID"]valueForKey:@"cityName"] UTF8String], -1,SQLITE_TRANSIENT);
                
                sqlite3_step(statement);
                returnValue = YES;
            }
            else {
                NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
            }
            sqlite3_finalize(statement);
        }
    }
    
    returnValue = YES;
    return returnValue;
}

- (BOOL)updateSortOrder:(NSMutableArray *)arrSort{
    BOOL returnValue = NO;
    for (NSMutableDictionary *dicService in arrSort  ) {
        {
            const char *sql = "update Tbl_Price set price_sort = ? where price_cityid = ? and price_pid = ?";
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK) {
                
                if(![[dicService valueForKey:@"SortOrder"] isEqual:[NSNull null]])
                    sqlite3_bind_int(statement, 1,[[dicService valueForKey:@"SortOrder"] intValue] );
                else
                    sqlite3_bind_null(statement, 1);
                
                if(![[dicService valueForKey:@"CityId"] isEqual:[NSNull null]])
                    sqlite3_bind_int(statement, 2,[[dicService valueForKey:@"CityId"] intValue] );
                else
                    sqlite3_bind_null(statement, 2);
                    
                if(![[dicService valueForKey:@"ProductId"] isEqual:[NSNull null]])
                    sqlite3_bind_int(statement, 3,[[dicService valueForKey:@"ProductId"] intValue] );
                else
                    sqlite3_bind_null(statement, 3);
                
                
                sqlite3_step(statement);
                returnValue = YES;
            }
            else {
                NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
            }
            sqlite3_finalize(statement);
        }
    }
    
    returnValue = YES;
    return returnValue;
}
- (BOOL)insertProduct:(NSMutableArray *)arrServices{
    BOOL returnValue = NO;
    
    for (NSMutableDictionary *dicService in arrServices) {
        {
            const char *sql = "insert or replace into Tbl_Product(p_id,p_cid, p_name , p_ename,p_price, p_max,p_desc,p_img,p_bimg,p_unit,p_unitname,p_isfeatured,p_isactive,p_isdelete ,p_date, p_s_cid, p_marketprice,p_brand,p_skuid) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK)
            {
                if(![[dicService valueForKey:@"ProductID"] isEqual:[NSNull null]])
                 sqlite3_bind_int(statement, 1, [[dicService valueForKey:@"ProductID"] intValue]);
                
                if(![[dicService valueForKey:@"RefCategoryID"] isEqual:[NSNull null]])
                sqlite3_bind_int(statement, 2, [[dicService valueForKey:@"RefCategoryID"] intValue]);
                
                
                 if(![[dicService valueForKey:@"HindiName"] isEqual:[NSNull null]])
                sqlite3_bind_text(statement, 3,[[dicService valueForKey:@"HindiName"] UTF8String], -1,SQLITE_TRANSIENT);
                
                 if(![[dicService valueForKey:@"ProductName"] isEqual:[NSNull null]])
                sqlite3_bind_text(statement, 4,[[dicService valueForKey:@"ProductName"] UTF8String],-1,SQLITE_TRANSIENT);
                
                
                if(![[dicService valueForKey:@"SalePrice"] isEqual:[NSNull null]])
                 sqlite3_bind_double(statement, 5,[[dicService valueForKey:@"SalePrice"] doubleValue]);
                
                if(![[dicService valueForKey:@"MaxLimit"] isEqual:[NSNull null]])
                    sqlite3_bind_double(statement, 6,[[dicService valueForKey:@"MaxLimit"] doubleValue]);
                
                
                if(![[dicService valueForKey:@"Description"] isEqual:[NSNull null]])
                    sqlite3_bind_text(statement, 7,[[dicService valueForKey:@"Description"] UTF8String],-1,SQLITE_TRANSIENT);
                
                if(![[dicService valueForKey:@"ImgName"] isEqual:[NSNull null]])
                    sqlite3_bind_text(statement, 8,[[dicService valueForKey:@"ImgName"] UTF8String],-1,SQLITE_TRANSIENT);
                
                if(![[dicService valueForKey:@"BrandImage"] isEqual:[NSNull null]])
                {

                    NSString *brandImage=@"";
                    sqlite3_bind_text(statement, 9,[[dicService valueForKey:@"BrandImage"] UTF8String],-1,SQLITE_TRANSIENT);
                }
                
                if(![[dicService valueForKey:@"UnitValue"] isEqual:[NSNull null]])
                sqlite3_bind_double(statement, 10,[[dicService valueForKey:@"UnitValue"]  doubleValue]);
                
                if(![[dicService valueForKey:@"unitName"] isEqual:[NSNull null]])
                sqlite3_bind_text(statement, 11,[[dicService valueForKey:@"unitName"]  UTF8String],-1,SQLITE_TRANSIENT);
                
                if(![[dicService valueForKey:@"IsFeatured"] isEqual:[NSNull null]])
                 sqlite3_bind_text(statement, 12,[[dicService valueForKey:@"IsFeatured"]  UTF8String],-1,SQLITE_TRANSIENT);
                
                 if(![[dicService valueForKey:@"IsActive"] isEqual:[NSNull null]])
                 sqlite3_bind_text(statement, 13,[[dicService valueForKey:@"IsActive"]  UTF8String],-1,SQLITE_TRANSIENT);
                
                 if(![[dicService valueForKey:@"IsDeleted"] isEqual:[NSNull null]])
                 sqlite3_bind_text(statement, 14,[[dicService valueForKey:@"IsDeleted"]  UTF8String],-1,SQLITE_TRANSIENT);
                
                 if(![[dicService valueForKey:@"ModifiedOn"] isEqual:[NSNull null]])
                  sqlite3_bind_text(statement, 15,[[dicService valueForKey:@"ModifiedOn"]  UTF8String],-1,SQLITE_TRANSIENT);
                
                if(![[dicService valueForKey:@"RefSubCategoryID"] isEqual:[NSNull null]])
                    sqlite3_bind_int(statement, 16, [[dicService valueForKey:@"RefSubCategoryID"] intValue]);
                
                
                if(![[dicService valueForKey:@"MarketPrice"] isEqual:[NSNull null]])
                    sqlite3_bind_double(statement, 17,[[dicService valueForKey:@"MarketPrice"] doubleValue]);

                
                if(![[dicService valueForKey:@"BrandName"] isEqual:[NSNull null]])
                    sqlite3_bind_text(statement, 18,[[dicService valueForKey:@"BrandName"] UTF8String],-1,SQLITE_TRANSIENT);
                
                if(![[dicService valueForKey:@"SKUID"] isEqual:[NSNull null]])
                    sqlite3_bind_text(statement, 19,[[dicService valueForKey:@"SKUID"] UTF8String],-1,SQLITE_TRANSIENT);
                
                sqlite3_step(statement);
                returnValue = YES;
            }
            else {
                NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
            }
            sqlite3_finalize(statement);
        }
    }
    
    returnValue = YES;
    return returnValue;
}

-(void)StartTransaction{
    char* errorMessage;
    sqlite3_exec(self.dbIOF, "BEGIN TRANSACTION", NULL, NULL, &errorMessage);
}

- (void)EndTransaction{
    char* errorMessage;
    sqlite3_exec(self.dbIOF, "COMMIT TRANSACTION", NULL, NULL, &errorMessage);
}

- (BOOL)deleteAllCategories{
    BOOL returnValue = NO;
    {
        const char *sql = "delete from Tbl_Category";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
            returnValue = YES;
        }
        else {
            NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
        }
        sqlite3_finalize(statement);
    }
    return returnValue;
}


- (BOOL)deleteAllSubCategories{
    BOOL returnValue = NO;
    {
        const char *sql = "delete from Tbl_Subcategory";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
            returnValue = YES;
        }
        else {
            NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
        }
        sqlite3_finalize(statement);
    }
    return returnValue;
}
- (BOOL)deleteAllNotifications{
    BOOL returnValue = NO;
    {
        const char *sql = "delete from Tbl_notification";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
            returnValue = YES;
        }
        else {
            NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
        }
        sqlite3_finalize(statement);
    }
    return returnValue;
}
- (BOOL)deleteNotificationsUsingId :(NSString *)Id{
    BOOL returnValue = NO;
    {
        
        NSString *deleteQuery = [NSString stringWithFormat:@"delete from Tbl_notification where noti_Id ='%@'", Id];
        
        const char *sql = [deleteQuery UTF8String];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
            returnValue = YES;
        }
        else {
            NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
        }
        sqlite3_finalize(statement);
    }
    return returnValue;
}

- (BOOL)deleteAllProducts{
    BOOL returnValue = NO;
    {
        const char *sql = "delete from Tbl_Product";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
            returnValue = YES;
        }
        else {
            NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
        }
        sqlite3_finalize(statement);
    }
    return returnValue;
}

- (BOOL)deleteAllPrice{
    BOOL returnValue = NO;
    {
        const char *sql = "delete from Tbl_Price";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
            returnValue = YES;
        }
        else {
            NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
        }
        sqlite3_finalize(statement);
    }
    return returnValue;
}


-(BOOL) deleteDataBaseDate
{
    BOOL returnValue = NO;
    {
        const char *sql = "delete from Tbl_time";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
            returnValue = YES;
        }
        else {
            NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
        }
        sqlite3_finalize(statement);
    }
    return returnValue;
}

- (BOOL)deleteAllLocation{
    BOOL returnValue = NO;
    {
        const char *sql = "delete from Tbl_Loc";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
            returnValue = YES;
        }
        else {
            NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
        }
        sqlite3_finalize(statement);
    }
    return returnValue;
}

-(NSMutableArray*)getProductByIds: (NSArray*)arrIds
{
    @try {
    
    
    NSString * strProductsIds = [arrIds componentsJoinedByString:@","];
    
    NSMutableArray *arr = [NSMutableArray array];
    {
        NSString *sqlFinal = [NSString stringWithFormat:@"SELECT tbl_product.p_id,p_cid,p_name,p_ename,p_price,p_max,p_desc,p_img,p_bimg,p_unit,p_unitname, p_isfeatured, p_isactive,p_isdelete,p_date ,tbl_price.price_p  from tbl_product left join tbl_price on tbl_product.p_id = tbl_price.price_pid where price_cityid = 3 and tbl_product.p_id in (%@)",strProductsIds];
            const char *sql = [sqlFinal UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                
                if (sqlite3_column_text(statement,0)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)] forKey:@"ProductID"];
                }
                
                if (sqlite3_column_text(statement,1)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)] forKey:@"RefCategoryID"];
                }
                
                if (sqlite3_column_text(statement,2)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)] forKey:@"HindiName"];
                }
                if (sqlite3_column_text(statement,3) )  {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)] forKey:@"ProductName"];
                }
                if (sqlite3_column_text(statement,4)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)] forKey:@"CostPirce"];
                }
                if (sqlite3_column_text(statement,5)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)] forKey:@"MaxLimit"];
                }
                if (sqlite3_column_text(statement,6)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6)] forKey:@"Description"];
                }
                
                if (sqlite3_column_text(statement,7)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,7)] forKey:@"ImgName"];
                }
                
                if (sqlite3_column_text(statement,8)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,8)] forKey:@"BrandImage"];
                }
                
                if (sqlite3_column_text(statement,9)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,9)] forKey:@"Units"];
                }
                if (sqlite3_column_text(statement,10)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,10)] forKey:@"unitName"];
                }
                if (sqlite3_column_text(statement,11)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,11)] forKey:@"IsFeatured"];
                }
                if (sqlite3_column_text(statement,12)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,12)] forKey:@"IsActive"];
                }
                if (sqlite3_column_text(statement,13)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,13)] forKey:@"IsDeleted"];
                }
                if (sqlite3_column_text(statement,14)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,14)] forKey:@"ModifiedOn"];
                }
                if (sqlite3_column_text(statement,15)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,15)] forKey:@"SalePrice"];
                }
                [arr addObject:dic];
            }
        }
        else {
            NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
        }
        sqlite3_finalize(statement);
    }
    
    return arr;
    }
    @catch (NSException *exception)
    {
    }
}

-(NSMutableDictionary*)getProductById:(NSString*)strID{
    
 NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    {
            NSString *sqlFinal = [NSString stringWithFormat:@"SELECT tbl_product.p_id,p_cid,p_name,p_ename,p_price,p_max,p_desc,p_img,p_bimg,p_unit,p_unitname, p_isfeatured, p_isactive,p_isdelete,p_date ,tbl_price.price_p  from tbl_product left join tbl_price on tbl_product.p_id = tbl_price.price_pid where price_cityid = 3 and tbl_product.p_id = %@",strID];
            const char *sql = [sqlFinal UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
               if (sqlite3_column_text(statement,0)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)] forKey:@"ProductID"];
                }
                
                if (sqlite3_column_text(statement,1)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)] forKey:@"RefCategoryID"];
                }
                
                if (sqlite3_column_text(statement,2)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)] forKey:@"HindiName"];
                }
                
                if (sqlite3_column_text(statement,3) ) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)] forKey:@"ProductName"];
                }
                
                if (sqlite3_column_text(statement,4)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)] forKey:@"CostPirce"];
                }
                
                if (sqlite3_column_text(statement,5)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)] forKey:@"MaxLimit"];
                }
                
                if (sqlite3_column_text(statement,6)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6)] forKey:@"Description"];
                }
                
                if (sqlite3_column_text(statement,7)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,7)] forKey:@"ImgName"];
                }
                
                if (sqlite3_column_text(statement,8)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,8)] forKey:@"BrandImage"];
                }

                
                if (sqlite3_column_text(statement,9)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,9)] forKey:@"Units"];
                }
                if (sqlite3_column_text(statement,10)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,10)] forKey:@"unitName"];
                }
                if (sqlite3_column_text(statement,11)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,11)] forKey:@"IsFeatured"];
                }
                if (sqlite3_column_text(statement,12)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,12)] forKey:@"IsActive"];
                }
                if (sqlite3_column_text(statement,13)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,13)] forKey:@"IsDeleted"];
                }
                if (sqlite3_column_text(statement,14)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,14)] forKey:@"ModifiedOn"];
                }
                if (sqlite3_column_text(statement,15)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,15)] forKey:@"SalePrice"];
                }
            }
        }
        else {
            NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
        }
        sqlite3_finalize(statement);
    }
    
    return dic;
    
    
    
}

- (NSMutableArray *)getLocations{
    NSMutableArray *arr = [NSMutableArray array];
    {
        const char *sql = "Select loc_id,loc_cid,loc_name from Tbl_Loc";
        // const char *sql = "Select cat_id,cat_pid from Tbl_Category";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                if (sqlite3_column_text(statement,0)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)] forKey:@"LocationID"];
                }
                
                if (sqlite3_column_text(statement,1)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)] forKey:@"RefCityId"];
                }
                
                if (sqlite3_column_text(statement,2)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)] forKey:@"LocationName"];
                }
                [arr addObject:dic];
            }
        }
        else {
            NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
        }
        sqlite3_finalize(statement);
    }
    
    return arr;
}


- (NSMutableArray *)getCategory{
     
    NSMutableArray *arr = [NSMutableArray array];
    {
        const char *sql = "Select cat_id,cat_pid,cat_name,cat_desc,cat_image,cat_type,cat_active,cat_deleted,cat_date,sort_order from Tbl_Category where cat_active='Y' order by sort_order";
       // const char *sql = "Select cat_id,cat_pid from Tbl_Category";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                if (sqlite3_column_text(statement,0)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)] forKey:kCatID];
                }
                
                if (sqlite3_column_text(statement,1)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)] forKey:kCatParentID];
                }
                
                if (sqlite3_column_text(statement,2)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)] forKey:kCatName];
                }
                if (sqlite3_column_text(statement,3) )  {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)] forKey:kCatDesc];
                }
                if (sqlite3_column_text(statement,4)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)] forKey:kCatImage];
                }
                if (sqlite3_column_text(statement,5)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)] forKey:kCatType];
                }
                if (sqlite3_column_text(statement,6)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6)] forKey:kCatActive];
                }
                
                if (sqlite3_column_text(statement,7)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,7)] forKey:kCatDeleted];
                }
                if (sqlite3_column_text(statement,8)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,8)] forKey:kCatDate];
                }
                
                if (sqlite3_column_text(statement,9)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,9)] forKey:@"SortOrder"];
                }

                [arr addObject:dic];
            }
        }
        else {
            NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
        }
        sqlite3_finalize(statement);
    }
   
    return arr;
    
}
- (NSMutableArray *)getSubCategory{
    
    NSMutableArray *arr = [NSMutableArray array];
    {
        const char *sql = "Select subCat_id,subCat_pid,subCat_name,subCat_desc,subCat_image,subCat_type,subCat_active,subCat_deleted,subCat_date,sort_order from Tbl_Subcategory where subCat_active='Y' order by sort_order";
        // const char *sql = "Select cat_id,cat_pid from Tbl_Category";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                if (sqlite3_column_text(statement,0)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)] forKey:kCatID];
                }
                
                if (sqlite3_column_text(statement,1)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)] forKey:kCatParentID];
                }
                
                if (sqlite3_column_text(statement,2)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)] forKey:kCatName];
                }
                if (sqlite3_column_text(statement,3) )  {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)] forKey:kCatDesc];
                }
                if (sqlite3_column_text(statement,4)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)] forKey:kCatImage];
                }
                if (sqlite3_column_text(statement,5)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)] forKey:kCatType];
                }
                if (sqlite3_column_text(statement,6)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6)] forKey:kCatActive];
                }
                
                if (sqlite3_column_text(statement,7)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,7)] forKey:kCatDeleted];
                }
                if (sqlite3_column_text(statement,8)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,8)] forKey:kCatDate];
                }
                
                if (sqlite3_column_text(statement,9)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,9)] forKey:@"SortOrder"];
                }
                
                [arr addObject:dic];
            }
        }
        else {
            NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
        }
        sqlite3_finalize(statement);
    }
    
    return arr;
    
}
- (NSMutableArray *)getProducts{
    @try {
       NSMutableArray *arr = [NSMutableArray array];
    {
        const char *sql = "Select p_id,p_cid,p_name,p_ename,p_price,p_max,p_desc,p_img,p_bimg,p_unit,p_unitname, p_isfeatured, p_isactive,p_isdelete,p_date,price_p,price_sort,price_p,p_s_cid,p_marketprice,p_brand,p_skuid from Tbl_Product join tbl_price on tbl_Product.p_id = tbl_price.price_pid  and tbl_Product.p_isactive='Y' and tbl_Product.p_isdelete='N' order by tbl_price.price_sort asc";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self.dbIOF, sql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                if (sqlite3_column_text(statement,0)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)] forKey:@"ProductID"];
                }
                
                if (sqlite3_column_text(statement,1)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)] forKey:@"RefCategoryID"];
                }
                
                if (sqlite3_column_text(statement,2)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)] forKey:@"HindiName"];
                }
                if (sqlite3_column_text(statement,3) )  {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)] forKey:@"ProductName"];
                }
                if (sqlite3_column_text(statement,4)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)] forKey:@"CostPirce"];
                }
                if (sqlite3_column_text(statement,5)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)] forKey:@"MaxLimit"];
                }
                if (sqlite3_column_text(statement,6)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6)] forKey:@"Description"];
                }
                
                if (sqlite3_column_text(statement,7)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,7)] forKey:@"ImgName"];
                }
                
                if (sqlite3_column_text(statement,8)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,8)] forKey:@"BrandImage"];
                }

                
                if (sqlite3_column_text(statement,9)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,9)] forKey:@"Units"];
                }
                if (sqlite3_column_text(statement,10)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,10)] forKey:@"unitName"];
                }
                if (sqlite3_column_text(statement,11)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,11)] forKey:@"IsFeatured"];
                }
                if (sqlite3_column_text(statement,12)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,12)] forKey:@"IsActive"];
                }
                if (sqlite3_column_text(statement,13)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,13)] forKey:@"IsDeleted"];
                }
                if (sqlite3_column_text(statement,14)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,14)] forKey:@"ModifiedOn"];
                }
                
                if (sqlite3_column_text(statement,15)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,15)] forKey:@"SalePrice"];
                }
                
                if (sqlite3_column_text(statement,16)) {
                    [dic setValue:[NSNumber numberWithInt:sqlite3_column_int(statement,16)] forKey:@"PriceSort"];
                }
                
                if (sqlite3_column_text(statement,17)) {
                    [dic setValue:[NSNumber numberWithInt:sqlite3_column_int(statement,17)] forKey:@"price"];
                }
                if (sqlite3_column_text(statement,18)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,18)] forKey:@"RefSubCategoryID"];
                }
                
                if (sqlite3_column_text(statement,19)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,19)] forKey:@"MarketPrice"];
                }
                if (sqlite3_column_text(statement,20)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,20)] forKey:@"BrandName"];
                }
                if (sqlite3_column_text(statement,21)) {
                    [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,21)] forKey:@"SKUID"];
                }

                [arr addObject:dic];
            }
        }
        else {
            NSLog(@"%s",sqlite3_errmsg(self.dbIOF));
        }
        sqlite3_finalize(statement);
    }
    
    return arr;
    }
    @catch (NSException *exception)
    {
    }

}


/*
- (BOOL)insertInspectionIfNotExist:(NSMutableDictionary *)dicInspection{
    BOOL returnValue = NO;
    BOOL found = NO;
    NSString *strProjectID = [dicInspection valueForKey:PROJECTID];
    {
        const char *sql = "Select ProjectID from tblProjects where ProjectID = ?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self.dbLinkbook, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1,[strProjectID UTF8String],-1,SQLITE_TRANSIENT);
            while (sqlite3_step(statement) == SQLITE_ROW) {
                found = YES;
            }
        }
        else {
            NSLog(@"%s",sqlite3_errmsg(self.dbLinkbook));
        }
        sqlite3_finalize(statement);
    }
    
    if (found == YES) {
        return YES;
    }
    
	//Insert Project
    {
		const char *sql = "insert into tblProjects(ProjectID ,ProjectName ,Status ,Username,CompanyID , InspectionDate , StartTime , InspStreet , inspStreet2 , InspCity , InspState , InspZip, updationflag,updationdate,SyncStatus,SyncDate,ClientFirstName,ClientLastName,dateCompleted) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		sqlite3_stmt *statement;
		if (sqlite3_prepare_v2(self.dbLinkbook, sql, -1, &statement, NULL) == SQLITE_OK) {
			sqlite3_bind_text(statement, 1,[strProjectID UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2,[[dicInspection valueForKey:PROJECTNAME] UTF8String],-1,SQLITE_TRANSIENT);
            if ([dicInspection valueForKey:STATUS]) {
                sqlite3_bind_text(statement, 3,[[dicInspection valueForKey:STATUS] UTF8String],-1,SQLITE_TRANSIENT);
            }
            else{
                sqlite3_bind_text(statement, 3,"OPEN",-1,SQLITE_TRANSIENT);
            }
            
            sqlite3_bind_text(statement, 4,[[[[LinkbookDB sharedManager] getProfile] valueForKey:USERNAME] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5,[[[[LinkbookDB sharedManager] getProfile] valueForKey:COMPANYID] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 6,[[dicInspection valueForKey:INSPDATE] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 7,[[dicInspection valueForKey:INSPSTARTTIME] UTF8String] ,-1,SQLITE_TRANSIENT);


            NSMutableDictionary *dic = [dicInspection valueForKey:INSPADDRESS];
            sqlite3_bind_text(statement, 8,[[dic valueForKey:STREET] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 9,[[dic valueForKey:STREET1] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 10,[[dic valueForKey:CITY] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 11,[[dic valueForKey:STATE] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 12,[[dic valueForKey:ZIP] UTF8String],-1,SQLITE_TRANSIENT);

            sqlite3_bind_text(statement, 13,[lnkbkDB.glbCurrentMode UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 14,[[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 15,[NOTSYNC UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 16,[[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 17,[[dicInspection valueForKey:CLIENTFIRSTNAME] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 18,[[dicInspection valueForKey:CLIENTLASTNAME] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 19,[[dicInspection valueForKey:INSPDATECOMPLETED] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_step(statement);
            returnValue = YES;
		}
		else {
			NSLog(@"%s",sqlite3_errmsg(self.dbLinkbook));
		}
		sqlite3_finalize(statement);
	}
    
    return returnValue;
}

- (BOOL)deleteProjectInspectors:(NSString *)strProjectID{
    BOOL returnValue = NO;
	{
		const char *sql = "delete from tblProjectInspectors where projectid = ?";
		sqlite3_stmt *statement;
		if (sqlite3_prepare_v2(self.dbLinkbook, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1,[strProjectID UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_step(statement);
            returnValue = YES;
		}
		else {
			NSLog(@"%s",sqlite3_errmsg(self.dbLinkbook));
		}
		sqlite3_finalize(statement);
	}
    return returnValue;
}

- (BOOL)updateInspection:(NSMutableDictionary *)dicInspection{
    BOOL returnValue = NO;
	{
		const char *sql = "update tblProjects set ProjectName = ?,Status = ?,Username = ?,CompanyID = ?, InspectionType = ?, InspectionSubType = ?, InspectionDate = ?, StartTime = ?, StartTime = ?, ClientFirstName = ?, ClientLastName = ?, ClientStreet = ?, ClientStreet2 = ?, ClientCity = ?, ClientState = ?, ClientZip = ?, ClientContactNumber = ?, InspStreet = ?, inspStreet2 = ?, InspCity = ?, InspState = ?, InspZip = ?, AccessBy = ?, PeoplePresent = ?,updationflag = ?,updationdate = ?, inspectionfee = ?,samplingfee = ?, otherfee = ?, ClientAddSameAsInspAdd = ?,dateCompleted = ?,labResult = ? where ProjectID = ?";
		sqlite3_stmt *statement;
		if (sqlite3_prepare_v2(self.dbLinkbook, sql, -1, &statement, NULL) == SQLITE_OK) {
            
            sqlite3_bind_text(statement, 1,[[dicInspection valueForKey:PROJECTNAME] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2,[[dicInspection valueForKey:STATUS] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3,[[[[LinkbookDB sharedManager] getProfile] valueForKey:USERNAME] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4,[[[[LinkbookDB sharedManager] getProfile] valueForKey:COMPANYID] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5,[[dicInspection valueForKey:INSPTYPE] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 6,[[dicInspection valueForKey:INSPSUBTYPE] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 7,[[dicInspection valueForKey:INSPDATE] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 8,[[dicInspection valueForKey:INSPSTARTTIME] UTF8String] ,-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 9,[[dicInspection valueForKey:INSPSTARTTIME] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 10,[[dicInspection valueForKey:CLIENTFIRSTNAME] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 11,[[dicInspection valueForKey:CLIENTLASTNAME] UTF8String] ,-1,SQLITE_TRANSIENT);
            NSMutableDictionary *dic = [dicInspection valueForKey:CLIENTADDRESS];
            
            sqlite3_bind_text(statement, 12,[[dic valueForKey:STREET] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 13,[[dic valueForKey:STREET1] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 14,[[dic valueForKey:CITY] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 15,[[dic valueForKey:STATE] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 16,[[dic valueForKey:ZIP] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 17,[[dicInspection valueForKey:CLIENTCONTACTNUMBER] UTF8String],-1,SQLITE_TRANSIENT);
            dic = [dicInspection valueForKey:INSPADDRESS];
            sqlite3_bind_text(statement, 18,[[dic valueForKey:STREET] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 19,[[dic valueForKey:STREET1] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 20,[[dic valueForKey:CITY] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 21,[[dic valueForKey:STATE] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 22,[[dic valueForKey:ZIP] UTF8String],-1,SQLITE_TRANSIENT);
            NSString *strData = @"";
            for (NSMutableDictionary *dic in [dicInspection valueForKey:INSPACCESSBY]) {
                if (strData.length <= 0) {
                    strData = [dic valueForKey:@"Value"];
                }
                else{
                    strData = [NSString stringWithFormat:@"%@, %@",strData, [dic valueForKey:@"Value"]];
                }
            }
            sqlite3_bind_text(statement, 23,[strData UTF8String],-1,SQLITE_TRANSIENT);
            
            strData = @"";
            for (NSMutableDictionary *dic in [dicInspection valueForKey:INSPPEOPLEPRESENT]) {
                if (strData.length <= 0) {
                    strData = [dic valueForKey:@"Value"];
                }
                else{
                    strData = [NSString stringWithFormat:@"%@, %@",strData, [dic valueForKey:@"Value"]];
                }
            }
            sqlite3_bind_text(statement, 24,[strData UTF8String],-1,SQLITE_TRANSIENT);
            
            sqlite3_bind_text(statement, 25,[lnkbkDB.glbCurrentMode UTF8String],-1,SQLITE_TRANSIENT);
            
            sqlite3_bind_text(statement, 26,[[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 27,[[dicInspection valueForKey:INSPECTIONFEE] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 28,[[dicInspection valueForKey:INSPSAMPLINGFEE] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 29,[[dicInspection valueForKey:INSPOTHERFEE] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 30,[[dicInspection valueForKey:COPYADDFROMINSPADD] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 31,[[dicInspection valueForKey:INSPDATECOMPLETED] UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 32,[[dicInspection valueForKey:INSPLABRESULT] UTF8String],-1,SQLITE_TRANSIENT);
            NSLog(@"%@",[dicInspection valueForKey:PROJECTID]);
            sqlite3_bind_text(statement, 33,[[dicInspection valueForKey:PROJECTID] UTF8String],-1,SQLITE_TRANSIENT);
            
            sqlite3_step(statement);
            returnValue = YES;
		}
		else {
			NSLog(@"%s",sqlite3_errmsg(self.dbLinkbook));
		}
		sqlite3_finalize(statement);
	}
    return returnValue;
}

- (NSMutableArray *)getLabCodes:(NSString *)strLabCode strSampleType:(NSString *)strSampleType{
    NSMutableArray *arr = [NSMutableArray array];
    {
        const char *sql = "Select testcode from tbllabcodes where labid = ? and testtype = ?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self.dbLinkbook, sql, -1, &statement, NULL) == SQLITE_OK) {
            NSLog(@"%@",strLabCode);
            sqlite3_bind_text(statement, 1,[strLabCode UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2,[strSampleType UTF8String],-1,SQLITE_TRANSIENT);
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                [arr addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)]];
            }
        }
        else {
            NSLog(@"%s",sqlite3_errmsg(self.dbLinkbook));
        }
        sqlite3_finalize(statement);
    }
    
	return arr;
}
*/


#pragma mark Singleton Methods
+ (id)sharedManager {
    @synchronized(self) {
        if(lnkbkDB == nil){
            lnkbkDB = [[super allocWithZone:NULL] init];
            [lnkbkDB createEditableCopyOfDatabaseIfNeeded];
            [lnkbkDB UpdateDatabaseIfNeeded];
        }
    }
    return lnkbkDB;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
    [super dealloc];
}

- (unsigned)retainCount {
    return UINT_MAX; //denotes an object that cannot be released
}

- (oneway void)release {
    // never release
}

- (id)autorelease {
    return self;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}


@end
