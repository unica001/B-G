//
//  SwipeVC.m
//  Video
//
//  Created by Anand on 01/05/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import "SwipeVC.h"
#import "VC1.h"
#import "VC3.h"
#import "VC4.h"
#import "VC2.h"
#import "ScrollVC.h"

//#import "YSLContainerViewController.h"


@interface SwipeVC ()<SLContainerViewControllerDelegate>

@end

@implementation SwipeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        UIBarButtonItem *revealButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:revealViewController action:@selector(revealToggle:)];
        self.navigationItem.leftBarButtonItem = revealButton;
    }

    NSLog(@"%@", [kUserDefault valueForKey:kTutorial]);

if (![[Utility replaceNULL:[[kUserDefault valueForKey:kTutorial] valueForKey:kMyOrderTutorial] value:@""] isEqualToString:@"NO"]) {         //  add tutorial
        SSTutorialViewController *tutorialView = [[SSTutorialViewController alloc]initWithNibName:@"SSTutorialViewController" bundle:[NSBundle mainBundle]];
        tutorialView.incomingViewType = kMyOrderTutorial;
        [self presentViewController:tutorialView animated:YES completion:nil];
    }

    self.navigationController.navigationBarHidden = NO;
    _contentView.frame = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    self.title = @"My Order";
    
    // SetUp ViewControllers
    UIStoryboard *storyboard1 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* theController1 = [storyboard1 instantiateViewControllerWithIdentifier:@"VC1"];
    theController1.title = @"Upcoming Order";
    
    UIStoryboard *storyboard2 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* theController2 = [storyboard2 instantiateViewControllerWithIdentifier:@"VC2"];
    theController2.title = @"Delivered Order";
    
    UIStoryboard *storyboard3 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* theController3 = [storyboard3 instantiateViewControllerWithIdentifier:@"VC3"];
    theController3.title = @"Cancelled Order";
    
    UIStoryboard *storyboard4 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* theController4 = [storyboard4 instantiateViewControllerWithIdentifier:@"VC4"];
    theController4.title = @"Order Summary";
    // ContainerView
    float statusHeight = 0;
    float navigationHeight = 0;
    
    ScrollVC *containerVC = [[ScrollVC alloc]initWithControllers:@[theController1,theController2,theController3]
                                                                                        topBarHeight:statusHeight + navigationHeight
                                                                                parentViewController:self];
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:@"Helvetica Neue" size:14];
    containerVC.menuItemTitleColor = [UIColor lightGrayColor];
    containerVC.menuItemSelectedTitleColor = kDefaultLightGreen;
    containerVC.view.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    containerVC.contentScrollView.scrollEnabled = NO;
    [self.contentView addSubview:containerVC.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    //    NSLog(@"current Index : %ld",(long)index);
    //    NSLog(@"current controller : %@",controller);
    [controller viewWillAppear:YES];
}


- (IBAction)btn_Back_Clicked:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
