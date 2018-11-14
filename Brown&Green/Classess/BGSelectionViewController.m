//
//  BQUserSelectionViewController.m
//  Biqe
//
//  Created by vineet patidar on 18/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "BGSelectionViewController.h"
#import "userSelectionCell.h"

@interface BGSelectionViewController ()

@end

@implementation BGSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([self.userType isEqualToString:kOtherCity]) {
        NSMutableDictionary *cityDictionary = (NSMutableDictionary *)[UtilityPlist  getData:kCityList];
        if (cityDictionary.count>0) {
            _userArray = [cityDictionary valueForKey:kAPIPayload];
            filterArray = [cityDictionary valueForKey:kAPIPayload];
        }
    }
    else{
        _userArray = [[NSMutableArray alloc]init];

      [self geLocationList];
    }
    
    [self prepareSearchBar];
    
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
    
}

-(void)geLocationList{
    
    NSString *url;
    
    url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"generics.svc/GetlocationList/"];
    
    [[ConnectionManager sharedInstance] sendGETRequestForURL:url params:nil timeoutInterval:kAPIResponseTimeout showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:STATUS] boolValue]== 1) {
                    
                    NSArray *array = [dictionary valueForKey:kAPIPayload];
                    
                    for (NSMutableDictionary *dict in array) {
                        if ([[dict valueForKey:@"RefCityId"] integerValue] == [self.cityID integerValue]) {
                            [_userArray addObject:dict];
                        }
                        
                    }
                    
                    if (!(_userArray.count>0)) {
                        _userArray = [NSMutableArray arrayWithArray:array];
                    }
                    filterArray = [NSMutableArray arrayWithArray:_userArray];

                    [_userSelectionTable reloadData];
                }
                
            });
        }
        
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [filterArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier  =@"cell";
    
    userSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"userSelectionCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if ([self.userType isEqualToString:kOtherCity]) {
         cell.nameLabel.text = [[_userArray objectAtIndex:indexPath.row]valueForKey:@"cityName"];
    }
    else{
    cell.nameLabel.text = [[filterArray objectAtIndex:indexPath.row]valueForKey:kLocationName];
    }
    
    // code for cell selection
    
    if ([selsctedArray containsObject:[filterArray objectAtIndex:indexPath.row]]) {
        cell.checkMarkImage.image = [UIImage imageNamed:@"check"];
    }
    else{
        cell.checkMarkImage.image = [UIImage imageNamed:@"uncheck"];
    }
    cell.checkMarkImage.hidden = YES;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.delegate respondsToSelector:@selector(selectData:type:)]) {
        
        NSMutableDictionary *selectedDictionary = [filterArray objectAtIndex:indexPath.row];
        
            [self.delegate selectData:selectedDictionary type:self.userType];
        }
        [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}


#pragma mark - search bar clicked

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self filterContentForSearchText:searchText];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
   
    filterArray = [NSMutableArray arrayWithArray:_userArray];
    [_userSelectionTable reloadData];
    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchbar{
    
    [searchBar resignFirstResponder];
    [self filterContentForSearchText:searchBar.text];
    
}
- (void)filterContentForSearchText:(NSString*)searchText{
    if (searchText.length > 0) {
        
        NSPredicate *predicate;
        if ([self.userType isEqualToString:kOtherCity]) {
        predicate = [NSPredicate predicateWithFormat:@"cityName CONTAINS[cd] %@",searchBar.text];
        }
        else{
          predicate = [NSPredicate predicateWithFormat:@"LocationName CONTAINS[cd] %@",searchBar.text];
        }
   
        
    filterArray = [[_userArray filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    else{
        filterArray = [NSMutableArray arrayWithArray:_userArray];
    }
    [_userSelectionTable reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)backButton_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

//- (IBAction)doneButton_clicked:(id)sender {
//    
//    if ([self.delegate respondsToSelector:@selector(selectData:type:)]) {
//        [self.delegate selectData:selsctedArray type:self.userType];
//
//    }
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}


@end
