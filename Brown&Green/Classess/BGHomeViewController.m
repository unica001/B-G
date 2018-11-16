//
//  BGHomeViewController.m
//  Brown&Green
//
//  Created by vineet patidar on 26/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "BGHomeViewController.h"
#import "HomeCell.h"
#import "HomeCollectionCell.h"
#import "OfferCell.h"
#import "WarningViewController.h"

@interface BGHomeViewController (){
    UILabel *badgeLabel;
    AppDelegate*appDelegate;
    UIActivityIndicatorView *activityIndicator;
    NSTimer *timer;
}

@end

@implementation BGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", [kUserDefault valueForKey:kTutorial]);

if (![[Utility replaceNULL:[[kUserDefault valueForKey:kTutorial] valueForKey:khomeTutorial] value:@""] isEqualToString:@"NO"]) {         //  add tutorial
        SSTutorialViewController *tutorialView = [[SSTutorialViewController alloc]initWithNibName:@"SSTutorialViewController" bundle:[NSBundle mainBundle]];
        tutorialView.incomingViewType = khomeTutorial;
        [self presentViewController:tutorialView animated:YES completion:nil];
    }
    
    
    _offerTable.hidden = YES;
    pageControl.hidden =  YES;
     messageLabel.hidden = YES;
    
    _homeTableView.layer.cornerRadius = 5.0;
    [_homeTableView.layer setMasksToBounds:YES];

      SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
        {
            [_revealMenu setTarget: self.revealViewController];
            [_revealMenu setAction: @selector( revealToggle: )];
            [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        }
    
    self.revealViewController.delegate = self;
    
    
    
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
    [activityIndicator startAnimating];
    
    _homeTableView.tableHeaderView = activityIndicator;
    
    // [self getDataFromLocalJsonFile];
   // [self databaseSync];
    
    // get data from local DB or sync from server
    iofDB = [IOFDB sharedManager];
    
    if ([iofDB getDateFromDataBase]==nil){
        [self getDataFromLocalJsonFile];
    }
    else{
        [self databaseSync];
    }

    
    // bucket product count label
    badgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kiPhoneWidth-20, 1, 20, 20)];
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.layer.cornerRadius = 10;
    [badgeLabel.layer setMasksToBounds:YES];
    badgeLabel.backgroundColor = kDefaultLightGreen;
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.font = [UIFont systemFontOfSize:12];
    [self.navigationController.navigationBar addSubview:badgeLabel];
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    // google analytics
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Home Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
    NSString *redirectScreen = [kUserDefault valueForKey:kMyCartInGuestUser];

      if (![[Utility replaceNULL:[kUserDefault valueForKey:kGuestUser] value:@""] isEqualToString:kGuestUser] && appDelegate.checkProductArray.count>0 && [redirectScreen isEqualToString:kMyCartInGuestUser]) {
        [kUserDefault setValue:@"" forKey:kGuestUserInComingScreen];
        [kUserDefault setValue:@"" forKey:kMyCartInGuestUser];
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        BGDeliveryScheduleViewController *scheduleViewController =[storyBoard instantiateViewControllerWithIdentifier:@"BGDeliveryScheduleStoryBoardID"];
        [self.navigationController pushViewController:scheduleViewController animated:YES];
    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    
 
    
    isRowSelected = NO;
    self.navigationController.navigationBarHidden = NO;
    
    if (appDelegate.checkProductArray.count>0) {
        badgeLabel.hidden = NO;
        
        badgeLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)appDelegate.checkProductArray.count];
    }
    else{
        badgeLabel.hidden = YES;
        badgeLabel.text = @"";
        
    }
    
    basketImageView.image = [UIImage imageNamed:@""];
    pageControl.currentPage = 0;
    // get banner images
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    BannerServer *noti = [[BannerServer alloc] initWithDict:dict];
    noti.requestDelegate=self;
    [noti startAsynchronous];
    
    [self recordScreenView];
    
}



-(void)viewWillDisappear:(BOOL)animated{
    badgeLabel.hidden = YES;
    
}

// Manually record "screen views" as user selects tabs.
- (void)recordScreenView {
    // These strings must be <= 36 characters long in order for setScreenName:screenClass: to succeed.
    NSString *screenName = @"Home Screen";
    NSString *screenClass = [self.classForCoder description];
    
    // [START set_current_screen]
    [FIRAnalytics setScreenName:screenName screenClass:screenClass];
    // [END set_current_screen]
}
-(void)myCartView{
    
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     // kFIRParameterItemID:[NSString stringWithFormat:@"SubCategoryid-%@", [[subCategoryArray objectAtIndex:0]valueForKey:@"CategoryID"]],
                                     kFIRParameterItemName:@"Cart",
                                     kFIRParameterContentType:@"button"
                                     }];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MyCartViewController *cartView = [storyBoard instantiateViewControllerWithIdentifier:kMyCartStoryBoardID];
    cartView.incomingType = kProduct;
    [self.navigationController pushViewController:cartView animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UIView *)setSectionView:(NSInteger)index{
    
    NSMutableDictionary *dict = [iofDB.mArrCategories objectAtIndex:index];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 100)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *BGImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, headerView.frame.size.height)];
    
    [headerView addSubview:BGImageView];
    
    /*  UIView *view = [[UIView alloc]initWithFrame:headerView.frame];
     view.backgroundColor = [UIColor blackColor];
     view.alpha = 0.4;
     [headerView addSubview:view];*/
    
    
    UIImageView *profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
    profileImageView.backgroundColor = [UIColor clearColor];
    profileImageView.layer.cornerRadius = 3.0;
    [profileImageView.layer setMasksToBounds: YES];
    // profileImageView.image = [UIImage imageNamed:@""];
    [headerView addSubview:profileImageView];
    
    UILabel *categoryName = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, kiPhoneWidth-125, 20)];
    categoryName.backgroundColor = [UIColor clearColor];
    categoryName.font = [UIFont boldSystemFontOfSize:14];
    categoryName.textColor = [UIColor darkGrayColor];
    categoryName.text = [dict valueForKey:@"CategoryName"];
    [headerView addSubview:categoryName];
    
    UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(kiPhoneWidth-45, (headerView.frame.size.height-10)/2, 20, 20)];
    arrowImage.backgroundColor = [UIColor clearColor];
    arrowImage.tag = 500+index;
    arrowImage.image = [UIImage imageNamed:@"DropDown"];
    [headerView addSubview:arrowImage];
    
    //  line view
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height-1,kiPhoneWidth-20, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:lineView];
    
    if ([selectedSectionDictionary isEqual:[iofDB.mArrCategories objectAtIndex:index]]) {
        arrowImage.image = [UIImage imageNamed:@"Dropup"];
        lineView.hidden = YES;
    }
    else{
        lineView.hidden = NO;
    }
    
    // set profile image
    
    NSString *imageName =[dict valueForKey:@"CategoryImage"];
    NSString *finalImageUrl;
    finalImageUrl = [NSString stringWithFormat:@"%@%@",kBCatImageUrl,imageName];
    
    
    
    [profileImageView sd_setImageWithURL:[NSURL URLWithString:finalImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
    
    /*  [BGImageView sd_setImageWithURL:[NSURL URLWithString:finalImageUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached];*/
    
    
    // section top button
    
    UIButton *sectionButton = [[UIButton alloc]initWithFrame:headerView.frame];
    [sectionButton addTarget:self action:@selector(sectionButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
    sectionButton.tag = index;
    [headerView addSubview:sectionButton];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%@",@"ParentCategoryID",[[iofDB.mArrCategories objectAtIndex:index] valueForKey:@"CategoryID"]];
    NSMutableArray *array = [[iofDB.mArrSubCategories filteredArrayUsingPredicate:predicate] mutableCopy];
    
    
    // if not having product in categories, check sub categories
    if (array.count==0)
    {
        arrowImage.hidden = YES;
    }
    else{
        arrowImage.hidden = NO;
    }
    return headerView;
}

#pragma mark - Table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_segment.selectedSegmentIndex == 1) {
        return 1;
    }
    return iofDB.mArrCategories.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_segment.selectedSegmentIndex == 0) {
        return [self setSectionView:section];}
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_segment.selectedSegmentIndex ==0) {
        return 100;
    }
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView  *view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kiPhoneWidth-20, 10)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_segment.selectedSegmentIndex == 0) {
        if ([selectedSectionDictionary isEqual:[iofDB.mArrCategories objectAtIndex:section]]) {
            return 1;
        }
    }
    else if (_segment.selectedSegmentIndex == 1){
        return [self.offerArr count];
    }
    return 0;
}


-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (selectedINdex == indexPath.row) {
        selectedINdex =  indexPath.row;
        if (selectedSectionDictionary) {
            [selectedSectionDictionary removeAllObjects];
        }
    }
   
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_segment.selectedSegmentIndex == 0) {
        
        static NSString *cellIdentifier3  =@"cell";
        
        HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"HomeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        // add collection view in cell
        
        NSInteger  row = filterSubCategoryArray.count%3;
        if (row>0) {
            row = (filterSubCategoryArray.count/3)+1;
        }else{
            row = filterSubCategoryArray.count/3;
        }
        
        
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        UICollectionView *_collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kiPhoneWidth-20, 120*(row+1)) collectionViewLayout:layout];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
        [cell.contentView addSubview:_collectionView];
        cell.backgroundColor = [UIColor clearColor];

        
        
        return cell;
        
    }
    else if ( _segment.selectedSegmentIndex ==1){
        
        static NSString *cellIdentifier3  =@"cell";
        
        OfferCell *cell = [_offerTable dequeueReusableCellWithIdentifier:cellIdentifier3];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"OfferCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        [cell setData:[_offerArr objectAtIndex:indexPath.row] type:@"home"];
        
        
        return cell;
        
    }
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_segment.selectedSegmentIndex ==0) {
        
        if ([selectedSectionDictionary isEqual:[iofDB.mArrCategories objectAtIndex:indexPath.section]]) {
            
            NSInteger  row = filterSubCategoryArray.count%3;
            if (row>0) {
                row = (filterSubCategoryArray.count/3)+1;
            }
            else{
                row = filterSubCategoryArray.count/3;
            }
            return (120*(row));
        }
        return 0;
    }
    else if (_segment.selectedSegmentIndex ==1){
        
        double height = 0.0;
        
        NSString *title = [[_offerArr objectAtIndex:indexPath.row] valueForKey:@"PromoTitle"];
        NSString *subTitle = [[_offerArr objectAtIndex:indexPath.row] valueForKey:@"PromoDetails"];
        
        
        if ( [Utility getTextHeight:title size:CGSizeMake(kiPhoneWidth-80, CGFLOAT_MAX) font:kDefaultFontForApp] >20) {
            
            height = [Utility getTextHeight:title size:CGSizeMake(kiPhoneWidth-80, CGFLOAT_MAX) font:kDefaultFontForApp]-20;
        }
        else {
            height = 0;
        }
        
        
        if ( [Utility getTextHeight:subTitle size:CGSizeMake(kiPhoneWidth- 80, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium] >20) {
            
            height = ([Utility getTextHeight:subTitle size:CGSizeMake(kiPhoneWidth-80, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium]-20)+height;
        }
        else {
            height = 0+height;
        }
        
        return 83+height;
    }
    return 0;
}

#pragma mark - Collection view delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return filterSubCategoryArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UIImageView *profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, cell.contentView.frame.size.width-50,cell.contentView.frame.size.width-50)];
    profileImageView.layer.cornerRadius = 5.0;
    [profileImageView.layer setMasksToBounds:YES];
    [cell.contentView addSubview:profileImageView];
    
    // sub category name label
    
    UILabel *subCategoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, profileImageView.frame.origin.y+profileImageView.frame.size.height+1, cell.contentView.frame.size.width-10, 32)];
    subCategoryLabel.backgroundColor = [UIColor clearColor];
    subCategoryLabel.textAlignment = NSTextAlignmentCenter;
    subCategoryLabel.font = [UIFont systemFontOfSize:13];
    subCategoryLabel.textColor = [UIColor darkGrayColor];
    subCategoryLabel.numberOfLines = 0;
    [cell.contentView addSubview:subCategoryLabel];
    
    
    NSString *subCatName=[[ filterSubCategoryArray objectAtIndex:indexPath.row] valueForKey:@"CategoryName"];
    subCategoryLabel.text = subCatName;
    
    
    NSString *subCatImage=[[filterSubCategoryArray objectAtIndex:indexPath.row] valueForKey:@"CategoryImage"];
    NSString *finalBImageUrl = [NSString stringWithFormat:@"%@%@",kBCatImageUrl,subCatImage];
    
    [profileImageView sd_setImageWithURL:[NSURL URLWithString:finalBImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageRefreshCached];
    
    // cell.backgroundColor = [UIColor lightGrayColor];
    
    cell.layer.cornerRadius = 5.0;
    [cell.layer setMasksToBounds:YES];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kiPhoneWidth-60)/3,(kiPhoneWidth-60)/3);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 9, 5, 9);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%@",@"ParentCategoryID",[[ filterSubCategoryArray objectAtIndex:indexPath.row] valueForKey:@"CategoryID"]];
    NSMutableArray *subCategoryArray = [[iofDB.mArrSubCategories filteredArrayUsingPredicate:predicate] mutableCopy];
    
    if (subCategoryArray.count>0) {
        
        BGSubCategoryViewController *subCategoryViewController = [[BGSubCategoryViewController alloc]init];
        subCategoryViewController.subCategoryArray = subCategoryArray;
        subCategoryViewController.title = [[filterSubCategoryArray objectAtIndex:indexPath.row] valueForKey:@"CategoryName"];;
        
        [FIRAnalytics logEventWithName:kFIREventSelectContent
                            parameters:@{
                                         // kFIRParameterItemID:[NSString stringWithFormat:@"SubCategoryid-%@", [[subCategoryArray objectAtIndex:0]valueForKey:@"CategoryID"]],
                                         kFIRParameterItemName:[NSString stringWithFormat:@"%@", subCategoryViewController.title],
                                         kFIRParameterContentType:[NSString stringWithFormat:@"SubCategoryName-%@", subCategoryViewController.title]
                                         }];
        
        [self.navigationController pushViewController:subCategoryViewController animated:YES];
    }
    else{
        title = [[ filterSubCategoryArray objectAtIndex:indexPath.row] valueForKey:@"CategoryName"];
        
        [FIRAnalytics logEventWithName:kFIREventSelectContent
                            parameters:@{
                                         // kFIRParameterItemID:[NSString stringWithFormat:@"SubCategoryid-%@", [[filterSubCategoryArray objectAtIndex:0]valueForKey:@"CategoryID"]],
                                         kFIRParameterItemName:[NSString stringWithFormat:@"%@", title],
                                         kFIRParameterContentType:[NSString stringWithFormat:@"SubCategoryName-%@", title]
                                         }];
        [self performSegueWithIdentifier:kproductDetailSegueIdentifier sender:[filterSubCategoryArray objectAtIndex:indexPath.row]];
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kproductDetailSegueIdentifier]) {
        BGProductViewController *productViewController = segue.destinationViewController;
        
        if ([sender isKindOfClass:[NSString class]]) {
            productViewController.fromSearch = sender;
        }
        else{
            productViewController.dicCategory = sender;
            
        }
        productViewController.title =  title;
    }
    else if([segue.identifier isEqualToString:kVerify])
    {
        WarningViewController *warningViewController=segue.destinationViewController;
        if ([sender isKindOfClass:[NSString class]]) {
            warningViewController.fromSearch = sender;
        }
        else{
            warningViewController.dicCategory = sender;
            
        }
        warningViewController.title =  title;
        
    }
    
}


#pragma  mark - data Sync

-(void)databaseSync{
//[Utility ShowMBHUDLoader];
    
    iofDB = [IOFDB sharedManager];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"d-MMM-yyyy"];
    
    NSString *lastUpdatedRecordDate = [iofDB getDateFromDataBase];
    [[NSUserDefaults standardUserDefaults] setObject:lastUpdatedRecordDate forKey:@"lastSyncDate"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:lastUpdatedRecordDate forKey:@"FilterDate"];
    TabelRecords *signup = [[TabelRecords alloc] initWithDict:dict];
    signup.requestDelegate=self;
    [signup startAsynchronous];
    
}


- (void)tabelRecordsRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData{
    [Utility hideMBHUDLoader];
    
        //_homeTableView.tableHeaderView = nil;
    [activityIndicator stopAnimating];
    [[NSUserDefaults standardUserDefaults] setObject:[inData objectForKey:@"CurrentDate"] forKey:@"currentDate"];
    NSMutableDictionary *payLoadDic = [inData objectForKey:@"Payload"];
    NSString *currentDate = [inData objectForKey:@"CurrentDate"];
    [[IOFDB sharedManager] deleteDataBaseDate];
    [[IOFDB sharedManager] insertCategory:[payLoadDic valueForKey:kCatList]];
    if(![[payLoadDic valueForKey:kSubCatList] isEqual:[NSNull null]])
        [[IOFDB sharedManager] insertSubCategory:[payLoadDic valueForKey:kSubCatList]];
    if(![[payLoadDic valueForKey:kProductList] isEqual:[NSNull null]])
        [[IOFDB sharedManager] insertProduct :[payLoadDic valueForKey:kProductList]];
    [[IOFDB sharedManager] insertLocation:[payLoadDic valueForKey:kLocationList]];
    [[IOFDB sharedManager] insertPrice:[payLoadDic valueForKey:kPriceList]];
    
    if(![[payLoadDic valueForKey:@"ProductSortList"] isEqual:[NSNull null]]){
        [[IOFDB sharedManager] updateSortOrder:[payLoadDic valueForKey:@"ProductSortList"]];
    }
    
    [[IOFDB sharedManager] insertDate:currentDate];
    iofDB.mArrCategories = [iofDB getCategory];
    iofDB.mArrSubCategories=[iofDB getSubCategory];
    iofDB.mArrProducts = [iofDB getProducts];
    iofDB.mArrLocations = [iofDB getLocations];
    self.dataBaseDate = [iofDB getDateFromDataBase];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"d-MMM-yyyy hh:mm a"];
    NSString *lastSyncDate = [format stringFromDate:[NSDate date]];
    [[NSUserDefaults standardUserDefaults] setValue:lastSyncDate forKey:@"lastSyncDate"];
   /* dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void)
                   {
                       [[NSUserDefaults standardUserDefaults] setObject:[inData objectForKey:@"CurrentDate"] forKey:@"currentDate"];
                       NSMutableDictionary *payLoadDic = [inData objectForKey:@"Payload"];
                       NSString *currentDate = [inData objectForKey:@"CurrentDate"];
                       [[IOFDB sharedManager] deleteDataBaseDate];
                       [[IOFDB sharedManager] insertCategory:[payLoadDic valueForKey:kCatList]];
                       if(![[payLoadDic valueForKey:kSubCatList] isEqual:[NSNull null]])
                       [[IOFDB sharedManager] insertSubCategory:[payLoadDic valueForKey:kSubCatList]];
                       if(![[payLoadDic valueForKey:kProductList] isEqual:[NSNull null]])
                       [[IOFDB sharedManager] insertProduct :[payLoadDic valueForKey:kProductList]];
                       [[IOFDB sharedManager] insertLocation:[payLoadDic valueForKey:kLocationList]];
                       [[IOFDB sharedManager] insertPrice:[payLoadDic valueForKey:kPriceList]];
                       
                       if(![[payLoadDic valueForKey:@"ProductSortList"] isEqual:[NSNull null]]){
                           [[IOFDB sharedManager] updateSortOrder:[payLoadDic valueForKey:@"ProductSortList"]];
                       }
                       
                       [[IOFDB sharedManager] insertDate:currentDate];
                       iofDB.mArrCategories = [iofDB getCategory];
                       iofDB.mArrSubCategories=[iofDB getSubCategory];
                       iofDB.mArrProducts = [iofDB getProducts];
                       iofDB.mArrLocations = [iofDB getLocations];
                       self.dataBaseDate = [iofDB getDateFromDataBase];
                       NSDateFormatter *format = [[NSDateFormatter alloc] init];
                       [format setDateFormat:@"d-MMM-yyyy hh:mm a"];
                       NSString *lastSyncDate = [format stringFromDate:[NSDate date]];
                       [[NSUserDefaults standardUserDefaults] setValue:lastSyncDate forKey:@"lastSyncDate"];

                       
                       dispatch_sync(dispatch_get_main_queue(), ^(void)
                                     {
                                        
                                         [_homeTableView reloadData];
                                         [activityIndicator stopAnimating];
                                         _homeTableView.tableHeaderView = nil;
      
                                     });
                   });*/
    [_homeTableView reloadData];
    
}
-(void) getDataFromLocalJsonFile{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
            //_homeTableView.tableHeaderView  =  nil;
        [activityIndicator stopAnimating];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"databaselocalData" ofType:@"json"];
        
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSMutableDictionary *mainDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSMutableDictionary *payLoadDic = [mainDict objectForKey:@"Payload"];
        NSString *currentDate = [mainDict objectForKey:@"CurrentDate"];
        
        [[IOFDB sharedManager] StartTransaction];
        [[IOFDB sharedManager] deleteAllCategories];
        [[IOFDB sharedManager] deleteAllSubCategories];
        [[IOFDB sharedManager] deleteAllProducts];
        [[IOFDB sharedManager] deleteAllPrice];
        [[IOFDB sharedManager] deleteAllLocation];
        [[IOFDB sharedManager] deleteDataBaseDate];
        [[IOFDB sharedManager] insertCategory:[payLoadDic valueForKey:kCatList]];
        if(![[payLoadDic valueForKey:kSubCatList] isEqual:[NSNull null]])
            [[IOFDB sharedManager] insertSubCategory:[payLoadDic valueForKey:kSubCatList]];
        [[IOFDB sharedManager] insertProduct:[payLoadDic valueForKey:kProductList]];
        [[IOFDB sharedManager] insertLocation:[payLoadDic valueForKey:kLocationList]];
        [[IOFDB sharedManager] insertPrice :[payLoadDic valueForKey:kPriceList]];
        if (![[payLoadDic valueForKey:@"ProductSortList"]isKindOfClass:[NSNull class]]) {
            [[IOFDB sharedManager] updateSortOrder:[payLoadDic valueForKey:@"ProductSortList"]];
        }
        
        [[IOFDB sharedManager] insertDate:currentDate];
        [[IOFDB sharedManager] EndTransaction];
        
        //this is background thread
        //here write you code which you want to execute on Background thread:
        //once the code has executed the execution will be thrown to below method
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //this is main thread
            //after completing the background thread code , the execution will come here
            //from here go where ever you want or do here what ever you want
            //but make sure here whatever u do will be on main thread
            
            
            iofDB.mArrCategories = [iofDB getCategory];
            iofDB.mArrSubCategories=[iofDB getSubCategory];
            iofDB.mArrProducts = [iofDB getProducts];
            iofDB.mArrLocations = [iofDB getLocations];
            self.dataBaseDate = [iofDB getDateFromDataBase];
            [_homeTableView reloadData];
    
           [self databaseSync];
            
        });
    });
    
}

- (void)tabelRecordsRequestFailedWithErrorMessage:(NSString *)inMessage
{
    [Utility hideMBHUDLoader];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:inMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    
}


#pragma  mark - APIs call

// offers
-(void)offerServerFinishedWithSuccessMessage:(NSMutableDictionary *)inData{
    [Utility hideMBHUDLoader];
    messageLabel.hidden = true;
    [UtilityPlist saveData:inData fileName:kOffer];
    self.offerArr = [inData valueForKey:@"Payload"];
    [_offerTable reloadData];
}

-(void)offerServerFailedWithErrorMessage:(NSString *)inFailedData{
    [Utility hideMBHUDLoader];
    
    if ([inFailedData isEqualToString:@"Sorry, no matching records found to be displayed."])
    {
        
        [UtilityPlist saveData:nil fileName:kOffer];
        self.offerArr = [[NSMutableArray alloc]init];
        [_offerTable reloadData];
        _offerTable.hidden= true;
        messageLabel.hidden = false;
        messageLabel.text = @"No record found.";
        
    }
}


// banner APIS call
-(void)BannerServerFinishedWithSuccessMessage:(NSMutableDictionary *)inData
{
    self.bannerArr = [inData valueForKey:@"Payload"];
    imageBannerArr = [[NSMutableArray alloc] init];
    textBannerArr = [[NSMutableArray alloc] init];
    imageArr = [[NSMutableArray alloc] init];
    titleArr = [[NSMutableArray alloc] init];
    desArray= [[NSMutableArray alloc] init];
    imageArrayOfUrl = [[NSMutableArray alloc] init];
    navigationArr = [[NSMutableArray alloc] init];
    
    for (int j = 0; j<self.bannerArr.count; j++)
    {
        NSString *type = [[self.bannerArr objectAtIndex:j] valueForKey:@"LookupValue"];
        NSMutableDictionary *dict = [self.bannerArr objectAtIndex:j];
        if ([type isEqualToString:@"Image Banner"])
        {
            [imageBannerArr addObject:dict];
            if ([[dict valueForKey:@"iOSImage"] isEqualToString:@""]) {
                
            }
            else{
                [imageArr addObject:[dict valueForKey:@"iOSImage"]];
            }
            
            [navigationArr addObject:[dict valueForKey:@"navigation_key"]];
        }
        else
        {
            [textBannerArr addObject:dict];
            
        }
    }
    
    pageControl.numberOfPages = self.bannerArr.count;
    
    imageArrayOfUrl = [self.bannerArr valueForKey:@"iOSImage"];
    
    if (imageArrayOfUrl.count>0) {
        [self changeBannerImage:5.0];
    }
    [_homeTableView reloadData];
}


-(void)BannerServerFailedWithErrorMessage:(NSString *)inFailedData
{
    
}

#pragma  mark -  change banner image

-(void)changeBannerImage:(NSInteger)timeInterval
{
   
    [_mainScrollView addSubview:({
        
        LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0,0, kiPhoneWidth,_mainScrollView.frame.size.height)
                                                            delegate:self
                                                           imageURLs:imageArrayOfUrl
                                                placeholderImageName:nil
                                                        timeInterval:timeInterval
                                       currentPageIndicatorTintColor:[UIColor redColor]
                                              pageIndicatorTintColor:[UIColor whiteColor]];
        bannerView.hidePageControl = YES;
        self.bannerView2 = bannerView;
    })];
   
    
    [self performSelector:@selector(changed) withObject:nil afterDelay:5.0f];
  
}

- (void)changed {
    
    NSArray *URLs = imageArrayOfUrl;
    self.bannerView2.imageURLs = URLs;
    
}

- (void)bannerView:(LCBannerView *)bannerView didClickedImageIndex:(NSInteger)index {

    [self changeBannerImage:60*60*24];
    

}

- (void)bannerView:(LCBannerView *)bannerView didScrollToIndex:(NSInteger)index {

}

#pragma  mark - button clicked

-(void)sectionButton_clicked:(UIButton *)sender{
    
    if (isRowSelected == NO) {
        isRowSelected = YES;
        selectedINdex = sender.tag+1;

        [self addRemoveSubcateforyOnSelection:sender];

    }
    else{
        isRowSelected = NO;
        [selectedSectionDictionary removeAllObjects];
        
        if (selectedINdex != sender.tag+1) {
            selectedINdex = sender.tag+1;
            [self addRemoveSubcateforyOnSelection:sender];

        }
    }

    [_homeTableView reloadData];
}

-(void)addRemoveSubcateforyOnSelection:(UIButton*)sender{
    // if not having product in categories, check sub categories
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%@",@"ParentCategoryID",[[iofDB.mArrCategories objectAtIndex:sender.tag] valueForKey:@"CategoryID"]];
    filterSubCategoryArray = [[iofDB.mArrSubCategories filteredArrayUsingPredicate:predicate] mutableCopy];
    if (filterSubCategoryArray.count==0)
    {
        title =   [[iofDB.mArrCategories objectAtIndex:sender.tag]valueForKey:@"CategoryName"];
        
        [FIRAnalytics logEventWithName:kFIREventSelectContent
                            parameters:@{
                                         // kFIRParameterItemID:[NSString stringWithFormat:@"Categoryid-%@", [[iofDB.mArrCategories objectAtIndex:sender.tag]valueForKey:@"CategoryID"]],
                                         kFIRParameterItemName:[NSString stringWithFormat:@"%@", title],
                                         kFIRParameterContentType:[NSString stringWithFormat:@"CategoryName-%@", title]
                                         }];
        
        if([[[iofDB.mArrCategories objectAtIndex:sender.tag]valueForKey:@"CategoryID"] integerValue]==7)
        {
            if([[[NSUserDefaults standardUserDefaults] valueForKey:KAge] integerValue]>=18)
            {
                
                [self performSegueWithIdentifier:kproductDetailSegueIdentifier sender:[iofDB.mArrCategories objectAtIndex:sender.tag]];
            }
            else
            {
                [self performSegueWithIdentifier:kVerify sender:[iofDB.mArrCategories objectAtIndex:sender.tag]];
            }
        }
        else
        {
            [self performSegueWithIdentifier:kproductDetailSegueIdentifier sender:[iofDB.mArrCategories objectAtIndex:sender.tag]];
        }
        
    }
    else{
        
        title =   [[iofDB.mArrCategories objectAtIndex:sender.tag]valueForKey:@"CategoryName"];
        [FIRAnalytics logEventWithName:kFIREventSelectContent
                            parameters:@{
                                         //kFIRParameterItemID:[NSString stringWithFormat:@"Categoryid-%@", [[iofDB.mArrCategories objectAtIndex:sender.tag]valueForKey:@"CategoryID"]],
                                         kFIRParameterItemName:[NSString stringWithFormat:@"%@", title],
                                         kFIRParameterContentType:[NSString stringWithFormat:@"CategoryName-%@", title]
                                         }];
        if([[[iofDB.mArrCategories objectAtIndex:sender.tag]valueForKey:@"CategoryID"] integerValue]==9)
        {
            if([[[NSUserDefaults standardUserDefaults] valueForKey:KAge] integerValue]>=18)
            {
                
                filterSubCategoryArray = [[iofDB.mArrSubCategories filteredArrayUsingPredicate:predicate] mutableCopy];
                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sort_order" ascending:YES];
                filterSubCategoryArray = (NSMutableArray *)[filterSubCategoryArray sortedArrayUsingDescriptors:@[sort]];
                
                selectedSectionDictionary = [NSMutableDictionary dictionaryWithDictionary:[iofDB.mArrCategories objectAtIndex:sender.tag]];
            }
            else
            {
                [self performSegueWithIdentifier:kVerify sender:[iofDB.mArrCategories objectAtIndex:sender.tag]];
            }
            
        }
        
        else{
            
            filterSubCategoryArray = [[iofDB.mArrSubCategories filteredArrayUsingPredicate:predicate] mutableCopy];
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sort_order" ascending:YES];
            filterSubCategoryArray = (NSMutableArray *)[filterSubCategoryArray sortedArrayUsingDescriptors:@[sort]];
            
            selectedSectionDictionary = [NSMutableDictionary dictionaryWithDictionary:[iofDB.mArrCategories objectAtIndex:sender.tag]];
        }
    }

}

- (IBAction)segment_clicked:(id)sender {
    
    if (_segment.selectedSegmentIndex ==0) {
        headerViewHeight.constant = 150;
        basketImageView.hidden = YES;
        pageControl.hidden = YES;
        [_homeTableView setHidden:NO];
        [_offerTable setHidden:YES];
        messageLabel.hidden = true;
        [_homeTableView reloadData];
    }
    else{
        
        headerViewHeight.constant = 0;
        basketImageView.hidden = YES;
        pageControl.hidden = YES;
        
        [_homeTableView setHidden:YES];
        [_offerTable setHidden:NO];
        [_offerTable reloadData];
        messageLabel.hidden = true;
        NSMutableDictionary *OfferDictionary =(NSMutableDictionary*) [UtilityPlist getData:kOffer];
        
        if (OfferDictionary) {
            self.offerArr = [OfferDictionary valueForKey:@"Payload"];
            [_offerTable reloadData];
            [self getOfferList];
            
        }
        else{
            [Utility ShowMBHUDLoader];
            [self getOfferList];
            
        }
        
    }
}

-(void)getOfferList{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    offerServer *noti = [[offerServer alloc] initWithDict:dict];
    noti.requestDelegate=self;
    [noti startAsynchronous];
}

- (IBAction)searchButton_clicked:(id)sender {
    [self performSegueWithIdentifier:kproductDetailSegueIdentifier sender:kGlobalSearch];
}

- (IBAction)myCartButton_clicked:(id)sender {
    
    if (appDelegate.checkProductArray.count>0) {
        [self myCartView];
    }
    else{
        [Utility showAlertViewControllerIn:self title:@"" message:@"Your shoping cart is empty." block:^(int index){}];
    }
}


#pragma mark - Scroll view delegate and Methos

/***************************
 * Function Name : - load images on scroll view
 * Create on : - 18 may 2017
 * Developed By : - [Developer Ramniwas]
 * Description : - This fuction  are use for load multiple images on scroll view during swaping *
 * Organisation Name :- Sirez
 * version no :- 1.0
 * Modified Date :-
 * Modified Reason :-
 ****************************/

-(void)loadImages
{
    
    int scrollWidth=0;
    
    NSArray *subViews = _mainScrollView.subviews;
    
    for(UIView *view in subViews){
        [view removeFromSuperview];
    }
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:app.window animated:YES];
    });
    
    for ( i=0;i<self.bannerArr.count;i++)
    {
        UIImageView *imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(scrollWidth,0,kiPhoneWidth,_mainScrollView.frame.size.height)];
        imageView1.contentMode = UIViewContentModeScaleAspectFit;
        imageView1.layer.borderWidth =3;
        imageView1.layer.borderColor = [UIColor blackColor].CGColor;
         activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        imageView1.backgroundColor = [UIColor whiteColor];
        activityIndicator.center = imageView1.center;
        [activityIndicator startAnimating];
        [_mainScrollView addSubview:activityIndicator];
        
        
        NSString *url  = [[self.bannerArr objectAtIndex:i]valueForKey:@"iOSImage"];
        
        [imageView1 sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached];
        
        
        [_mainScrollView addSubview:imageView1];
        scrollWidth=scrollWidth+kiPhoneWidth;
        
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:app.window animated:YES];
        });
    }
    [_mainScrollView setContentSize:CGSizeMake(scrollWidth, _mainScrollView.frame.size.height)];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ((_mainScrollView.contentSize.width) > _mainScrollView.contentOffset.x + kiPhoneWidth) {
        
        CGFloat pageWidth = self.view.frame.size.width;
        
        _indexOfPage =    floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        pageControl.currentPage = _indexOfPage;
    }
}

-(void)hideLeftAndRightButtonsOnScrollView{
    
    if (_mainScrollView) {
        
        int offset=_mainScrollView.contentOffset.x/_mainScrollView.frame.size.width;
        
        if (offset==0&&(self.bannerArr.count>1)) {
            [self rightButton_Clicked:nil];
        }else if ((offset+1)==self.bannerArr.count){
            
            [self leftButton_Clicked:nil];
        }
    }
    
}


#pragma mark - Button _Clicked
-(void)leftButton_Clicked:(UIButton *)sende{
    
    if (_mainScrollView.contentOffset.x != 0) {
        
        [_mainScrollView setContentOffset:CGPointMake(-kiPhoneWidth+_mainScrollView.contentOffset.x, 0) animated:YES];
    }
}
-(void)rightButton_Clicked:(UIButton *)sende{
    
    if ((_mainScrollView.contentSize.width) > _mainScrollView.contentOffset.x + kiPhoneWidth) {
        [_mainScrollView setContentOffset:CGPointMake(kiPhoneWidth+_mainScrollView.contentOffset.x, 0) animated:YES];
    }
}


@end
