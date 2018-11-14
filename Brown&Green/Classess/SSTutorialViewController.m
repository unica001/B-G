//
//  SSTutorialViewController.m
//  SmartSchool
//
//  Created by vineet patidar on 05/07/17.
//  Copyright © 2017 Sirez. All rights reserved.
//

#import "SSTutorialViewController.h"

@interface SSTutorialViewController ()
@end

@implementation SSTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    // code for check incoming view type
//    if ([self.incomingViewType isEqualToString:kguestLoginTutorial]) {
//        self.imageView.image = [UIImage imageNamed:@"guestLogin"];
//    }
//   else if ([self.incomingViewType isEqualToString:khomeTutorial]) {
//        self.imageView.image = [UIImage imageNamed:@"homeTutorial"];
//       
//    }
//    else if ([self.incomingViewType isEqualToString:kscheduleTutorial]) {
//        self.imageView.image = [UIImage imageNamed:@"scheduleTutorial"];
//    }
//    else if ([self.incomingViewType isEqualToString:kMyOrderTutorial]) {
//        self.imageView.image = [UIImage imageNamed:@"myOrderTutorial"];
//
//
//    }
//    else if ([self.incomingViewType isEqualToString:kkramTutorial]) {
//        self.imageView.image = [UIImage imageNamed:@"krmaTutorial"];
//
//    }
    
    NSMutableDictionary *tutorialDictionary;

    if (![[kUserDefault valueForKey:kTutorial] isKindOfClass:[NSNull class]]) {
        tutorialDictionary =  [NSMutableDictionary dictionaryWithDictionary:[kUserDefault valueForKey:kTutorial]];
    }
    else{
        tutorialDictionary = [[NSMutableDictionary alloc]init];
    }
    
    // code for check incoming view type
    if ([self.incomingViewType isEqualToString:kguestLoginTutorial]) {
        self.imageView.image = [UIImage imageNamed:@"guestLogin"];
        [tutorialDictionary setValue:@"NO" forKey:kguestLoginTutorial];
    }
    else if ([self.incomingViewType isEqualToString:khomeTutorial]) {
        self.imageView.image = [UIImage imageNamed:@"homeTutorial"];
        [tutorialDictionary setValue:@"NO" forKey:khomeTutorial];
        
    }
    else if ([self.incomingViewType isEqualToString:kscheduleTutorial]) {
        self.imageView.image = [UIImage imageNamed:@"scheduleTutorial"];
        [tutorialDictionary setValue:@"NO" forKey:kscheduleTutorial];
    }
    else if ([self.incomingViewType isEqualToString:kMyOrderTutorial]) {
        self.imageView.image = [UIImage imageNamed:@"myOrderTutorial"];
        [tutorialDictionary setValue:@"NO" forKey:kMyOrderTutorial];
        
        
    }
    else if ([self.incomingViewType isEqualToString:kkramTutorial]) {
        self.imageView.image = [UIImage imageNamed:@"krmaTutorial"];
        [tutorialDictionary setValue:@"NO" forKey:kkramTutorial];
        
    }
    [kUserDefault setValue:tutorialDictionary forKey:kTutorial];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma  mark - event Action

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
        [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
