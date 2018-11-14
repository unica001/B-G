//
//  BGProductViewController.h
//  Brown&Green
//
//  Created by vineet patidar on 29/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCell.h"
#import "IOFDB.h"
#import "MyCartViewController.h"

@interface BGProductViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UISearchBarDelegate>{
    __weak IBOutlet UITableView *ProductTable;
//    __weak IBOutlet UIBarButtonItem *searchButton;
    __weak IBOutlet UIBarButtonItem *_bucketButton;
    __weak IBOutlet NSLayoutConstraint *_goToCartButtonHeight;
    
    NSString *countLabel;
    NSMutableArray *productArray;
    
    NSMutableArray *selectedCountArray;
    NSMutableArray *aToZArray;
    IOFDB *iofDB;
    UISearchBar *searchBar;
    float searchBarBoundsY;

}
@property(strong,nonatomic) NSMutableDictionary *dicCategory;
@property(strong,nonatomic) NSString *fromSearch;
@property(strong,nonatomic) NSString *title;
@property (nonatomic,retain) NSString *incommingViewType;


@property (nonatomic) BOOL  searchBarActive;

- (IBAction)backButton_clicked:(id)sender;
//- (IBAction)searchButton_clicked:(id)sender;
- (IBAction)bucketButton_clicked:(id)sender;
- (IBAction)goToCartButton_clicked:(id)sender;

@end
