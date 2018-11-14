//
//  BGSelectionViewController.h
//  Biqe
//
//  Created by vineet patidar on 18/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol userSelectionDelegate <NSObject>
-(void)selectData:(NSMutableDictionary *)dictioanry type:(NSString *)type;
@end

@interface BGSelectionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    
    NSMutableArray *_userArray;
    NSMutableArray *filterArray;
    NSMutableArray *selsctedArray;

    __weak IBOutlet UITableView *_userSelectionTable;
    UISearchBar *searchBar;
    float searchBarBoundsY;
}
@property (nonatomic,retain) id<userSelectionDelegate> delegate;
@property(nonatomic,retain) NSMutableArray *selectedUser;
@property(nonatomic,retain) NSMutableArray *selectedUserContact;
@property(nonatomic,retain) NSString *userType;
@property (nonatomic,retain) NSMutableDictionary*selectedMatterDictionary;
@property (nonatomic,retain) NSString *cityID;

- (IBAction)backButton_clicked:(id)sender;


@end
