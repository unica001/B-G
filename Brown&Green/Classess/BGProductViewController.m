//
//  BGProductViewController.m
//  Brown&Green
//
//  Created by vineet patidar on 29/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "BGProductViewController.h"
#import "UIBarButtonItem+Badge.h"

@interface BGProductViewController (){
    AppDelegate *appDelegate;
    UILabel *badgeLabel;
    NSMutableArray *sectionArray;
    NSMutableArray *tempArray;
    UIView *productImageView;
}

@end

@implementation BGProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedCountArray = [[NSMutableArray alloc]init];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    iofDB = [IOFDB sharedManager];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    // google analytics
    if (self.dicCategory) {
        id tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName
               value:[NSString stringWithFormat:@"Productlist / %@",[self.dicCategory valueForKey:@"CategoryName"]]];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
    
    
    if ([self.fromSearch isEqualToString:kGlobalSearch]) {// search
        [self prepareSearchBar];
        
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:KAge] integerValue]>=18)
        {
            productArray = [iofDB getProducts];
        }
        else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K!=%@",@"RefCategoryID",@"9"];
            
            productArray = [NSMutableArray arrayWithArray:[[iofDB.mArrProducts filteredArrayUsingPredicate:predicate] mutableCopy]];
        }
    }
    else{  // category products
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%@",@"RefCategoryID",[self.dicCategory valueForKey:@"CategoryID"]];
        productArray = [[iofDB.mArrProducts filteredArrayUsingPredicate:predicate] mutableCopy];
        // if not having product in categories, check sub categories
        if (productArray.count==0)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%@",@"RefSubCategoryID",[self.dicCategory valueForKey:@"CategoryID"]];
            NSLog(@"%@",[[iofDB.mArrProducts filteredArrayUsingPredicate:predicate] mutableCopy]);
            productArray = [[iofDB.mArrProducts filteredArrayUsingPredicate:predicate] mutableCopy];
        }
    }
    
    
    if (productArray.count==0) {
        [Utility showAlertViewControllerIn:self title:@"" message:@"No product found" block:^(int index){
            
            if ([kUserDefault valueForKey:KAge]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    // bucket product count label
    badgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kiPhoneWidth-20, 1, 20, 20)];
    badgeLabel.layer.cornerRadius = 10;
    badgeLabel.textColor = [UIColor whiteColor];
    [badgeLabel.layer setMasksToBounds:YES];
    badgeLabel.backgroundColor = kDefaultLightGreen;
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.font = [UIFont systemFontOfSize:12];
    
    [self.navigationController.navigationBar addSubview:badgeLabel];
    if ([appDelegate.checkProductArray count]>0) {
        badgeLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[appDelegate.checkProductArray count]];
        _goToCartButtonHeight.constant = 40;
    }
    else{
        _goToCartButtonHeight.constant = 0;
        badgeLabel.text = @"";
        badgeLabel.hidden = YES;
    }
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"ProductName" ascending:YES];
    productArray= (NSMutableArray *)[productArray sortedArrayUsingDescriptors:@[sort]];
    
    NSMutableArray *ProductNameArray = [productArray valueForKey:@"ProductName"];
    NSMutableArray *arrayFilter = [[NSMutableArray alloc]init];
    for (NSString *str in ProductNameArray) {
        
        [arrayFilter addObject:[str substringToIndex:1]];
    }
    NSSet *set = [NSSet setWithArray:arrayFilter];
    aToZArray = (NSMutableArray*)[set allObjects];
    [ProductTable reloadData];
    
    if (![self.fromSearch isEqualToString:kGlobalSearch]) {// search
        [self createSectionList:productArray];
    }
    ProductTable.sectionIndexTrackingBackgroundColor = [UIColor  darkGrayColor];
}


#pragma mark -
#pragma mark Creat Scetion  Indexing

- (void)createSectionList: (id) list{
    // Build an array with 26 sub-array sections
    sectionArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 27; i++)
        [sectionArray addObject:[[NSMutableArray alloc] init]];
    // Add each word to its alphabetical section
    for (NSDictionary *data in productArray)
    {
        NSString *word = [data objectForKey:@"ProductName"];
        //NSLog(@"%@",word);
        if ([word length] == 0) continue;
        // determine which letter starts the name
        NSRange range = [ALPHA rangeOfString:[[word substringToIndex:1] uppercaseString]];
        if (range.length > 0)
        {
            [[sectionArray objectAtIndex:range.location] addObject:data];
        }
        else {
            [[sectionArray objectAtIndex:26] addObject:data];
        }
    }
    [ProductTable reloadData];
}


-(void)viewWillDisappear:(BOOL)animated{
    badgeLabel.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate methods

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    tempArray = [[NSMutableArray alloc] init];
    
    [tempArray addObject:@"A"];
    [tempArray addObject:@"B"];
    [tempArray addObject:@"C"];
    [tempArray addObject:@"D"];
    [tempArray addObject:@"E"];
    [tempArray addObject:@"F"];
    [tempArray addObject:@"G"];
    [tempArray addObject:@"H"];
    [tempArray addObject:@"I"];
    [tempArray addObject:@"J"];
    [tempArray addObject:@"K"];
    [tempArray addObject:@"L"];
    [tempArray addObject:@"M"];
    [tempArray addObject:@"N"];
    [tempArray addObject:@"O"];
    [tempArray addObject:@"P"];
    [tempArray addObject:@"Q"];
    [tempArray addObject:@"R"];
    [tempArray addObject:@"S"];
    [tempArray addObject:@"T"];
    [tempArray addObject:@"U"];
    [tempArray addObject:@"V"];
    [tempArray addObject:@"W"];
    [tempArray addObject:@"X"];
    [tempArray addObject:@"Y"];
    [tempArray addObject:@"Z"];
    [tempArray addObject:@"#"];
    
    ProductTable.sectionIndexTrackingBackgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    // background color while the index view is being touched
    if ([ProductTable respondsToSelector:@selector(sectionIndexBackgroundColor)])
        ProductTable.sectionIndexBackgroundColor = [UIColor whiteColor];
    // background color while the index view is NOT touched at all
    [ProductTable setSectionIndexColor:kDefaultLightGreen];
    
    return tempArray;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([[sectionArray objectAtIndex:section] count]>0) {

    UIView* headerView =[[UIView alloc]initWithFrame:CGRectMake(15, 0, kiPhoneWidth-30, 20)];
    headerView.backgroundColor = kDefaultLightGreen;
    UILabel* headerLbl =[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 50, 20)];
    headerLbl.text =[tempArray objectAtIndex:section];
    headerLbl.textColor =[UIColor whiteColor];
    
    [headerView addSubview:headerLbl];
        
    return headerView;
    }
    
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if ([[sectionArray objectAtIndex:section] count]>0) {
        return 20;
    }
    else{
        return 0.001;
    }
    
    return 0.01;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [sectionArray count];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[sectionArray objectAtIndex:section] count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if ([[sectionArray objectAtIndex:section] count]>0) {
        return 10.0;
    }
    else{
        return 0.001;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier3  =@"cell";
    
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ProductCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.productTable = ProductTable;
    cell.goToCartButtonHeight = _goToCartButtonHeight;
    cell.badgeLabel = badgeLabel;
    NSMutableDictionary *dict = [[sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
   // NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(appDelegate.checkProductArray.count>0)
    {
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"ProductID == %@",[NSString stringWithFormat:@"%@", [dict valueForKey:@"ProductID"]]];
        
        NSArray *filterArray = [appDelegate.checkProductArray filteredArrayUsingPredicate:predicate];
        if (filterArray.count>0) {
            dict = [filterArray objectAtIndex:0];
        }
       
    }
    
    
    
    cell.budgesLabel = badgeLabel;
    cell.bucketButton = _bucketButton;
    
    [cell setData:dict index:indexPath.row];
    cell.textField.tag = indexPath.section;
    [cell.prodctImageButton addTarget:self action:@selector(productImageClicked:) forControlEvents:UIControlEventTouchUpInside];
    
   
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(appDelegate.checkProductArray.count>0)
    {
        NSMutableDictionary *dict = [[sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"ProductID == %@",[NSString stringWithFormat:@"%@", [dict valueForKey:@"ProductID"]]];
        
        NSArray *filterArray = [appDelegate.checkProductArray filteredArrayUsingPredicate:predicate];
        if (filterArray.count>0) {
            return 230;
        }
        else{
            return 160;
        }
        
    }else
    {
        if (![[[[sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:kproductCount] isKindOfClass:[NSNull class]] && [[[[sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:kproductCount] integerValue]>0) {
            return 230;
        }
        else{
            return 160;
        }
    }

    
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* NSMutableDictionary *dicProduct = [productArray objectAtIndex:indexPath.section];
     
     [Utility showAlertViewControllerIn:self title:@"" message:[dicProduct valueForKey:@"Description"] block:^(int index){}];*/
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma  mark - button clicked


-(void)removeImage_clicked:(UIButton*)sender{

    if (productImageView) {
        [productImageView removeFromSuperview];
    }
}

-(void)productImageClicked:(UIButton*)sender{

    // get cell index
    ProductCell *productCell=(ProductCell*) sender.superview.superview;
    NSIndexPath *indexPath = [ProductTable indexPathForCell:productCell];
    
    // get image URL
    NSMutableDictionary *dict = [[sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
     NSString *imageName = [dict valueForKey:@"ImgName"];

    
    // creat sub view to show large image view
    productImageView = [[UIView alloc]initWithFrame:self.view.window.frame];
    productImageView.backgroundColor = [UIColor clearColor];
    [appDelegate.window addSubview:productImageView];
    
    UIView *view = [[UIView alloc]initWithFrame:self.view.window.frame];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.4;
    [productImageView addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc]
                              initWithFrame:self.view.window.frame];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [productImageView addSubview:imageView];
    
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageUrl,imageName]]
    placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageRefreshCached];
    
    UIButton *removeImage = [[UIButton alloc]initWithFrame:self.view.window.frame];
    [removeImage addTarget:self action:@selector(removeImage_clicked:) forControlEvents:UIControlEventTouchUpInside];
    [productImageView addSubview:removeImage];
   
    
}

-(void)prepareSearchBar{
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    searchBarBoundsY = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, searchBarBoundsY, [UIScreen mainScreen].bounds.size.width, 44)];
    searchBar.searchBarStyle    = UISearchBarStyleMinimal;
    searchBar.showsCancelButton = NO;
    searchBar.tintColor         = [UIColor whiteColor];
    searchBar.barTintColor      = [UIColor clearColor];
    searchBar.delegate          = self;
    searchBar.placeholder       = @"search here";
    searchBar.returnKeyType = UIReturnKeySearch;
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    self.navigationItem.titleView = searchBar;
    //self.navigationItem.hidesBackButton = YES;
    [searchBar becomeFirstResponder];
    
    //    UIBarButtonItem *barButtonCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButton_Clicked:)];
    //
    //
    //    self.navigationItem.rightBarButtonItem= barButtonCancel;
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backButton_clicked:)];
    [barButton setImage:[UIImage imageNamed:@"backButton"]];
    self.navigationItem.leftBarButtonItem = barButton;
    
    self.searchBarActive = YES;
}

-(void)notificationButton_clicked:(UIButton *)sender{
    
}
- (IBAction)backButton_clicked:(id)sender {
    
    if ([self.incommingViewType isEqualToString:kSubCatList]) {
    [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
}


- (IBAction)bucketButton_clicked:(id)sender {
    [searchBar resignFirstResponder];

    if (appDelegate.checkProductArray.count>0) {
        [self myCartView];
    }
    else{
        [Utility showAlertViewControllerIn:self title:@"" message:@"Your shoping cart is empty." block:^(int index){}];
    }
    
}

- (IBAction)goToCartButton_clicked:(id)sender {
    
    [searchBar resignFirstResponder];

    if (appDelegate.checkProductArray.count>0) {
        [self myCartView];
    }
    else{
        [Utility showAlertViewControllerIn:self title:@"" message:@"Your shoping cart is empty." block:^(int index){}];
    }}


-(void)cancelButton_Clicked:(UIButton *)sender{
    [searchBar resignFirstResponder];

    self.searchBarActive = NO;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.titleView = nil;
    [self setNAvogationBar];
}

-(void)setNAvogationBar
{
    self.navigationController.navigationBarHidden=NO;
    //[self.navigationItem.backBarButtonItem setTitle:@" "];
    self.navigationItem.title= [self.dicCategory valueForKey:@"CategoryName"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(30.0f, 0.0f, 25.0f, 40.0f)];
    [btn addTarget:self action:@selector(revealBtnClicked : event :) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    
    UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSearch setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 40.0f)];
    [btnSearch addTarget:self action:@selector(searchButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnSearch setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    
    UIView *vew = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 40)];
    [vew addSubview:btnSearch];
    [vew addSubview:btn];
    
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithCustomView:vew];
    
    self.navigationItem.rightBarButtonItem= searchBtn;
    
}
-(void)myCartView{
    
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     // kFIRParameterItemID:[NSString stringWithFormat:@"SubCategoryid-%@", [[subCategoryArray objectAtIndex:0]valueForKey:@"CategoryID"]],
                                     kFIRParameterItemName:@"Cart",
                                     kFIRParameterContentType:@"button"
                                     }];
    appDelegate.totalItemCount = 0;
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MyCartViewController *cartView = [storyBoard instantiateViewControllerWithIdentifier:kMyCartStoryBoardID];
    cartView.incomingType = kProduct;
    [self.navigationController pushViewController:cartView animated:YES];
    
}


#pragma  mark - text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *newStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if (range.location == 60) {
        return NO;
    }
    else if (newStr.length>60) {
        return NO;
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    CGPoint buttonPosition = [textField convertPoint:CGPointZero
                                              toView:ProductTable];
    NSIndexPath *tappedIP = [ProductTable indexPathForRowAtPoint:buttonPosition];
    NSMutableDictionary *dicProduct = [[sectionArray objectAtIndex:tappedIP.section]  objectAtIndex:tappedIP.row];
    
    if (appDelegate.checkProductArray.count>0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ProductID = %@",[NSString stringWithFormat:@"%@",[dicProduct valueForKey:@"ProductID"]]];
        
        NSArray *filterArray = [appDelegate.checkProductArray filteredArrayUsingPredicate:predicate];
        
        NSMutableDictionary *dict = [filterArray objectAtIndex:0];
        
        if ([appDelegate.checkProductArray containsObject:dict]) {
            [appDelegate.checkProductArray removeObject:dict];
            [dict setValue:textField.text forKey:kRequestTextField];
            
            [appDelegate.checkProductArray addObject:dict];
        }
        
    }
    
    
}

#pragma mark - search bar clicked

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self filterContentForSearchText:searchText];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    productArray = [iofDB getProducts];
    [ProductTable reloadData];
    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchbar{
    
    [searchBar resignFirstResponder];
    [self filterContentForSearchText:searchBar.text];
    
}
- (void)filterContentForSearchText:(NSString*)searchText{
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString = [searchText stringByTrimmingCharactersInSet:whitespace];
    
    if (searchText.length > 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@ OR %K BEGINSWITH[cd] %@ OR %K CONTAINS[cd] %@ OR %K CONTAINS[cd]%@ OR %K BEGINSWITH[cd] %@",@"ProductName",trimmedString,@"BrandName",trimmedString,@"ProductName",[NSString stringWithFormat:@" %@",searchText],@"BrandName",[NSString stringWithFormat:@" %@",searchText],@"SKUID",[NSString stringWithFormat:@"%@",searchText]];
        
        //  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText];
        
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:KAge] integerValue]>=18)
        {
            productArray = [iofDB getProducts];
        }
        else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K!=%@",@"RefCategoryID",@"9"];
            
            productArray = [NSMutableArray arrayWithArray:[[iofDB.mArrProducts filteredArrayUsingPredicate:predicate] mutableCopy]];
        }
        
        productArray = (NSMutableArray *)[productArray filteredArrayUsingPredicate:predicate];
        
    }
    else{

        if([[[NSUserDefaults standardUserDefaults] valueForKey:KAge] integerValue]>=18)
        {
            productArray = [iofDB getProducts];
        }
        else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K!=%@",@"RefCategoryID",@"9"];
            
            productArray = [NSMutableArray arrayWithArray:[[iofDB.mArrProducts filteredArrayUsingPredicate:predicate] mutableCopy]];
        }}
    
    
    [self createSectionList:productArray];
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [searchBar resignFirstResponder];

}

@end
