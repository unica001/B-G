//
//  SporeRxDB.h
//  SporeRx
//
//  Created by ITGC on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface IOFDB : NSObject{
	sqlite3 *dbIOF;
    NSMutableArray *mArrCategories;
      NSMutableArray *mArrProducts;
     NSMutableArray *mArrLocations;
    NSMutableArray *mArrLookups;
}

@property (nonatomic) sqlite3 *dbIOF;
@property (nonatomic,retain) NSMutableArray *mArrCategories;
@property (nonatomic,retain) NSMutableArray *mArrLookups;
@property (nonatomic,retain) NSMutableArray *mArrProducts;
@property (nonatomic,retain) NSMutableArray *mArrLocations;
@property (nonatomic,retain) NSMutableArray *mArrSubCategories;

+(id)sharedManager;

-(BOOL)OpenSporeRxDatabaseConnection;
-(BOOL)OpenSporeRxTMPDataBaseConnection;
-(BOOL)CloseSporeRxDatabaseConnection;
-(void)makeTmpDatabase;
-(void)ReplaceWithMainDB;
-(NSMutableArray*) getProductByIds:(NSArray*)arrIds;
-(NSMutableDictionary*)getProductById:(NSString*)strID;
- (BOOL)insertCategory:(NSMutableArray *)arrServices;
- (BOOL)insertSubCategory:(NSMutableArray *)arrServices;
- (BOOL)insertLocation:(NSMutableArray *)arrServices;
-(BOOL)insertProduct:(NSMutableArray *)arrServices;
-(BOOL)insertPrice:(NSMutableArray *)arrServices;
- (BOOL)updateSortOrder:(NSMutableArray *)arrSort;
- (BOOL)insertNotification:(NSMutableArray *)notificationArr;
- (BOOL)deleteAllCategories;
- (BOOL)deleteAllSubCategories;
- (BOOL)deleteAllProducts;
- (BOOL)deleteAllPrice;
- (BOOL)deleteAllLocation;
-(BOOL) deleteDataBaseDate;
-(BOOL)deleteAllNotifications;
- (BOOL)deleteNotificationsUsingId :(NSString *)Id;
-(BOOL) insertDate :(NSString*)currentDate;
- (NSMutableArray *)getProducts;
- (NSMutableArray *)getLocations;
-(NSString*) getDateFromDataBase;
- (NSMutableArray *)getCategory;
- (NSMutableArray *)getSubCategory;
- (NSMutableArray *)getNotification;

-(void)StartTransaction;
-(void)EndTransaction;

@end
