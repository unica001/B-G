//
//  BGSubCategoryViewController.m
//  Brown&Green
//
//  Created by vineet patidar on 18/07/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "BGSubCategoryViewController.h"
#import "BGProductViewController.h"


@interface BGSubCategoryViewController (){
    UILabel *badgeLabel;
    AppDelegate *appDelegate;
    UIButton *btnSearch;
}

@end

@implementation BGSubCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInitialLayout];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{

    appDelegate =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    if (appDelegate.checkProductArray.count>0) {
        badgeLabel.hidden = NO;
        
        badgeLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)appDelegate.checkProductArray.count];
    }
    else{
        badgeLabel.hidden = YES;
        badgeLabel.text = @"";
    }
    btnSearch.hidden = NO;

}

-(void)viewWillDisappear:(BOOL)animated{
    badgeLabel.hidden = YES;
    badgeLabel.text = @"";
    btnSearch.hidden = YES;
}
-(void)setInitialLayout{
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    UICollectionView *_collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(10, 10, kiPhoneWidth-20,kiPhoneHeight-84) collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    _collectionView.layer.cornerRadius = 10.0;
    [_collectionView.layer setMasksToBounds:YES];
    
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    
    self.view.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1];
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backButton"]  style:UIBarButtonItemStylePlain target:self action:@selector(backButton_clicked:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
//    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MyCart"]  style:UIBarButtonItemStylePlain target:self action:@selector(bucketButton_clicked:)];
//    self.navigationItem.rightBarButtonItem = searchButton;
    
    
     btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSearch setFrame:CGRectMake(kiPhoneWidth - 100, 0.0f, 25.0f, 40.0f)];
    [btnSearch addTarget:self action:@selector(searchButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
    //[btnSearch setBackgroundColor:[UIColor redColor]];
    [btnSearch setImage:[UIImage imageNamed:@"Search"] forState:UIControlStateNormal];
    
    [self.navigationController.navigationBar addSubview:btnSearch];
    
    
    UIBarButtonItem *bucketButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MyCart"]  style:UIBarButtonItemStylePlain target:self action:@selector(bucketButton_clicked:)];
    self.navigationItem.rightBarButtonItem = bucketButton;
    
    // bucket product count label
    badgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kiPhoneWidth-20, 1, 20, 20)];
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.layer.cornerRadius = 10;
    [badgeLabel.layer setMasksToBounds:YES];
    badgeLabel.backgroundColor = kDefaultLightGreen;
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.font = [UIFont systemFontOfSize:12];
    [self.navigationController.navigationBar addSubview:badgeLabel];
}
#pragma mark - Collection view delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.subCategoryArray.count;
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
    
    
    NSString *subCatName=[[self.subCategoryArray objectAtIndex:indexPath.row] valueForKey:@"CategoryName"];
    subCategoryLabel.text = subCatName;
    
    
    NSString *subCatImage=[[self.subCategoryArray objectAtIndex:indexPath.row] valueForKey:@"CategoryImage"];
    NSString *finalBImageUrl = [NSString stringWithFormat:@"%@%@",kBCatImageUrl,subCatImage];
    
    [profileImageView sd_setImageWithURL:[NSURL URLWithString:finalBImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageRefreshCached];
    
    // cell.backgroundColor = [UIColor lightGrayColor];
    
    cell.layer.cornerRadius = 5.0;
    cell.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(2.5f, 2.5f);
    cell.layer.shadowRadius = 1.0f;
    cell.layer.shadowOpacity = 0.5f;
    cell.backgroundColor = [UIColor whiteColor];
    
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
    
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    BGProductViewController *productViewController = [storyBoard instantiateViewControllerWithIdentifier:@"productViewController"];
    productViewController.title = [[self.subCategoryArray objectAtIndex:indexPath.row] valueForKey:@"CategoryName"];
    productViewController.dicCategory = [self.subCategoryArray objectAtIndex:indexPath.row];
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     // kFIRParameterItemID:[NSString stringWithFormat:@"SubSubCategoryid-%@", [[self.subCategoryArray objectAtIndex:indexPath.row]valueForKey:@"CategoryID"]],
                                     kFIRParameterItemName:[NSString stringWithFormat:@"SubSubCategoryid-%@", [[self.subCategoryArray objectAtIndex:indexPath.row]valueForKey:@"CategoryID"]],
                                     kFIRParameterContentType:[NSString stringWithFormat:@"SubSubCategoryid-%@", productViewController.title]
                                     }];
    
    [self.navigationController pushViewController:productViewController animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - button Action

-(void)myCartView{
    
    appDelegate.totalItemCount = 0;
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
- (void)bucketButton_clicked:(UIButton*)sender {
    if (appDelegate.checkProductArray.count>0) {
        [self myCartView];
    }
    else{
        [Utility showAlertViewControllerIn:self title:@"" message:@"Your shoping cart is empty." block:^(int index){}];
    }
    
}

-(void)searchButton_clicked:(UIButton *)sender{

    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    BGProductViewController *productViewController = [storyBoard instantiateViewControllerWithIdentifier:@"productViewController"];
    productViewController.fromSearch = kGlobalSearch;
    productViewController.incommingViewType = kSubCatList;
    [self.navigationController pushViewController:productViewController animated:YES];
}

-(void)backButton_clicked:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
