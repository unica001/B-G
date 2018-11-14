//
//  OfferViewController.m
//  Brown&Green
//
//  Created by vineet patidar on 01/05/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "OfferViewController.h"

@interface OfferViewController ()

@end

@implementation OfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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

-(void)getOfferList{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    offerServer *noti = [[offerServer alloc] initWithDict:dict];
    noti.requestDelegate=self;
    [noti startAsynchronous];
}

#pragma mark APIs Responce
// offers

-(void)offerServerFinishedWithSuccessMessage:(NSMutableDictionary *)inData{
    [Utility hideMBHUDLoader];
    [UtilityPlist saveData:inData fileName:kOffer];

    self.offerArr = [inData valueForKey:@"Payload"];
    [_offerTable reloadData];
}

-(void)offerServerFailedWithErrorMessage:(NSString *)inFailedData{
    [Utility hideMBHUDLoader];
}

#pragma mark - Table view delegate methods



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.offerArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString *cellIdentifier3  =@"cell";
        
        OfferCell *cell = [_offerTable dequeueReusableCellWithIdentifier:cellIdentifier3];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"OfferCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        [cell setData:[_offerArr objectAtIndex:indexPath.row] type:@"Offer"];
  
        return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.delegate respondsToSelector:@selector(getPromocode:)]) {
        
        NSMutableDictionary *selectedDictionary = [self.offerArr objectAtIndex:indexPath.row];
        [self.delegate getPromocode:selectedDictionary];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButton_clicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
