//
//  TestingVC.m
//  Video
//
//  Created by Venkat on 30/04/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import "TestingVC.h"
#import "TestCell.h"
#import "ThankYouVC.h"
#import "VC5.h"
#import "DonateVC.h"

#import "ConnectionManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "CommonFunctions.h"
#import "Config.h"
//#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "IQKeyboardManager.h"


@interface TestingVC (){
    TestCell * cell;
    NSMutableArray *dummy,*donation_Arr,*NSMutableArray ,*final_DonationList_arr;
    NSInteger ktxtEditedRow,CategoryID,UnitId;
    __weak IBOutlet UIButton *_backButton;
    __weak IBOutlet UIWebView *webView;
    NSMutableArray *arrayKarmaPointCat;
}
@property(copy,nonatomic) NSMutableArray * temp_Arr_For_Selection;

@end



@implementation TestingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([self.incomingViewType isEqualToString:kfromKramPoint]) {
        [_backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    }
    else{
         [_backButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    }
    
    NSLog(@"%@", [kUserDefault valueForKey:kTutorial]);

if (![[Utility replaceNULL:[[kUserDefault valueForKey:kTutorial] valueForKey:kkramTutorial] value:@""] isEqualToString:@"NO"]) {         //  add tutorial
        SSTutorialViewController *tutorialView = [[SSTutorialViewController alloc]initWithNibName:@"SSTutorialViewController" bundle:[NSBundle mainBundle]];
        tutorialView.incomingViewType = kkramTutorial;
        [self presentViewController:tutorialView animated:YES completion:nil];
    }
    
    
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popViewTap:)];
    [self.popUp_View addGestureRecognizer:tapGuesture];
    
    cell = (TestCell *)[[[NSBundle mainBundle] loadNibNamed:@"TestCell" owner:self options:nil] lastObject];
  //  self.title = @"Donate";
    self.navigationItem.title = @"Kamra";
    self.navigationController.title = @"Kamra";
    [self setNeedsStatusBarAppearanceUpdate];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"karmaR@3x" withExtension:@"gif"];
    _karmaRotetingImage.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
    _karmaRotetingImage.image = [UIImage animatedImageWithAnimatedGIFURL:url];

    
      [webView loadHTMLString:@"<font face = 'arial'><span style='font-size:14px;text-align: center; color:#3B455D'><p> <a href='' style='color:#8FC215;'>Food Legislation</a></p></span></font>" baseURL:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
    donation_Arr = [[NSMutableArray alloc] init];
    if (!(_temp_Arr_For_Selection.count>0)) {
        _temp_Arr_For_Selection = [[NSMutableArray alloc] init];
    }
    
    if (!dummy) {
        dummy = [[NSMutableArray alloc] init];

    }
    UnitId = CategoryID = ktxtEditedRow = -1;
    ktxtEditedRow = -1;
    _txt_KarmaPoints.text = @"";
    [_popUp_View setHidden:YES];
    
    NSString *incomingView = [Utility replaceNULL:[kUserDefault valueForKey:kGuestUserInComingScreen] value:@""];
   
    if ([incomingView isEqualToString:@"donate"]) {
        DonateVC * obj = [self.storyboard instantiateViewControllerWithIdentifier:@"DonateVC"];
        [self.navigationController pushViewController:obj animated:YES];
            return;
    }
    [self get_DonationList_Service];
}


#pragma  mark - webviw delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        
        isFoodLegislation = YES;
        [self performSegueWithIdentifier:kwebviewSegueIdentifier sender:kFoodLegislation];

        return NO;
    }
    return YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = false;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIStatusBarStyle
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#pragma mark - UITableView Delegae
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[dummy objectAtIndex:indexPath.row] intValue] == 0){
        return 90;
 
    }else{
        return 135;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   // return donation_Arr.count;
    return donation_Arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cell  = (TestCell *)[_tbl_Testing dequeueReusableCellWithIdentifier:@"TestCell"];
    
    if (cell == nil) {
       cell = (TestCell *)[[[NSBundle mainBundle] loadNibNamed:@"TestCell" owner:self options:nil] lastObject];
    }
    NSDictionary *kg_Dict;
    cell.txt_FoodWeight.tag = cell.btn_Food_Name.tag = indexPath.row;
    cell.btn_KG.tag = cell.btn_GM.tag = indexPath.row;
    cell.btn_KG_Main.tag = cell.btn_GM_Main.tag = cell.btn_MG_Main.tag = indexPath.row;
    
    [cell.btn_KG addTarget:self action:@selector(btn_KG_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn_GM addTarget:self action:@selector(btn_GM_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn_MG_Main addTarget:self action:@selector(btn_MG_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn_Food_Name addTarget:self action:@selector(FoodName_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.btn_KG_Main addTarget:self action:@selector(btn_KG_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn_GM_Main addTarget:self action:@selector(btn_GM_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn_MG_Main addTarget:self action:@selector(btn_MG_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.txt_FoodWeight addTarget:self action:@selector(txt_FoodWeight_Details_Clicked:) forControlEvents:UIControlEventEditingDidEndOnExit];

    [cell.txt_FoodWeight addTarget:self action:@selector(txt_FoodWeight_Edit_End_Clicked:) forControlEvents:UIControlEventEditingDidEnd];
    
    if ([[dummy objectAtIndex:indexPath.row] intValue] == 0) {
        [cell.view_FoodDetails setHidden:YES];
        cell.btn_Food_Name.selected = false;
    }else{
        [cell.view_FoodDetails setHidden:NO];
        cell.btn_Food_Name.selected = true;
    }


    NSString * isActive,*isDeleted;
    NSInteger unitsList_Count;
    isActive = [[donation_Arr  objectAtIndex:indexPath.row] objectForKey:@"IsActive"];
    isDeleted = [[donation_Arr  objectAtIndex:indexPath.row] objectForKey:@"IsDeleted"];
    
    if ([isActive isEqualToString:@"Y"] && [isDeleted isEqualToString:@"N"]) {
    
        CategoryID = [[[donation_Arr  objectAtIndex:indexPath.row] objectForKey:@"RefDonCategoryID"] intValue];
        if (CategoryID == 3) {
            cell.contentView.backgroundColor = [UIColor colorWithRed:248/255.0 green:253/255.0 blue:236/    255.0 alpha:1.0];
        }else if (CategoryID == 2){
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }else if (CategoryID == 1){
            cell.contentView.backgroundColor = [UIColor colorWithRed:234/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
        }
    
    unitsList_Count = [[[donation_Arr  objectAtIndex:indexPath.row] objectForKey:@"DonationPUnitsList"] count];
    NSArray * count_arr = [[donation_Arr  objectAtIndex:indexPath.row] objectForKey:@"DonationPUnitsList"];

        if (unitsList_Count == 3) {
            cell.Constraint_TotalWeight_Width.constant = 60;
            cell.constriant_KG3_width.constant = 25;
            cell.constarint_KG3_View_Width.constant = 60;
            [cell.KG2_View setHidden:NO];
            for (int j = 0; j < count_arr.count ; j++) {
                if (j == 0) {
                cell.lbl_KG1.text = [[[[donation_Arr  objectAtIndex:indexPath.row] objectForKey:@"DonationPUnitsList"] objectAtIndex:j] objectForKey:@"UnitName"];
                }else if (j == 1){
                cell.lbl_KG2.text = [[[[donation_Arr  objectAtIndex:indexPath.row] objectForKey:@"DonationPUnitsList"] objectAtIndex:j] objectForKey:@"UnitName"];
                }else{
                cell.lbl_KG3.text = [[[[donation_Arr  objectAtIndex:indexPath.row] objectForKey:@"DonationPUnitsList"] objectAtIndex:j] objectForKey:@"UnitName"];
                }
            }
        }else if (unitsList_Count == 2){
          //  cell.Constraint_TotalWeight_Width.constant = 60;
             [cell.KG2_View setHidden:NO];
             cell.constriant_KG3_width.constant = 0;
             cell.constarint_KG3_View_Width.constant = 0;
            for (int j = 0; j < count_arr.count ; j++) {
                if (j == 0) {
                    cell.lbl_KG1.text = [[[[donation_Arr  objectAtIndex:indexPath.row] objectForKey:@"DonationPUnitsList"] objectAtIndex:j] objectForKey:@"UnitName"];
                }else if (j == 1){
                    cell.lbl_KG2.text = [[[[donation_Arr  objectAtIndex:indexPath.row] objectForKey:@"DonationPUnitsList"] objectAtIndex:j] objectForKey:@"UnitName"];
                }
            }
        }else if (unitsList_Count == 1){
            [cell.KG2_View setHidden:YES];
            cell.constriant_KG3_width.constant = 0;
            cell.constarint_KG3_View_Width.constant = 0;
            for (int j = 0; j < count_arr.count ; j++) {
                cell.lbl_KG1.text = [[[[donation_Arr  objectAtIndex:indexPath.row] objectForKey:@"DonationPUnitsList"] objectAtIndex:j] objectForKey:@"UnitName"];
            }
        }
        kg_Dict = [_temp_Arr_For_Selection objectAtIndex:indexPath.row];
  
        switch (unitsList_Count) {
            case 3:
                if (([[kg_Dict objectForKey:@"is_KG"] isEqualToString:@"NO"] && [[kg_Dict objectForKey:@"is_GM"] isEqualToString:@"NO"] && [[kg_Dict objectForKey:@"is_MG"] isEqualToString:@"NO"])){
                    cell.btn_KG.selected = cell.btn_GM.selected = cell.btn_MG_Main.tag = false;
                }else{
                    if ([[kg_Dict objectForKey:@"is_KG"] isEqualToString:@"YES"]) {
                        cell.btn_KG.selected = true;
                        cell.btn_GM.selected =false;
                        cell.btn_MG.selected = false;
                    }else if ([[kg_Dict objectForKey:@"is_GM"] isEqualToString:@"YES"]){
                        cell.btn_KG.selected = false;
                        cell.btn_MG.selected = false;
                        cell.btn_GM.selected = true;
                        
                    }else if ([[kg_Dict objectForKey:@"is_MG"] isEqualToString:@"YES"]){
                        cell.btn_KG.selected = false;
                        cell.btn_MG.selected = true;
                        cell.btn_GM.selected = false;
                    }
                }
                break;
            case 2:
                if ([[kg_Dict objectForKey:@"is_KG"] isEqualToString:@"NO"] && [[kg_Dict objectForKey:@"is_GM"] isEqualToString:@"NO"]) {
                    cell.btn_KG.selected = cell.btn_GM.selected = false;
                }else{
                    if ([[kg_Dict objectForKey:@"is_KG"] isEqualToString:@"YES"]) {
                        cell.btn_KG.selected = true;
                        cell.btn_GM.selected =false;
                    }else if ([[kg_Dict objectForKey:@"is_GM"] isEqualToString:@"YES"]){
                        cell.btn_KG.selected = false;
                        cell.btn_GM.selected = true;
                    }
                }
                break;
            case 1:
                if ([[kg_Dict objectForKey:@"is_KG"] isEqualToString:@"NO"]) {
                    cell.btn_KG.selected = false;
                }else{
                    cell.btn_KG.selected = true;
                }

                break;
            default:
                break;
        }
        
       
    cell.lbl_Product_Name.text = [[donation_Arr  objectAtIndex:indexPath.row] objectForKey:@"ProductName"];
    cell.txt_FoodWeight.text = [kg_Dict objectForKey:@"quantity"];
    NSString *produc_Img = [NSString stringWithFormat:@"%@/%@",imageAPIURL,[[donation_Arr  objectAtIndex:indexPath.row] objectForKey:@"ImgName"]];
    NSURL *url = [NSURL URLWithString:produc_Img];
//    NSString * thumd_img = [NSString stringWithFormat:@"%%@",ThumbAPIURL];
    [cell.product_Img setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Logo(PopUp)"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray ];

    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//   TestCell *cell1  = (TestCell *)[tableView cellForRowAtIndexPath:indexPath];
    
//    if ([[dummy objectAtIndex:indexPath.row] intValue] == 0) {
//        cell.constriant_subView_Height.constant = 0;
//        [dummy replaceObjectAtIndex:indexPath.row withObject:@"1"];
//    }else{
//        [dummy replaceObjectAtIndex:indexPath.row withObject:@"0"];
//        cell.constriant_subView_Height.constant = 50;
//    }
//    
//    [tableView reloadData];
}


-(void)txt_FoodWeight_Edit_End_Clicked:(UITextField *)sender{
    CGPoint center = sender.center;
    CGPoint rootPoint  = [sender convertPoint:center toView:_tbl_Testing];
    NSIndexPath * index = [_tbl_Testing indexPathForRowAtPoint:rootPoint];
    NSLog(@"indexpath :%lu",index.row);
    ktxtEditedRow = index.row;
    cell =  (id)[_tbl_Testing cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index.row inSection:0]];
    UITextField * txt =  [cell txt_FoodWeight];
    
    if ([[txt text] intValue] == 0) {
        [CommonFunctions showAlert:@"Total weight should be greater than 0"];
    }
    
   if(txt)
   {
       NSMutableDictionary *dict = [_temp_Arr_For_Selection objectAtIndex:index.row];
       if ([[txt text] isEqualToString:@"0"]) {
           [dict setObject:@"" forKey:@"quantity"];
       }else{
           [dict setObject:txt.text forKey:@"quantity"];
       }
       [_temp_Arr_For_Selection replaceObjectAtIndex:index.row withObject:dict];
       
       [_tbl_Testing reloadData];
   }
    
    
}

-(void)txt_FoodWeight_Details_Clicked:(UITextField *)sender{
    CGPoint center = sender.center;
    CGPoint rootPoint  = [sender convertPoint:center toView:_tbl_Testing];
    NSIndexPath * index = [_tbl_Testing indexPathForRowAtPoint:rootPoint];
    NSLog(@"indexpath :%lu",index.row);
    ktxtEditedRow = index.row;
    
   cell =  (id)[_tbl_Testing cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index.row inSection:0]];
    UITextField * txt =  [cell txt_FoodWeight];
    NSMutableDictionary *dict = [_temp_Arr_For_Selection objectAtIndex:index.row];
    [dict setObject:txt.text forKey:@"quantity"];
    [_temp_Arr_For_Selection replaceObjectAtIndex:index.row withObject:dict];

    [_tbl_Testing reloadData];
    NSLog(@"text :%@",txt.text);
}
#pragma mark - UIButtion Action Methods
-(void)btn_MG_Clicked:(UIButton *)sender{
    CGPoint center = sender.center;
    CGPoint rootPoint  = [sender convertPoint:center toView:_tbl_Testing];
    NSIndexPath * index = [_tbl_Testing indexPathForRowAtPoint:rootPoint];
    NSLog(@"indexpath :%lu",index.row);
    
    NSMutableDictionary *dict = [_temp_Arr_For_Selection objectAtIndex:index.row];
    NSLog(@"before :%@",_temp_Arr_For_Selection);
    [dict setObject:@"YES" forKey:@"is_MG"];
    [dict setObject:@"NO" forKey:@"is_GM"];
    [dict setObject:@"NO" forKey:@"is_KG"];
    [dict setObject:@"YES" forKey:@"isSel_UnitId"];
    [dict setObject:@"2" forKey:@"UnitID"];
    [_temp_Arr_For_Selection replaceObjectAtIndex:index.row withObject:dict];
    
    NSLog(@"before :%@",_temp_Arr_For_Selection);
    [_tbl_Testing reloadData];
}
-(void)btn_KG_Clicked:(UIButton *)sender{
    CGPoint center = sender.center;
    CGPoint rootPoint  = [sender convertPoint:center toView:_tbl_Testing];
    NSIndexPath * index = [_tbl_Testing indexPathForRowAtPoint:rootPoint];
    NSLog(@"indexpath :%lu",index.row);
    
    cell =  (id)[_tbl_Testing cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index.row inSection:0]];
    UITextField * txt =  [cell txt_FoodWeight];
    
    if ([[txt text] intValue] == 0) {

        [Utility showAlertViewControllerIn:self title:@"" message:@"Total weight should be greater than 0" block:^(int index){
        
        }];
        return;
    }
    
    NSMutableDictionary *dict = [_temp_Arr_For_Selection objectAtIndex:index.row];
    
       NSString *unit = [NSString stringWithFormat:@"%@",[[[[donation_Arr objectAtIndex:index.row] valueForKey:@"DonationPUnitsList"] objectAtIndex:1] valueForKey:@"UnitId"]];
    
    NSLog(@"before :%@",_temp_Arr_For_Selection);
    [dict setObject:@"NO" forKey:@"is_MG"];
    [dict setObject:@"NO" forKey:@"is_GM"];
    
    NSInteger Units_Count = [[[donation_Arr  objectAtIndex:index.row] objectForKey:@"DonationPUnitsList"] count];
    if (Units_Count == 1) {
        if ([[dict objectForKey:@"is_KG"] isEqualToString:@"NO"]) {
            [dict setObject:@"YES" forKey:@"is_KG"];
            [dict setObject:@"YES" forKey:@"isSel_UnitId"];
            [dict setObject:@"0" forKey:@"UnitID"];
        }else{
            [dict setObject:@"NO" forKey:@"is_KG"];
            [dict setObject:@"NO" forKey:@"isSel_UnitId"];
            [dict setObject:@"" forKey:@"UnitID"];
        }
    }else{
        [dict setObject:@"YES" forKey:@"is_KG"];
        [dict setObject:@"YES" forKey:@"isSel_UnitId"];
        [dict setObject:unit forKey:@"UnitID"];
        
    }
    
    // calculation for karmapoint
    
    NSDictionary * lo_Dict = [donation_Arr objectAtIndex:index.row];
    NSString *RefDonCategoryID = [NSString stringWithFormat:@"%@",[lo_Dict objectForKey:@"RefDonCategoryID"]];
    
    NSString *point;
    for (NSMutableDictionary*donCategoryDictionary in arrayKarmaPointCat) {
        if ([[donCategoryDictionary valueForKey:@"DonCategoryID"] integerValue]==[RefDonCategoryID integerValue]) {
            point = [donCategoryDictionary  valueForKey:@"KarmaPoint"];
        }
    }
    
    NSString*baseUnitValue;
    if (Units_Count ==2) {
        NSMutableArray *donationPUnitsList = [NSMutableArray arrayWithArray:[lo_Dict  valueForKey:@"DonationPUnitsList"]];
        baseUnitValue = [[donationPUnitsList objectAtIndex:1]valueForKey:@"BaseUnitValue"];
    }
    
    float weight = [txt.text floatValue]*[point floatValue]*[baseUnitValue floatValue];
    
    [dict setObject:[NSString stringWithFormat:@"%0.2f",weight] forKey:@"karma"];
    
    [_temp_Arr_For_Selection replaceObjectAtIndex:index.row withObject:dict];
    [_tbl_Testing reloadData];
    
    [self karmaPointCalaculation];

}
-(void)btn_GM_Clicked:(UIButton *)sender{
    CGPoint center = sender.center;
    CGPoint rootPoint  = [sender convertPoint:center toView:_tbl_Testing];
    NSIndexPath * index = [_tbl_Testing indexPathForRowAtPoint:rootPoint];
    
    cell =  (id)[_tbl_Testing cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index.row inSection:0]];
    UITextField * txt =  [cell txt_FoodWeight];
    
    if ([[txt text] intValue] == 0) {
        
        [Utility showAlertViewControllerIn:self title:@"" message:@"Total weight should be greater than 0" block:^(int index){
            
        }];
        return;
    }

    NSString *unit = [NSString stringWithFormat:@"%@",[[[[donation_Arr objectAtIndex:index.row] valueForKey:@"DonationPUnitsList"] objectAtIndex:0] valueForKey:@"UnitId"]];
    
    NSMutableDictionary *dict = [[_temp_Arr_For_Selection objectAtIndex:index.row] mutableCopy];
    NSLog(@"before :%@",_temp_Arr_For_Selection);
    [dict setObject:@"YES" forKey:@"is_GM"];
    [dict setObject:@"NO" forKey:@"is_KG"];
    [dict setObject:@"NO" forKey:@"is_MG"];
    [dict setObject:@"YES" forKey:@"isSel_UnitId"];
    [dict setObject:unit forKey:@"UnitID"];
    
    // calculation for karmapoint
    
    NSDictionary * lo_Dict = [donation_Arr objectAtIndex:index.row];
    NSString *RefDonCategoryID = [NSString stringWithFormat:@"%@",[lo_Dict objectForKey:@"RefDonCategoryID"]];
    
    NSString *point;
    for (NSMutableDictionary*donCategoryDictionary in arrayKarmaPointCat) {
        if ([[donCategoryDictionary valueForKey:@"DonCategoryID"] integerValue]==[RefDonCategoryID integerValue]) {
            point = [donCategoryDictionary  valueForKey:@"KarmaPoint"];
        }
    }
    
    NSString*baseUnitValue;
        NSMutableArray *donationPUnitsList = [NSMutableArray arrayWithArray:[lo_Dict  valueForKey:@"DonationPUnitsList"]];
        baseUnitValue = [[donationPUnitsList objectAtIndex:0]valueForKey:@"BaseUnitValue"];
    
    float weight = [txt.text floatValue]*[point floatValue]*[baseUnitValue floatValue];
    
    [dict setObject:[NSString stringWithFormat:@"%0.2f",weight] forKey:@"karma"];
    
    [_temp_Arr_For_Selection replaceObjectAtIndex:index.row withObject:dict];
    [_tbl_Testing reloadData];
    
    [self karmaPointCalaculation];
}

-(void)karmaPointCalaculation{
   
      float  total_KarmaPoints = 0;
            for(int j = 0; j < _temp_Arr_For_Selection.count; j++){
               NSDictionary *dict  = _temp_Arr_For_Selection [j];
                if ([[dict objectForKey:@"karma"] length] > 0) {
                    total_KarmaPoints += [[dict objectForKey:@"karma"] floatValue];
                }
            }
        _txt_KarmaPoints.text = [NSString stringWithFormat:@"%.2f",total_KarmaPoints];
        [_tbl_Testing reloadData];
}
-(void)FoodName_Clicked:(UIButton *)sender{
    CGPoint center = sender.center;
    CGPoint rootPoint  = [sender convertPoint:center toView:_tbl_Testing];
    NSIndexPath  *index = [_tbl_Testing indexPathForRowAtPoint:rootPoint];
    NSLog(@"%ld",(long)index.row);
    
    NSMutableDictionary *dict = [_temp_Arr_For_Selection objectAtIndex:index.row];
    
    
    
    if ([[dummy objectAtIndex:index.row] intValue] == 0) {
        [dummy replaceObjectAtIndex:index.row withObject:@"1"];
    }else{
        
        
        NSString *kramPoint = [[_temp_Arr_For_Selection objectAtIndex:index.row] valueForKey:@"karma"];
        
        _txt_KarmaPoints.text = [NSString stringWithFormat:@"%ld",[_txt_KarmaPoints.text integerValue] - [kramPoint integerValue]];
        
        [[_temp_Arr_For_Selection objectAtIndex:index.row] setValue:@"" forKey:@"karma"];
        [[_temp_Arr_For_Selection objectAtIndex:index.row] setValue:@"" forKey:@"UnitID"];
        
        [[_temp_Arr_For_Selection objectAtIndex:index.row] setValue:@"" forKey:@"quantity"];
        [[_temp_Arr_For_Selection objectAtIndex:index.row] setValue:@"NO" forKey:@"is_KG"];
        [[_temp_Arr_For_Selection objectAtIndex:index.row] setValue:@"NO" forKey:@"is_GM"];
        [[_temp_Arr_For_Selection objectAtIndex:index.row] setValue:@"NO" forKey:@"isSel_UnitId"];
        [dummy replaceObjectAtIndex:index.row withObject:@"0"];
 
    }
    
   
    [_tbl_Testing reloadData];
    
}
- (IBAction)btn_Next_Clicked:(UIButton *)sender {
    [self.view endEditing:YES];
    final_DonationList_arr = [[NSMutableArray alloc] init];
    int selected_UnitId;

    for (int j = 0; j < _temp_Arr_For_Selection.count; j++) {
        NSMutableDictionary *setting_params = [[NSMutableDictionary alloc] init];
        NSDictionary *donation_dict = [donation_Arr objectAtIndex:j];
        NSDictionary *temp_dict = [_temp_Arr_For_Selection objectAtIndex:j];
        

        if ([[temp_dict objectForKey:@"quantity"] length] == 0  && [[temp_dict objectForKey:@"UnitID"] length] != 0) {
            [CommonFunctions showAlert:[NSString stringWithFormat:@"Please enter Weight Value for Product(s)"]];
            return;
        }
        else if([[temp_dict objectForKey:@"UnitID"] length] == 0 && [[temp_dict objectForKey:@"quantity"] length] > 0){
            [CommonFunctions showAlert:[NSString stringWithFormat:@"Please select Unit Value for Product(s)"]];
            return;
        }
        else if([[temp_dict objectForKey:@"is_GM"] isEqualToString:@"YES"]  && [[temp_dict objectForKey:@"quantity"] floatValue] <100){
            [CommonFunctions showAlert:[NSString stringWithFormat:@"%@ weight must be greater than 100gm",[donation_dict valueForKey:@"ProductName"]]];
            return;
        }
        else{
        
        [setting_params setObject:[donation_dict objectForKey:@"DonProductID"] forKey:@"ProductId"];
        [setting_params setObject:[temp_dict objectForKey:@"quantity"] forKey:@"QuantityId"];
        
        if ([[temp_dict objectForKey:@"isSel_UnitId"] isEqualToString:@"YES"]) {
            int unitId = [[temp_dict objectForKey:@"UnitID"] intValue];

            [setting_params setObject:[NSString stringWithFormat:@"%d",unitId] forKey:@"UinitId"];
            [setting_params setObject:[donation_dict objectForKey:@"DonProductID"] forKey:@"ProductId"];
            [setting_params setObject:[temp_dict objectForKey:@"quantity"] forKey:@"QuantityId"];
            [final_DonationList_arr addObject:setting_params];
            }
        }
    }

    if (final_DonationList_arr.count > 0) {
        [ConfigDelegate setStringForArray:final_DonationList_arr forKey:FINAL_DONATIONLIST];
        [self.popUp_View setHidden:NO];
    }
    else{
        [Utility showAlertViewControllerIn:self title:@"" message:@"Please select categories" block:^(int index){}];
    }
    
}

- (IBAction)btn_OK_CLicked:(UIButton *)sender {
    
    isFoodLegislation = NO;
    DonateVC * obj = [self.storyboard instantiateViewControllerWithIdentifier:@"DonateVC"];
    [self.navigationController pushViewController:obj animated:YES];
 
}

- (IBAction)btn_Back_Clicked:(UIButton *)sender {

     self.navigationController.navigationBarHidden = false;
    [self.view endEditing:true];

    if ([self.incomingViewType isEqualToString:kfromKramPoint]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        SWRevealViewController *revealViewController = self.revealViewController;
        [revealViewController revealToggleAnimated:YES];
        revealViewController.delegate  = self;
    }
}

- (IBAction)infoButton_clicked:(id)sender {
    [Utility showAlertViewControllerIn:self title:@"Colour & Calculation of Karma Points" message:@"Grey means you offering food item from most expensive category!Check out your karma points by putting in total weight of the category *1\n\nWhite means you offering food item from less expensive category!Check out your karma points by putting in total weight of the category/2\n\nYellow means you offering food item from least expensive category!Check out your karma points by putting in total weight of the category/3" block:^(int index){
    
    }];
}

#pragma mark - API
-(void)get_DonationList_Service{
    NSString *strRequestURL = @"SZDonationOrders.svc/GetDonationsTableRecords";
    
    //    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",@"",nil];
    
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"application/json",@"Content-Type", nil];
    
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    
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
                        NSMutableArray * json_Arr = [[NSMutableArray alloc] init];
                        json_Arr = [[responseDict objectForKey:@"Payload"] objectForKey:@"DonationProductsList"];
                        NSPredicate *PRD3  = [NSPredicate predicateWithFormat:@"RefDonCategoryID == 3"];
                        NSArray *prd3_arr = [json_Arr filteredArrayUsingPredicate:PRD3];
                        NSLog(@"arrary : %@", prd3_arr);
                        NSPredicate *PRD2  = [NSPredicate predicateWithFormat:@"RefDonCategoryID == 2"];
                        NSArray *prd2_arr = [json_Arr filteredArrayUsingPredicate:PRD2];
                        NSPredicate *PRD1  = [NSPredicate predicateWithFormat:@"RefDonCategoryID == 1"];
                        NSArray *prd1_arr = [json_Arr filteredArrayUsingPredicate:PRD1];
                        
                        arrayKarmaPointCat = [NSMutableArray arrayWithArray:[[responseDict objectForKey:@"Payload"] objectForKey:@"DonationCategoryList"]];
                        
                        [donation_Arr removeAllObjects];
                        [donation_Arr addObjectsFromArray:prd3_arr];
                        [donation_Arr addObjectsFromArray:prd2_arr];
                        [donation_Arr addObjectsFromArray:prd1_arr];
                        NSMutableArray * locArr = [[NSMutableArray alloc] init];
                        
                        if (dummy.count==0) {
                            for (int i = 0; i < donation_Arr.count; i++) {
                                NSMutableDictionary * loc_dict = [[NSMutableDictionary alloc] init];
                                [loc_dict setObject:@"NO" forKey:@"is_KG"];
                                [loc_dict setObject:@"NO" forKey:@"is_GM"];
                                [loc_dict setObject:@"NO" forKey:@"is_MG"];
                                [loc_dict setObject:@"" forKey:@"quantity"];
                                [loc_dict setObject:@"" forKey:@"karma"];
                                [loc_dict setObject:@"" forKey:@"UnitID"];
                                [loc_dict setObject:@"NO" forKey:@"isSel_UnitId"];
                                [locArr addObject:loc_dict];
                                [dummy addObject:@"0"];
                            }

                        }

                        if (_temp_Arr_For_Selection.count==0) {
                          _temp_Arr_For_Selection = [NSMutableArray arrayWithArray:locArr];
                        }
                        else{
                            [self.popUp_View setHidden:NO];
                            [self karmaPointCalaculation];
                        }
                        
                        if (isFoodLegislation == false) {
                            [self.popUp_View setHidden:YES];

                        }
                       
                        
                        [_tbl_Testing reloadData];
                    }else{
                        [CommonFunctions showAlert:[responseObject valueForKey:@"Message"]];
                        
                    }
                    
                }
            }
        }
        [MBProgressHUD hideHUDForView:ObjDelegate.window animated:YES];
        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
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
                                          [self.navigationController.navigationBar setUserInteractionEnabled:YES];
                                          
                                      }
     ];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kwebviewSegueIdentifier]) {
        BGWebViewController *_wevView = segue.destinationViewController;
            _wevView.webviewMode = BGFoodLegislation;
    }
    
}
-(void)popViewTap:(UITapGestureRecognizer*)guesture{
    [self.popUp_View setHidden:YES];

}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   // [self.popUp_View setHidden:NO];
}
@end
