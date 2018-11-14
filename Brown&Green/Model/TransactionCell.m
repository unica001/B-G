//
//  TransactionCell.m
//  Brown&Green
//
//  Created by vineet patidar on 27/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "TransactionCell.h"

@implementation TransactionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSMutableDictionary *)dictionary{

    NSString *dateString=   [dictionary valueForKey:@"TransactionDate"];
    NSString *newStr = [dateString substringToIndex:19];
    dateString=newStr;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [format dateFromString:dateString];
    [format setFormatterBehavior:NSDateFormatterBehavior10_4];
    [format setDateFormat:@"EEEE"];
    NSString *weekDay =  [format stringFromDate:date];
    format.dateFormat=@"MMM";
    NSString * month = [[format stringFromDate:date] capitalizedString];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSString *finalDate = [NSString stringWithFormat:@"%@, %li %@",weekDay,(long)[components day] ,month];
    self.dateLabel.text=finalDate;
    
    self.subTitle.text = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"TransactonType"]];
     self.price.text = [NSString stringWithFormat:@"%@ AUD",[dictionary valueForKey:@"Amount"]];
}

@end
