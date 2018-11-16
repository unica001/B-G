//
//  VC5.m
//  Video
//
//  Created by Anand on 03/05/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import "VC5.h"
#import "VC5Cell.h"
#import "KarmaPointsVC.h"
#import "ConnectionManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "CommonFunctions.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface VC5 (){
    VC5Cell * cell;
    NSMutableArray *donarList_Arr;
}

@end

@implementation VC5

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = false;
    UINib *nib = [UINib nibWithNibName:@"VC5Cell" bundle:nil];
    [_collection registerNib:nib forCellWithReuseIdentifier:@"VC5Cell"];
    donarList_Arr = [[NSMutableArray alloc] init];
    [self DonarList_Service];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.title = @"Top Karma Points";
    
    _collection.hidden = true;
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        UIBarButtonItem *revealButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:revealViewController action:@selector(revealToggle:)];
        self.navigationItem.leftBarButtonItem = revealButton;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIStatusBarStyle
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#pragma mark - UItableView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;{
    return donarList_Arr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;{
    cell = (VC5Cell *)[_collection dequeueReusableCellWithReuseIdentifier:@"VC5Cell" forIndexPath:indexPath];
    
    
    cell.lbl_ProfileNAme.text = [[donarList_Arr objectAtIndex:indexPath.row] objectForKey:@"CustomerName"];
    cell.lbl_KarmaPoints.text = [NSString stringWithFormat:@"Karma Points - %@",[[donarList_Arr objectAtIndex:indexPath.row] objectForKey:@"TotalKarmaPoint"]];
    NSString * img_url = [NSString stringWithFormat:@"%@%@",ProfileImgURL,[[donarList_Arr objectAtIndex:indexPath.row] objectForKey:@"photo"]];
    
    NSURL *url = [NSURL URLWithString:img_url];
    [cell.profile_img setImageWithURL:url placeholderImage:[UIImage imageNamed:@"User-1.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.headerLabel.text = [NSString stringWithFormat:@"Here you have top karma user from last month (%@)",[[donarList_Arr objectAtIndex:indexPath.row] valueForKey:@"PreviousMonth"]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;{
    CGSize loc_size;
    loc_size = _collection.frame.size;
    loc_size.width = loc_size.width/ 2;
    loc_size.height = loc_size.width +10;
    
    return loc_size;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;{
    return 0;
}

#pragma mark - API
-(void)DonarList_Service{
    NSString *strRequestURL = @"SZDonationOrders.svc/GetTopDonnerList";
    
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",@"",nil];
    
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"application/json",@"Content-Type", nil];
    
    [MBProgressHUD showHUDAddedTo:ObjDelegate.window animated:YES];
    ConnectionManager *connectionManager = [ConnectionManager sharedInstance];
    [connectionManager startRequestWithHttpMethod:kHttpMethodTypeGet withHttpHeaders:headers withServiceName:strRequestURL withParameters:nil withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject %@",responseObject);
        NSLog(@"%ld",(long)[operation.response statusCode]);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            if ([operation.response statusCode]  == 203){
                [CommonFunctions showAlert:[operation.responseObject objectForKey:@"response"]];
                
                return;
            }
            NSDictionary *responseDict = (NSDictionary*) responseObject;
            
            if ([responseDict objectForKey:@"response"] != [NSNull null])
            {
                NSString * status = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"Status"]];
                NSString * code = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"Code"]];
                if([operation.response statusCode]  == 200){
                    if ([code isEqualToString:@"OK"] && [status isEqualToString:@"1"]) {
                        donarList_Arr = [responseDict objectForKey:@"Payload"];
                        NSLog(@"result : %@",donarList_Arr);
                        _collection.hidden = false;

                        [_collection reloadData];
                        
                    }else{
                        
                        _headerLabel.text = @"Sorry, no matching records found to be displayed";
//                        [CommonFunctions showAlert:@"Sorry, no matching records found to be displayed"];
                        
                    }
                    
                }
            }
        }
        [MBProgressHUD hideHUDForView:ObjDelegate.window animated:YES];
    }
                                      withFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"Error:%@",error.localizedDescription);
                                          NSLog(@"Error Code:%ld",(long)[operation.response statusCode]);
                                          
                                          if (![operation.responseObject objectForKey:@"response"]) {
                                              [CommonFunctions showAlert:@"Please try again"];
                                          }else{
                                              [CommonFunctions showAlert:[operation.responseObject objectForKey:@"response"]];
                                          }
                                          [MBProgressHUD hideHUDForView:ObjDelegate.window animated:YES];
                                         
                                          
                                      }
     ];
}
#pragma mark - UIButton Action
- (IBAction)btn_Back_Clicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btn_Next_Clicked:(UIButton *)sender {
    KarmaPointsVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"KarmaPointsVC"];
    [self.navigationController pushViewController:obj animated:YES];
}
@end
