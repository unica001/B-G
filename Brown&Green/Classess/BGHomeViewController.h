//
//  BGHomeViewController.h
//  Brown&Green
//
//  Created by vineet patidar on 26/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IOFDB.h"
#import "TabelRecords.h"
#import "BannerServer.h"
#import "offerServer.h"
#import "BGProductViewController.h"
#import "BGDeliveryScheduleViewController.h"
#import "BGSubCategoryViewController.h"
#import "LCBannerView.h"


@interface BGHomeViewController : UIViewController<SWRevealViewControllerDelegate,TabelRecordsDelegate,BannerServerDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,offerServerDelegate,LCBannerViewDelegate>{

    __weak IBOutlet UIBarButtonItem *_revealMenu;
    IOFDB *iofDB;
    int _indexOfPage;

    
    __weak IBOutlet UIImageView *basketImageView;

    __weak IBOutlet UIPageControl *pageControl;
    __weak IBOutlet UITableView *_homeTableView;
    __weak IBOutlet NSLayoutConstraint *headerViewHeight;
    
    NSMutableArray *imageBannerArr;
    NSMutableArray *imageArr;
    NSMutableArray *titleArr;
    NSMutableArray *desArray;
    NSMutableArray *textBannerArr;
    NSMutableArray *imageArrayOfUrl;
    NSMutableArray *navigationArr;
    NSMutableArray *catIDArr;
    int i;
    int z;
    int a;
    NSString *desStr;
    
    NSMutableDictionary *selectedSectionDictionary;
    
    NSMutableArray *filterSubCategoryArray;
    
    NSString *title;
    
    BOOL isRowSelected;
    NSInteger selectedINdex;

    __weak IBOutlet UISegmentedControl *_segment;
    __weak IBOutlet UITableView *_offerTable;
    __weak IBOutlet UIBarButtonItem *_searchButton;
    __weak IBOutlet UIScrollView *_mainScrollView;
    
    __weak IBOutlet UILabel *messageLabel;
}
- (IBAction)segment_clicked:(id)sender;
- (IBAction)searchButton_clicked:(id)sender;
- (IBAction)myCartButton_clicked:(id)sender;

@property (nonatomic, weak) LCBannerView *bannerView2;
@property (nonatomic,retain) NSString  *dataBaseDate;
@property (nonatomic,retain) NSMutableArray *bannerArr;
@property(nonatomic,retain) NSMutableArray *categoryArr;
@property (nonatomic,retain) NSMutableArray *offerArr;
@end
