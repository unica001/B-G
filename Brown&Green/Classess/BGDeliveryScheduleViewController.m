//
//  BGDeliveryScheduleViewController.m
//  Brown&Green
//
//  Created by vineet patidar on 30/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "BGDeliveryScheduleViewController.h"
#import "userSelectionCell.h"
@interface BGDeliveryScheduleViewController (){

    NSMutableArray *weekCountArray;
    NSMutableArray *deliveryTimeSlotsArray;
    NSString *selectedDeliveryDate;
    NSString *timeSlotSelected;
    NSString *slotType;

    NSString *dateText;
    BOOL orderExists;
    UILabel *badgeLabel;
    NSMutableDictionary *loginInfo;
    AppDelegate *appDelegate;


}

@end

@implementation BGDeliveryScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    loginInfo  = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSLog(@"%@", [kUserDefault valueForKey:kTutorial]);

  if (![[Utility replaceNULL:[[kUserDefault valueForKey:kTutorial] valueForKey:kscheduleTutorial] value:@""] isEqualToString:@"NO"]) {        //  add tutorial
        SSTutorialViewController *tutorialView = [[SSTutorialViewController alloc]initWithNibName:@"SSTutorialViewController" bundle:[NSBundle mainBundle]];
        tutorialView.incomingViewType = kscheduleTutorial;
        [self presentViewController:tutorialView animated:YES completion:nil];
    }
    
    weekCountArray = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
    selectedSlotDictionary = [[NSMutableDictionary alloc]init];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.productListArr  = [[NSMutableArray alloc]init];
    iofDB = [IOFDB sharedManager];

    selectedDate = 0;
    // bucket product count label
    badgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kiPhoneWidth-20, 1, 20, 20)];
    badgeLabel.layer.cornerRadius = 10;
    badgeLabel.textColor = [UIColor whiteColor];
    [badgeLabel.layer setMasksToBounds:YES];
    badgeLabel.backgroundColor = kDefaultLightGreen;
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.font = [UIFont systemFontOfSize:12];
    [self.navigationController.navigationBar addSubview:badgeLabel];
    [self getMyCartData];
    
    timeSlotSelected = @"0";
    
//    SWRevealViewController *revealViewController = self.revealViewController;
//    if ( revealViewController )
//    {  SWRevealViewController *revealViewController = self.revealViewController;
//        if ( revealViewController )
//        {
//            [_backButton setImage:[UIImage imageNamed:@"backButton"]];
//            [_backButton setTarget: self.revealViewController];
//            [_backButton setAction: @selector( revealToggle: )];
//        }
//    }
//    self.revealViewController.delegate = self;

}

-(void)getMyCartData{
    
    NSMutableArray *arrTemp;
    
    arrTemp = appDelegate.checkProductArray;
    NSMutableArray *categoriesArray = [arrTemp valueForKeyPath:@"RefCategoryID"];
    
    NSSet *set = [NSSet setWithArray:categoriesArray];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K IN %@",@"CategoryID",set];
    NSArray *catArr = [iofDB.mArrCategories filteredArrayUsingPredicate:predicate];
    NSMutableArray *myCartArray =[catArr mutableCopy];
    
    NSMutableArray *subCatArr= (NSMutableArray *)[iofDB.mArrSubCategories filteredArrayUsingPredicate:predicate];
    if (subCatArr.count!=0)
    {
        for (NSDictionary* obj in subCatArr)
        {
            [myCartArray addObject:obj];
        }
    }
    
    for (NSMutableDictionary *dic in myCartArray)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",@"RefCategoryID",[dic valueForKey:@"CategoryID"]];
        NSMutableArray *arr = (NSMutableArray *)[arrTemp filteredArrayUsingPredicate:predicate];
        for (int i=0; i<arr.count; i++)
        {
            NSDictionary *dic=[arr objectAtIndex:i];
            NSString *productId=[dic objectForKey:@"ProductID"];
            if (productId==nil)
            {
                productId=[dic objectForKey:@"ProductId"];
            }
            NSDictionary *localProductDic=[iofDB getProductById:productId];
            NSString *price = [localProductDic objectForKey: @"SalePrice"];
            [dic setValue:price forKey:@"SalePrice"];
            
        }
        [dic setObject:arr forKey:@"rows"];
    }
 
    if ([appDelegate.checkProductArray count]>0) {
        badgeLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[appDelegate.checkProductArray count]];
    }
    else{
        
     badgeLabel.text = @"";
    }

    
}

-(void)viewWillDisappear:(BOOL)animated{
    badgeLabel.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    badgeLabel.hidden = NO;
    
    lineView.hidden = YES;
    _deliveyTable.hidden = YES;

    [self getDeliverySlot];

}

#pragma mark - table view

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [timeSlotArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier  =@"cell";
    
    userSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"userSelectionCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.nameLabel.text = [[timeSlotArray objectAtIndex:indexPath.row] valueForKey:@"DeliverySlot"];
    
    // code for cell selection
    
    if ([selectedSlotDictionary isEqual:[timeSlotArray objectAtIndex:indexPath.row]]) {
        cell.checkMarkImage.image = [UIImage imageNamed:@"check"];
    }
    else{
        cell.checkMarkImage.image = [UIImage imageNamed:@"uncheck"];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dict = [timeSlotArray objectAtIndex:indexPath.row];
    selectedSlotDictionary = [NSMutableDictionary dictionaryWithDictionary:dict] ;
    _sectionCheckMarkImage.image = [UIImage imageNamed:@"uncheck"];
    
//    timeSlotArray = [[deliveryTimeSlotsArray objectAtIndex:selectedDate] valueForKey:@"DeliveryTimeSlot"];
    
    timeSlotSelected=[NSString stringWithFormat:@"%@",[dict valueForKey:@"DeliverySlotId"]];
    slotType=[NSString stringWithFormat:@"%@",[dict valueForKey:@"DeliverySlot"]];
    
    NSMutableDictionary *dateSlot = [deliveryTimeSlotsArray objectAtIndex:selectedDate];
    
    deliveryDateAfterLogin=[dateSlot valueForKey:@"DeliveryDate"];
    deliverySlotIdAfterLogin=timeSlotSelected;
    
    [_deliveyTable reloadData];
  }

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    if ([segue.identifier isEqualToString:korderSummarySegueIdentifier]) {
        BGOrderSummaryViewController *orderSummaryViewController = segue.destinationViewController;
        
        NSMutableDictionary *dict = sender;
        [dict setObject:tomorrow forKey:@"tomorrow"];
        [dict setObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithBool:orderExists]] forKey:@"orderExists"];

        orderSummaryViewController.summaryDictionary = sender;
    }
}


#pragma mark Button clicked
- (IBAction)sectionButton_clicked:(id)sender{

    _sectionCheckMarkImage.image = [UIImage imageNamed:@"check"];
    [selectedSlotDictionary removeAllObjects];
    [_deliveyTable reloadData];
    
}

- (IBAction)bucketButton_clicked:(id)sender {

        [myView removeFromSuperview];
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        MyCartViewController *cartView = [storyBoard instantiateViewControllerWithIdentifier:kMyCartStoryBoardID];
        [self.navigationController pushViewController:cartView animated:YES];
        
}

- (IBAction)slotButton_clicked:(id)sender {
    
    [myView removeFromSuperview];
    UIButton *btn = (UIButton *)sender;
    selectedDate = btn.tag-10;
    NSMutableDictionary *dict = [deliveryTimeSlotsArray objectAtIndex:selectedDate];
    
    timeSlotArray = [dict valueForKey:@"DeliveryTimeSlot"];
    [self setDataInSlotView:btn.tag];
}


-(void)setDataInSlotView:(NSInteger)tag{
    // Get the subviews of the view
    NSArray *subviews = [_slotView subviews];
    
    for (UIView *subview in subviews) {
        
        if (subview.tag == tag) {
            subview.backgroundColor = kDefaultLightGreen;
            NSArray *subviews1 = [subview subviews];
            NSLog(@"%@",subviews1);
            
            UILabel *nameLbl = (UILabel*)[subview viewWithTag:2];
            nameLbl.textColor = [UIColor whiteColor];
            
            UILabel *dateLbl = (UILabel*)[subview viewWithTag:3];
            dateLbl.textColor = [UIColor whiteColor];
            
            
        }
        else{
            
            subview.backgroundColor = [UIColor clearColor];
            NSArray *subviews1 = [subview subviews];
            NSLog(@"%@",subviews1);
            UILabel *nameLbl = (UILabel*)[subview viewWithTag:2];
            nameLbl.textColor = [UIColor lightGrayColor];
            
            UILabel *dateLbl = (UILabel*)[subview viewWithTag:3];
            dateLbl.textColor = [UIColor blackColor];
            
        }
    }
    
    
    
    NSMutableDictionary *dict = [deliveryTimeSlotsArray objectAtIndex:tag-10];
    
    _deliveyTable.hidden = NO;

    for (UIView *subview in subviews) {
        
        NSLog(@"%ld",(long)tag);
  
        NSMutableDictionary *dict = [deliveryTimeSlotsArray objectAtIndex:subview.tag-10];
        
      //  timeSlotArray = [dict valueForKey:@"DeliveryTimeSlot"];
        
            UILabel *nameLbl = (UILabel*)[subview viewWithTag:2];
            nameLbl.text = [dict valueForKey:@"DayName"];
        
            NSDateFormatter *form=[[NSDateFormatter alloc]init];
            [form setDateFormat:@"MM-dd-yyyy"];
            NSDate *date=[form dateFromString:[dict valueForKey:@"DeliveryDate"]];
            [form setDateFormat:@"dd"];
            NSString *str = [form stringFromDate:date];
            
            UILabel *dateLbl = (UILabel*)[subview viewWithTag:3];
            dateLbl.text = str;
    }
    
    // remove selected data on change slot
    [selectedSlotDictionary removeAllObjects];
    
    [_deliveyTable reloadData];
    
    if (![[dict valueForKey:@"Holiday"] isEqualToString:@""]) {
        
        _deliveyTable.hidden = YES;
        [self showHolidayAlertWithHolidayName:[dict valueForKey:@"Holiday"]];
        
        return;
    }
}


-(void)showHolidayAlertWithHolidayName:(NSString*)holidayName
{
    NSString *description = holidayName;
    NSString *sorryString = @"Sorry, deliveries are suspended on your selected date due to  ";
    NSString *pleaseselectString =@"  Please select an alternate date for your order delivery";
    NSString *message = [NSString stringWithFormat:@"%@%@%@",sorryString,description,pleaseselectString];
    NSMutableAttributedString *hintText = [[NSMutableAttributedString alloc] initWithString:message];
    
    [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:250/255.0 green:38/255.0 blue:0/255.0 alpha:1.0]} range:NSMakeRange(sorryString.length,description.length)];
    
    [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f]} range:NSMakeRange(0,sorryString.length)];
    
    [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f]} range:NSMakeRange(sorryString.length+description.length,pleaseselectString.length)];
    
    myView = [[MyinfoView alloc] initWithFrame:CGRectMake(0, 0, 280, 180)];
    [myView showOneTimeCancelAlertWithTitle:@"Public Holiday Alert" andMessage:hintText withFram:myView.frame];
    myView.center=self.view.center;
    [self.view.window addSubview:myView];
    [myView toggle];
    
}
- (IBAction)backButton_clicked:(id)sender {
    [myView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)continueButton_clicked:(id)sender {
    [myView removeFromSuperview];
  
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [format dateFromString:deliveryDateAfterLogin];
    [format setDateFormat:@"d MMM, yyyy"];
    NSString *strDate = [format stringFromDate:date];
    
    
    if (selectedSlotDictionary.count>0) {
        
        NSString *message ;
        
        if([[selectedSlotDictionary valueForKey:@""] integerValue]>0)
        {
            message = [NSString stringWithFormat:@"Are you sure you want to place your order for %@, %@. Once confirmed it can't be changed.",strDate,slotType];
        }
        else
        {
            // for 2 hr delivery slot
            message = [NSString stringWithFormat:@"Are you sure you want to place your order for %@, %@. Once confirmed it can't be changed.",strDate,slotType];
        }
   
        [self.productListArr removeAllObjects];

            [Utility showAlertViewControllerIn:self withAction:@"NO" actionTwo:@"YES" title:@"" message:message block:^(int index){
                if (index ==1) {
                    [self placeOneTimeOrderWithStatus:@"NotConfirmed"];
                }
            }];
    }
    else{
    
        [Utility showAlertViewControllerIn:self title:@"" message:@"Please select a Slot" block:^(int index){}];
    }
}

#pragma mark - APIS
-(void)getDeliverySlot
{
    GetDeliverySlotRequest *conf = [[GetDeliverySlotRequest alloc] initWithDict:nil];
    conf.requestDelegate=self;
    [conf startAsynchronous];
    [Utility ShowMBHUDLoader];
    
}
-(void)GetDeliverySlotRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData
{
    
    [Utility hideMBHUDLoader];
    
    lineView.hidden = NO;
    _deliveyTable.hidden = NO;

    deliveryTimeSlotsArray=[inData objectForKey:@"Payload"];
    
    if (deliveryTimeSlotsArray.count>0) {
        timeSlotArray = [[deliveryTimeSlotsArray objectAtIndex:0] valueForKey:@"DeliveryTimeSlot"];
        NSMutableDictionary *dateSlot = [deliveryTimeSlotsArray objectAtIndex:0];
        deliveryDateAfterLogin=[dateSlot valueForKey:@"DeliveryDate"];
        
        [self setDataInSlotView:10];
       // [_deliveyTable reloadData];
    }
   
}
-(void)GetDeliverySlotRequestFailedWithErrorMessage:(NSString *)inFailedData
{
    [Utility hideMBHUDLoader];

    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:inFailedData delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    NSLog(@"%@",inFailedData);
    
}

#pragma  mark - check delivery on date (exit or not)
/*-(void)checkOrdersOnDate:(NSString*)deliveryDate andDeliveryTimeSlot:(NSString*)slotId
{
    int slotIdindex;
    NSMutableArray *deliverySlotIDArr=(NSMutableArray*)[deliverySlotIDArr valueForKey:@"DeliverySlotId"];
    
    
    if ([deliverySlotIDArr containsObject:[NSNumber numberWithLong:[slotId integerValue]]])
    {
        slotIdindex=(int)[deliverySlotIDArr indexOfObject:[NSNumber numberWithLong:[slotId integerValue]]];
        
    }
    else
    {
        slotIdindex=1;
        
    }
    NSDictionary *tempDic;

    for (int i=0; i<deliverySlotIDArr.count; i++)
    {
        if (i==slotIdindex) {
            tempDic=[deliverySlotIDArr objectAtIndex:slotIdindex];
            [tempDic setValue:@"1" forKey:@"btnClickCheckSlotID"];
            [deliverySlotIDArr replaceObjectAtIndex:slotIdindex withObject:tempDic];
        }
        else
        {
            tempDic=[deliverySlotIDArr objectAtIndex:i];
            [tempDic setValue:@"0" forKey:@"btnClickCheckSlotID"];
            [deliverySlotIDArr replaceObjectAtIndex:i withObject:tempDic];
        }
    }
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"loginFlag"] isEqualToString:@"login"])
    {
        [Utility ShowMBHUDLoader];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        
        
        NSNumber *memID = [[NSUserDefaults standardUserDefaults] objectForKey:@"MembershipID"];
        [dict setObject:memID forKey:@"MembershipId"];
        
        
        
        [dict setObject:slotId forKey:@"TimeSlotId"];
        
        [dict setObject:deliveryDate forKey:@"OrderDate"];
        NSLog(@"%@",dict);
        
        
        DateWiseOrderSummary *conf = [[DateWiseOrderSummary alloc] initWithDict:dict];
        conf.requestDelegate=self;
        [conf startAsynchronous];
    }
    
}

-(void)DateWiseOrderSummaryRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData
{
    //    self.isForDefault = NO;
    orderExists=YES;
    // NSArray *tempArr=[inData objectForKey:@"Payload"];
    //NSArray *SlotIdArr=[tempArr valueForKey:@"SlotId"];
    //    NSString *slotIdStr=[NSString stringWithFormat:@"%@",[SlotIdArr firstObject]];
    //    //int slotIdindex=[slotIdStr intValue];
    //    int slotIdindex;
    //   // int slotIdIndex=(int)[SlotIdArr firstObject];
    //    NSLog(@"%@",_arraySlot);
    //    NSArray *deliverySlotIDArr=[_arraySlot valueForKeyPath:@"DeliverySlotId"];
    //    if ([deliverySlotIDArr containsObject:[SlotIdArr firstObject]])
    //    {
    //          slotIdindex=(int)[deliverySlotIDArr indexOfObject:[SlotIdArr firstObject]];
    //
    //    }
    //    NSDictionary *tempDic=[_arraySlot objectAtIndex:slotIdindex];
    //    [tempDic setValue:@"1" forKey:@"btnClickCheckSlotID"];
    //    [_arraySlot replaceObjectAtIndex:slotIdindex withObject:tempDic];
    [appDelegate dismissGlobalHUD];
    [self.deliveryTabelView reloadData];
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:nil message:@"Current And Same Day Order List will be here" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ViewCart",@"KeepAllOrder", nil];
    al.tag = 999999;
    // [al show];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    arr = [inData valueForKey:@"Payload"];
    self.orderArr = [self parseOrders:arr];
    if (self.orderArr.count!=0) {
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        backView.backgroundColor = [UIColor grayColor];
        backView.alpha = 0.7f;
        [self.view addSubview:backView];
        
        CGFloat tableviewMaxHeight = self.view.frame.size.height-74-50;
        CGFloat tableviewMinHeight = self.view.frame.size.height-74-50-100;
        
        alreatView = [[UIView alloc] init];
        alreatView.backgroundColor = [UIColor whiteColor];
        if (self.orderArr.count == 1)
        {
            
            alreatView.frame = CGRectMake(0, 0, self.view.frame.size.width-20, tableviewMinHeight);
            
        }
        else
        {
            alreatView.frame = CGRectMake(0, 0, self.view.frame.size.width-20, tableviewMaxHeight);
        }
        
        alreatView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        
        aleartTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, alreatView.frame.size.width, alreatView.frame.size.height-40) style:UITableViewStylePlain];
        aleartTable.delegate = self;
        aleartTable.dataSource = self;
        
        UILabel *horizentalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, aleartTable.frame.size.height, aleartTable.frame.size.width, 1)];
        horizentalLabel.backgroundColor = [UIColor darkGrayColor];
        
        
        UIButton *viewcartBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, aleartTable.frame.size.height, aleartTable.frame.size.width/2-8, 30)];
        [viewcartBtn setBackgroundColor:[UIColor whiteColor]];
        [viewcartBtn setTitle:@"View Cart" forState:UIControlStateNormal];
        [viewcartBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        viewcartBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        [viewcartBtn addTarget:self action:@selector(viewCartClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        UILabel *verticalLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewcartBtn.frame.size.width+2, aleartTable.frame.size.height+1, 1, 40)];
        verticalLabel.backgroundColor = [UIColor darkGrayColor];
        
        UIButton *keepAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(aleartTable.frame.size.width/2, aleartTable.frame.size.height, aleartTable.frame.size.width/2, 30)];
        [keepAllBtn setTitle:@"Keep All Orders" forState:UIControlStateNormal];
        [keepAllBtn setBackgroundColor:[UIColor whiteColor]];
        [keepAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        keepAllBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        [keepAllBtn addTarget:self action:@selector(keepAllClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        [alreatView addSubview:viewcartBtn];
        [alreatView addSubview:keepAllBtn];
        [alreatView addSubview:aleartTable];
        [alreatView addSubview:verticalLabel];
        [alreatView addSubview:horizentalLabel];
        [self.view addSubview:alreatView];
    }
    else
    {
        orderExists=NO;
        [appDelegate dismissGlobalHUD];
        //    if (appDelegate.isFromPlaceOrder)
        //    {
        //        NSLog(@"PlaceOrder");
        //        [self placeOneTimeOrderWithStatus:<#(NSString *)#>]
        //    }
        //    else
        {
            //        if (self.isForDefault)
            {
                if (self.isFromOnline==YES)
                {
                    [self placeOneTimeOrderWithStatus:@"NotConfirmed"];
                    
                }
                if (self.isFromConfirm)
                {
                    [self placeOneTimeOrderWithStatus:@""];
                    
                }
            }
        }
        
    }
    
    
}

-(void)DateWiseOrderSummaryRequestFailedWithErrorMessage:(NSString *)inFailedData
{
    orderExists=NO;
    [appDelegate dismissGlobalHUD];
    //    if (appDelegate.isFromPlaceOrder)
    //    {
    //        NSLog(@"PlaceOrder");
    //        [self placeOneTimeOrderWithStatus:<#(NSString *)#>]
    //    }
    //    else
    {
        //        if (self.isForDefault)
        {
            if (self.isFromOnline==YES)
            {
                [self placeOneTimeOrderWithStatus:@"NotConfirmed"];
                
            }
            if (self.isFromConfirm)
            {
                [self placeOneTimeOrderWithStatus:@""];
                
            }
        }
    }
    //    if (appDelegate.isFromPlaceOrder)
    //    {
    //        NSDateFormatter *form = [[NSDateFormatter alloc] init];
    //        [form setDateFormat:@"yyyy-MM-dd"];
    //        NSString *calDate = [form stringFromDate:calender.selectedDate];
    //
    //        NSDateFormatter *form1 = [[NSDateFormatter alloc] init];
    //        [form1 setDateFormat:@"yyyy-MM-dd"];
    //        NSString *dateValue = [[self.holiDayArr firstObject] valueForKey:@"HolidayDate"];
    //        NSRange range = NSMakeRange (0, 10);
    //        dateValue = [dateValue substringWithRange:range];
    //        NSDate *dat1 = [form1 dateFromString:dateValue];
    //
    //        NSDateFormatter *form2 = [[NSDateFormatter alloc] init];
    //        [form2 setDateFormat:@"yyyy-MM-dd"];
    //        NSString *leavDate = [form2 stringFromDate:dat1];
    //
    //        self.isFromFailed = YES;
    //        if (self.isFromDateSelected == YES)
    //        {
    //
    //
    //            if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"loginFlag"] isEqualToString:@"login"]){
    //                NSNumber *memID = [[NSUserDefaults standardUserDefaults] objectForKey:@"MembershipID"];
    //                NSDateFormatter *format = [[NSDateFormatter alloc] init];
    //                [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    //                dateString = [format stringFromDate:tomorrow];
    //                for(NSMutableDictionary *dict in appDelegate.checkProductArr)
    //                {
    //                    NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
    //                    [dic setObject:[dict objectForKey:@"ProductID"] forKey:@"ProductId"];
    //                    NSString *qunt =[dict objectForKey:@"items"];
    //                    [dic setObject:[NSNumber numberWithInt:[qunt intValue] ] forKey:@"Quantity"];
    //                    [dic setObject:@"O" forKey:@"OrderType"];
    //                    [self.productListArr addObject:dic];
    //                }
    //                NSMutableDictionary *dictionnary = [NSMutableDictionary dictionary];
    //                [dictionnary setObject:self.productListArr forKey:@"ProductList"];
    //                NSError *error;
    //                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //                NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    //                [dict setObject:memID forKey:@"refMembershipId"];
    //                [dict setObject:dateString forKey:@"orderDate"];
    //                [dict setObject:self.productListArr forKey:@"ProductList"];
    //                [dict setObject:@"" forKey:@"Days"];
    //                [dict setObject:@"iOS" forKey:@"DeviceInfo"];
    //                [dict setObject:majorVersion forKey:@"AppVersion"];
    //                if (self.isFromConfirm == YES) {
    //                    [dict setObject:@"" forKey:@"OrderStatus"];
    //                }
    //                if (self.isFromOnline == YES) {
    //                    [dict setObject:@"NotConfirmed" forKey:@"OrderStatus"];
    //                }
    //
    //                PlaceOrder *placeOrder = [[PlaceOrder alloc] initWithDict:dict];
    //                placeOrder.requestDelegate=self;
    //                [placeOrder startAsynchronous];
    //                [appDelegate showGlobalProgressHUDWithTitle:nil];
    //            }
    //            else
    //            {
    //                alretConfirmLabel = [[UIAlertView alloc] initWithTitle:@"Welcome!" message:@"Please login or register to continue." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Login(Existing User)",@"Register(New User)", nil];
    //                [alretConfirmLabel setTag:100];
    //                [alretConfirmLabel show];
    //            }
    //        }
    //        else
    //        {
    //            if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"loginFlag"] isEqualToString:@"login"]){
    //                NSNumber *memID = [[NSUserDefaults standardUserDefaults] objectForKey:@"MembershipID"];
    //                NSDateFormatter *format = [[NSDateFormatter alloc] init];
    //                [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    //                dateString = [format stringFromDate:tomorrow];
    //                for(NSMutableDictionary *dict in appDelegate.checkProductArr)
    //                {
    //                    NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
    //                    [dic setObject:[dict objectForKey:@"ProductID"] forKey:@"ProductId"];
    //                    NSString *qunt =[dict objectForKey:@"items"];
    //                    [dic setObject:[NSNumber numberWithInt:[qunt intValue] ] forKey:@"Quantity"];
    //                    [dic setObject:@"O" forKey:@"OrderType"];
    //                    [self.productListArr addObject:dic];
    //                }
    //                NSMutableDictionary *dictionnary = [NSMutableDictionary dictionary];
    //                [dictionnary setObject:self.productListArr forKey:@"ProductList"];
    //                NSError *error;
    //                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //                NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    //                [dict setObject:memID forKey:@"refMembershipId"];
    //                [dict setObject:dateString forKey:@"orderDate"];
    //                [dict setObject:self.productListArr forKey:@"ProductList"];
    //                [dict setObject:@"" forKey:@"Days"];
    //                [dict setObject:@"iOS" forKey:@"DeviceInfo"];
    //                [dict setObject:majorVersion forKey:@"AppVersion"];
    //                [dict setObject:@"" forKey:@"OrderStatus"];
    //                PlaceOrder *placeOrder = [[PlaceOrder alloc] initWithDict:dict];
    //                placeOrder.requestDelegate=self;
    //                [placeOrder startAsynchronous];
    //                [appDelegate showGlobalProgressHUDWithTitle:nil];
    //            }
    //            else
    //            {
    //                alretConfirmLabel = [[UIAlertView alloc] initWithTitle:@"Welcome!" message:@"Please login or register to continue." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Login(Existing User)",@"Register(New User)", nil];
    //                [alretConfirmLabel setTag:100];
    //                [alretConfirmLabel show];
    //            }
    //        }
    //
    //    }
    //    else
    //    {
    //        if (self.isForDefault==YES)
    //        {
    //            if (self.isFromConfirm)
    //            {
    //                self.isForDefault = NO;
    //
    //                NSDateFormatter *form = [[NSDateFormatter alloc] init];
    //                [form setDateFormat:@"yyyy-MM-dd"];
    //                NSString *calDate = [form stringFromDate:calender.selectedDate];
    //
    //                NSDateFormatter *form1 = [[NSDateFormatter alloc] init];
    //                [form1 setDateFormat:@"yyyy-MM-dd"];
    //                NSString *dateValue = [[self.holiDayArr firstObject] valueForKey:@"HolidayDate"];
    //                NSRange range = NSMakeRange (0, 10);
    //                dateValue = [dateValue substringWithRange:range];
    //                NSDate *dat1 = [form1 dateFromString:dateValue];
    //
    //                NSDateFormatter *form2 = [[NSDateFormatter alloc] init];
    //                [form2 setDateFormat:@"yyyy-MM-dd"];
    //                NSString *leavDate = [form2 stringFromDate:dat1];
    //
    //                self.isFromFailed = YES;
    //
    //                if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"loginFlag"] isEqualToString:@"login"]){
    //                    NSNumber *memID = [[NSUserDefaults standardUserDefaults] objectForKey:@"MembershipID"];
    //                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    //                    [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    //                    dateString = [format stringFromDate:tomorrow];
    //                    for(NSMutableDictionary *dict in appDelegate.checkProductArr)
    //                    {
    //                        NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
    //                        [dic setObject:[dict objectForKey:@"ProductID"] forKey:@"ProductId"];
    //                        NSString *qunt =[dict objectForKey:@"items"];
    //                        [dic setObject:[NSNumber numberWithInt:[qunt intValue] ] forKey:@"Quantity"];
    //                        [dic setObject:@"O" forKey:@"OrderType"];
    //                        [self.productListArr addObject:dic];
    //                    }
    //                    NSMutableDictionary *dictionnary = [NSMutableDictionary dictionary];
    //                    [dictionnary setObject:self.productListArr forKey:@"ProductList"];
    //                    NSError *error;
    //                    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //                    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    //                    [dict setObject:memID forKey:@"refMembershipId"];
    //                    [dict setObject:dateString forKey:@"orderDate"];
    //                    [dict setObject:self.productListArr forKey:@"ProductList"];
    //                    [dict setObject:@"" forKey:@"Days"];
    //                    [dict setObject:@"iOS" forKey:@"DeviceInfo"];
    //                    [dict setObject:majorVersion forKey:@"AppVersion"];
    //                    [dict setObject:@"" forKey:@"OrderStatus"];
    //                    PlaceOrder *placeOrder = [[PlaceOrder alloc] initWithDict:dict];
    //                    placeOrder.requestDelegate=self;
    //                    [placeOrder startAsynchronous];
    //                    [appDelegate showGlobalProgressHUDWithTitle:nil];
    //                }
    //                else
    //                {
    //                    alretConfirmLabel = [[UIAlertView alloc] initWithTitle:@"Welcome!" message:@"Please login or register to continue." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Login(Existing User)",@"Register(New User)", nil];
    //                    [alretConfirmLabel setTag:100];
    //                    [alretConfirmLabel show];
    //                }
    //
    //
    //            }
    //            else
    //            {
    //                if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"loginFlag"] isEqualToString:@"login"])
    //                {
    //                    NSNumber *memID = [[NSUserDefaults standardUserDefaults] objectForKey:@"MembershipID"];
    //                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    //                    [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    //                    dateString = [format stringFromDate:tomorrow];
    //                    for(NSMutableDictionary *dict in appDelegate.checkProductArr)
    //                    {
    //                        NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
    //                        [dic setObject:[dict objectForKey:@"ProductID"] forKey:@"ProductId"];
    //                        NSString *qunt =[dict objectForKey:@"items"];
    //                        [dic setObject:[NSNumber numberWithInt:[qunt intValue] ] forKey:@"Quantity"];
    //                        [dic setObject:@"O" forKey:@"OrderType"];
    //                        [self.productListArr addObject:dic];
    //                    }
    //                    NSMutableDictionary *dictionnary = [NSMutableDictionary dictionary];
    //                    [dictionnary setObject:self.productListArr forKey:@"ProductList"];
    //                    NSError *error;
    //                    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //                    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    //                    [dict setObject:memID forKey:@"refMembershipId"];
    //                    [dict setObject:dateString forKey:@"orderDate"];
    //                    [dict setObject:self.productListArr forKey:@"ProductList"];
    //                    [dict setObject:@"" forKey:@"Days"];
    //                    [dict setObject:@"iOS" forKey:@"DeviceInfo"];
    //                    [dict setObject:majorVersion forKey:@"AppVersion"];
    //                    [dict setObject:@"NotConfirmed" forKey:@"OrderStatus"];
    //                    PlaceOrder *placeOrder = [[PlaceOrder alloc] initWithDict:dict];
    //                    placeOrder.requestDelegate=self;
    //                    [placeOrder startAsynchronous];
    //                    [appDelegate showGlobalProgressHUDWithTitle:nil];
    //                }
    //                else
    //                {
    //                    alretConfirmLabel = [[UIAlertView alloc] initWithTitle:@"Welcome!" message:@"Please login or register to continue." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Login(Existing User)",@"Register(New User)", nil];
    //                    [alretConfirmLabel setTag:100];
    //                    [alretConfirmLabel show];
    //                }
    //
    //            }
    //
    //
    //        }
    //
    //    }
    
}*/


#pragma mark - place order
-(void)placeOneTimeOrderWithStatus:(NSString*)status
{
    appDelegate.isFromPlaceOrder=NO;
    

    NSNumber *memID = [loginInfo objectForKey:@"RefMembershipID"];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd/yyyy"];
    tomorrow=[format dateFromString:deliveryDateAfterLogin];
    [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    dateString = [format stringFromDate:tomorrow];
    [self.productListArr removeAllObjects];
    
    [self saveDateAndTimeSlot:selectedSlotDictionary str:deliveryDateAfterLogin];
    for(NSMutableDictionary *dict in appDelegate.checkProductArray)
    {
        NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
        [dic setObject:[dict objectForKey:@"ProductID"] forKey:@"ProductId"];
        NSString *qunt =[dict objectForKey:@"productCount"];
        [dic setObject:[NSNumber numberWithInt:[qunt intValue] ] forKey:@"Quantity"];
        [dic setObject:@"O" forKey:@"OrderType"];
        [self.productListArr addObject:dic];
    }
    NSMutableDictionary *dictionnary = [NSMutableDictionary dictionary];
    [dictionnary setObject:self.productListArr forKey:@"ProductList"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:memID forKey:@"refMembershipId"];
    [dict setObject:dateString forKey:@"orderDate"];
    [dict setObject:self.productListArr forKey:@"ProductList"];
    [dict setObject:@"" forKey:@"Days"];
    [dict setObject:@"iOS" forKey:@"DeviceInfo"];
    [dict setObject:majorVersion forKey:@"AppVersion"];
    [dict setObject:status forKey:@"OrderStatus"];
    [dict setObject:timeSlotSelected forKey:@"TimeSlotId"];
    
    PlaceOrder *placeOrder = [[PlaceOrder alloc] initWithDict:dict];
    placeOrder.requestDelegate=self;
    [placeOrder startAsynchronous];
    [Utility ShowMBHUDLoader];
}

-(void)saveDateAndTimeSlot:(NSMutableDictionary *)dict str:(NSString *)strDate{
   
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd/yyyy"];
    tomorrow=[format dateFromString:deliveryDateAfterLogin];
    [format setDateFormat:@"dd MMM, yyyy"];
    dateString = [format stringFromDate:tomorrow];
    
    
   
    
}

- (void)PlaceOrderRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData
{
    [Utility hideMBHUDLoader];
    NSString *slotDate = [NSString stringWithFormat:@"%@ (%@)",[[inData valueForKey:@"Payload"] valueForKey:@"orderDate"],[[inData valueForKey:@"Payload"] valueForKey:@"DeliveryTime"]];
    [loginInfo setObject:slotDate forKey:@"slotTime"];
    
    
    [kUserDefault setValue:[Utility archiveData:loginInfo] forKey:kLoginInfo];
    
    if ([[inData valueForKey:@"Message"] isEqualToString:@"Sorry! Cut off time for current day order expired. Please select a different date."])
    {
    [Utility hideMBHUDLoader];

    }
    else if (self.isFromFailed == YES)
    {
        self.isFromFailed = NO;
        if (self.isFromConfirm == YES)
        {
            errorMsg=[inData objectForKey:@"Message"] ;
            NSString *CreditUsedPercentage = [[NSUserDefaults standardUserDefaults] stringForKey:@"CreditUsedPercentage"];
            dateString = dateText;
          
            NSString *price=[NSString stringWithFormat:@"₹ %.1f",[[[inData valueForKey:@"Payload"] valueForKey:@"OrderAmount"] floatValue] ];
            
            NSString *yourOrderString;
            NSString *deliverString;
            NSString *restString;
            NSString *message;
            
            if (orderExists==NO) {
                yourOrderString =@"Your order for ";
                deliverString =@" with delivery date  ";
                restString = [NSString stringWithFormat:@" has been received. We will notify you when your order is processed on the day of delivery.  Please note that you may use credits in your account for a max. of %.1f%@ of this order value.",[CreditUsedPercentage floatValue],@"%"];
                message = [NSString stringWithFormat:@"%@%@%@%@%@",yourOrderString,price,deliverString,dateString,restString];
                NSMutableAttributedString *hintText = [[NSMutableAttributedString alloc] initWithString:message];
                
                [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:24/255.0 green:121/255.0 blue:184/255.0 alpha:1.0]} range:NSMakeRange(yourOrderString.length,price.length)];
                
                [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:72/255.0 green:144/255.0 blue:48/255.0 alpha:1.0]} range:NSMakeRange(yourOrderString.length+price.length + deliverString.length,dateString.length)];
                //Rest of text -- just futura
                [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f]} range:NSMakeRange(yourOrderString.length+price.length + deliverString.length + dateString.length, hintText.length-(yourOrderString.length+price.length + deliverString.length + dateString.length))];
                
                [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f]} range:NSMakeRange(0,yourOrderString.length)];
                
                [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f]} range:NSMakeRange(yourOrderString.length+price.length,deliverString.length)];
                if([[inData objectForKey:@"Message"]  isEqualToString:@"Order created successfully."])
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
                    alert.tag = 0;
                    //[alert show];
                    myView = [[MyinfoView alloc] initWithFrame:CGRectMake(0, 0, 280, 240)];
                    [myView showAlertWithTitle:[inData objectForKey:@"Message"]  andMessage:hintText withFram:myView.frame];
                    myView.center=self.view.center;
                    //if(show_thank==YES)
                    // {
//                    show_thank=NO;
                    // }
                    // else
                    // {
                    [self.view.window addSubview:myView];
                    [myView toggle];
                    //  }
//                    [self sendmailsms];
//                    ThankYouViewController *thankView = [[ThankYouViewController alloc] initWithNibName:@"ThankYouViewController" bundle:[NSBundle mainBundle]];
//                    thankView.deliverDate= dateText;
//                    thankView.dateString=dateString;
//                    thankView.orderDate = tomorrow;
//                    thankView.navigationItem.title=@"Thank You";
//                    [self.navigationController pushViewController:thankView animated:YES];
                    
                }
                
                
            }
            else
            {
                yourOrderString =@"You have successfully edited your order for ";
                deliverString =@"Your revised total order value is  ";
                restString = [NSString stringWithFormat:@"We will notify you when your order is processed on the day of delivery.  Please note that you may use credits in your account for a max. of %.1f%@ of this order value.",[CreditUsedPercentage floatValue],@"%"];
                
                message = [NSString stringWithFormat:@"%@%@%@%@%@",yourOrderString,dateString,deliverString,price,restString];
                
                NSMutableAttributedString *hintText = [[NSMutableAttributedString alloc] initWithString:message];
                
                [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:72/255.0 green:144/255.0 blue:48/255.0 alpha:1.0]} range:NSMakeRange(yourOrderString.length,dateString.length)];
                
                [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:24/255.0 green:121/255.0 blue:184/255.0 alpha:1.0]} range:NSMakeRange(yourOrderString.length+dateString.length + deliverString.length,price.length)];
                //Rest of text -- just futura
                [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f]} range:NSMakeRange(yourOrderString.length+dateString.length + deliverString.length + price.length, hintText.length-(yourOrderString.length+dateString.length + deliverString.length + price.length))];
                
                [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f]} range:NSMakeRange(0,yourOrderString.length)];
                
                [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f]} range:NSMakeRange(yourOrderString.length+dateString.length,deliverString.length)];
                if([[inData objectForKey:@"Message"]  isEqualToString:@"Order created successfully."])
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
                    alert.tag = 0;
                    //[alert show];
                    myView = [[MyinfoView alloc] initWithFrame:CGRectMake(0, 0, 280, 240)];
                    [myView showAlertWithTitle:[inData objectForKey:@"Message"]  andMessage:hintText withFram:myView.frame];
                    myView.center=self.view.center;

                    [self.view.window addSubview:myView];
                    [myView toggle];

                    
                }
                
                
            }
      
        }
        else
        {
      
        }
        
    }
    else
    {
        
        NSString *order_str=[NSString stringWithFormat:@"%@",[[inData objectForKey:@"Payload"]objectForKey:@"OrderId"]] ;
        NSString *amount_str=[NSString stringWithFormat:@"%@",[[inData objectForKey:@"Payload"]objectForKey:@"CollectableAmount"]] ;
        [loginInfo setObject:order_str forKey:@"payment_order_id"];
        [loginInfo setObject:amount_str forKey:@"payment_order_amount"];
        
        [kUserDefault setValue:[Utility archiveData:loginInfo] forKey:kLoginInfo];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        if (self.isFromConfirm == YES)
        {
            errorMsg=[inData objectForKey:@"Message"] ;
            NSString *CreditUsedPercentage = [[NSUserDefaults standardUserDefaults] stringForKey:@"CreditUsedPercentage"];
             dateString=dateText;
            //            NSString *price =[NSString stringWithFormat:@"₹ %.1f",[self.totalPrice floatValue] ];
            NSString *price=[NSString stringWithFormat:@"₹ %.1f",[[[inData valueForKey:@"Payload"] valueForKey:@"OrderAmount"] floatValue] ];
            NSString *yourOrderString;
            NSString *deliverString;
            NSString *restString;
            NSString *message;
            
            if (orderExists==NO) {
                yourOrderString =@"Your order for ";
                deliverString =@" with delivery date  ";
                restString = [NSString stringWithFormat:@" has been received. We will notify you when your order is processed on the day of delivery.  Please note that you may use credits in your account for a max. of %.1f%@ of this order value.",[CreditUsedPercentage floatValue],@"%"];
                
                message = [NSString stringWithFormat:@"%@%@%@%@%@",yourOrderString,price,deliverString,dateString,restString];
                NSMutableAttributedString *hintText = [[NSMutableAttributedString alloc] initWithString:message];
                
                [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:24/255.0 green:121/255.0 blue:184/255.0 alpha:1.0]} range:NSMakeRange(yourOrderString.length,price.length)];
                
                [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:72/255.0 green:144/255.0 blue:48/255.0 alpha:1.0]} range:NSMakeRange(yourOrderString.length+price.length + deliverString.length,dateString.length)];
                //Rest of text -- just futura
                [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f]} range:NSMakeRange(yourOrderString.length+price.length + deliverString.length + dateString.length, hintText.length-(yourOrderString.length+price.length + deliverString.length + dateString.length))];
                
                [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f]} range:NSMakeRange(0,yourOrderString.length)];
                
                [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f]} range:NSMakeRange(yourOrderString.length+price.length,deliverString.length)];
                if([[inData objectForKey:@"Message"]  isEqualToString:@"Order created successfully."])
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
                    alert.tag = 0;
                    //[alert show];
                    myView = [[MyinfoView alloc] initWithFrame:CGRectMake(0, 0, 280, 240)];
                    [myView showAlertWithTitle:[inData objectForKey:@"Message"]  andMessage:hintText withFram:myView.frame];
                    myView.center=self.view.center;
         
                    [self.view.window addSubview:myView];
                    [myView toggle];
                }
                
            }
            else
            {
                yourOrderString =@"You have successfully edited your order for ";
                deliverString =@". Your revised total order value is  ";
                restString = [NSString stringWithFormat:@". We will notify you when your order is processed on the day of delivery.  Please note that you may use credits in your account for a max. of %.1f%@ of this order value.",[CreditUsedPercentage floatValue],@"%"];
                
                message = [NSString stringWithFormat:@"%@%@%@%@%@",yourOrderString,dateString,deliverString,price,restString];
                NSMutableAttributedString *hintText = [[NSMutableAttributedString alloc] initWithString:message];
                
                [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:72/255.0 green:144/255.0 blue:48/255.0 alpha:1.0]} range:NSMakeRange(yourOrderString.length,dateString.length)];
                
                [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:24/255.0 green:121/255.0 blue:184/255.0 alpha:1.0]} range:NSMakeRange(yourOrderString.length+dateString.length + deliverString.length,price.length)];
                //Rest of text -- just futura
                [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f]} range:NSMakeRange(yourOrderString.length+dateString.length + deliverString.length + price.length, hintText.length-(yourOrderString.length+dateString.length + deliverString.length + price.length))];
                
                [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f]} range:NSMakeRange(0,yourOrderString.length)];
                
                [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f]} range:NSMakeRange(yourOrderString.length+dateString.length,deliverString.length)];
                
                
                if([[inData objectForKey:@"Message"]  isEqualToString:@"Order created successfully."])
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
                    alert.tag = 0;
                    //[alert show];
                    myView = [[MyinfoView alloc] initWithFrame:CGRectMake(0, 0, 280, 240)];
                    [myView showAlertWithTitle:[inData objectForKey:@"Message"]  andMessage:hintText withFram:myView.frame];
                    myView.center=self.view.center;
         
                    [self.view.window addSubview:myView];
                    [myView toggle];
                }
            }
        }
        
        else
        {
            [self performSegueWithIdentifier:korderSummarySegueIdentifier sender:[inData valueForKey:@"Payload"]];
        }
        
    }
}
-(void)PlaceOrderRequestFailedWithErrorMessage:(NSString *)inFailedData
{
    
    [Utility hideMBHUDLoader];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:inFailedData delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //alert.tag = 1000;
    [alert show];
    
}
@end
