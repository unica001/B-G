//
//  MyinfoView.m
//  MenuDemo
//
//  Created by raghvendra rajwat on 1/5/15.
//  Copyright (c) 2015 raghvendra Rajawat. All rights reserved.
//

#import "MyinfoView.h"
#import "AppDelegate.h"
#import "BGRevealMenuViewController.h"

@implementation MyinfoView
@synthesize isShown;
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        originalFrame = frame;
//        
//        self.alpha = 0;
//        self.backgroundColor = [UIColor colorWithRed:192/255.0f green:18/255.0f blue:22/255.0f alpha:1.0f];
//        self.layer.cornerRadius = 8.0f;
//        self.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
//        self.layer.masksToBounds = NO;
//        self.layer.shadowOpacity = 0.8;
//        self.layer.shadowRadius = 8.0f;
//        UIImageView *tempImageView=[[UIImageView alloc]initWithFrame:CGRectMake(40,50,200,150)];
//        tempImageView.image=[UIImage imageNamed:@"2.png"];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, frame.size.width, 20)];
//        label.text = @"Hello Raghu!";
//        label.textAlignment = UITextAlignmentCenter;
//        label.backgroundColor = [UIColor clearColor];
//        label.textColor=[UIColor whiteColor];
//        UILabel *labelname = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, frame.size.width, 20)];
//        labelname.text = @"Name : Raghvendra Singh";
//        // labelname.textAlignment = UITextAlignmentCenter;
//        labelname.backgroundColor = [UIColor clearColor];
//        labelname.textColor=[UIColor whiteColor];
//        UILabel *labelemail = [[UILabel alloc] initWithFrame:CGRectMake(10, 230, frame.size.width, 20)];
//        labelemail.text = @"Email  : Raghvendra.rajwat@eigital.com";
//        //labelemail.textAlignment = UITextAlignmentCenter;
//        labelemail.backgroundColor = [UIColor clearColor];
//        labelemail.textColor=[UIColor whiteColor];
//        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        closeButton.frame = CGRectMake(10, frame.size.height - 45, frame.size.width - 20, 35);
//        [closeButton setTitle:@"Close" forState:UIControlStateNormal];
//        [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
//        //closeButton.layer.cornerRadius=10;
//        closeButton.backgroundColor=[UIColor brownColor];
//        closeButton.alpha=1;
//        [closeButton setTintColor:[UIColor whiteColor]];
//        UIView *lineview=[[UIView alloc] initWithFrame:CGRectMake(0, 40, frame.size.width, 1)];
//        lineview.backgroundColor=[UIColor whiteColor];
//        
//        [self addSubview:tempImageView];
//        //[self addSubview:textV];
//        [self addSubview:label];
//        [self addSubview:labelname];
//        [self addSubview:labelemail];
//        [self addSubview:closeButton];
//        [self addSubview:lineview];
//        
//    }
//    return self;
//}
-(void) showCurrentAutoshipCancelAlertWithTitle:(NSString *)title andMessage:(NSAttributedString *)msg withFram:(CGRect)frame{
    originalFrame = frame;
    self.alpha = 0;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    self.layer.masksToBounds = NO;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 8.0f;

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
    headerView.backgroundColor=[UIColor colorWithRed:250/255.0 green:38/255.0 blue:0/255.0 alpha:1.0];

    UILabel *backImageLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    backImageLabel.backgroundColor=[UIColor whiteColor];
    [headerView addSubview:backImageLabel];
    UIImageView *tempImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,5,29,29)];
    tempImageView.backgroundColor=[UIColor whiteColor];
    tempImageView.image=[UIImage imageNamed:@"Logo(PopUp)"];
    [headerView addSubview:tempImageView];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, frame.size.width, 20)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    // label.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];


    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(0, 50, frame.size.width, 110)];
    txtView.font= [UIFont fontWithName:@"HelveticaNeue" size:15];
    txtView.attributedText=msg;
    txtView.userInteractionEnabled=NO;
    [self addSubview:txtView];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeButton.frame = CGRectMake(10, frame.size.height-20, frame.size.width - 20, 35);
    [closeButton setTitle:@"Done" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    closeButton.alpha=1;
    //closeButton.backgroundColor=[UIColor orangeColor];
    UIView *lineview=[[UIView alloc] initWithFrame:CGRectMake(0, 120, frame.size.width, 1)];
    lineview.backgroundColor=[UIColor lightGrayColor];


    [self addSubview:headerView];
    [self addSubview:label];
    [self addSubview:closeButton];
    [self addSubview:lineview];
    
    
    
}
-(void) showOneTimeCancelAlertWithTitle:(NSString *)title andMessage:(NSAttributedString *)msg withFram:(CGRect)frame{
    originalFrame = frame;
    self.alpha = 0;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    self.layer.masksToBounds = NO;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 8.0f;

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
    headerView.backgroundColor=[UIColor colorWithRed:250/255.0 green:38/255.0 blue:0/255.0 alpha:1.0];
    UILabel *backImageLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    backImageLabel.backgroundColor=[UIColor whiteColor];
    [headerView addSubview:backImageLabel];

    UIImageView *tempImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,5,29,29)];
    tempImageView.backgroundColor=[UIColor whiteColor];

    tempImageView.image=[UIImage imageNamed:@"Logo(PopUp)"];
    [headerView addSubview:tempImageView];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, frame.size.width, 20)];
    label.text = title;
   // label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor whiteColor];
     label.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];


    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(0, 40, frame.size.width, 100)];
    txtView.font= [UIFont fontWithName:@"HelveticaNeue" size:15];
    txtView.attributedText=msg;
    //txtView.backgroundColor=[UIColor grayColor];
    txtView.userInteractionEnabled=NO;
    [self addSubview:txtView];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeButton.frame = CGRectMake(10, frame.size.height-45, frame.size.width - 20, 35);
    [closeButton setTitle:@"Ok" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    closeButton.alpha=1;
   // closeButton.backgroundColor=[UIColor orangeColor];
    UIView *lineview=[[UIView alloc] initWithFrame:CGRectMake(0, 130, frame.size.width, 1)];
    lineview.backgroundColor=[UIColor lightGrayColor];


    [self addSubview:headerView];
    [self addSubview:label];
    [self addSubview:closeButton];
    [self addSubview:lineview];

}

-(void) showCancelAlertWithTitle:(NSString *)title andMessage:(NSString *)msg withFram:(CGRect)frame{
    originalFrame = frame;
    self.alpha = 0;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    self.layer.masksToBounds = NO;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 8.0f;

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
   headerView.backgroundColor=[UIColor colorWithRed:250/255.0 green:38/255.0 blue:0/255.0 alpha:1.0];
    UILabel *backImageLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    backImageLabel.backgroundColor=[UIColor whiteColor];
    [headerView addSubview:backImageLabel];

    UIImageView *tempImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,5,29,29)];
    tempImageView.backgroundColor=[UIColor whiteColor];

    tempImageView.image=[UIImage imageNamed:@"Logo(PopUp)"];
    [headerView addSubview:tempImageView];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, frame.size.width, 20)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    // label.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];


    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(0, 50, frame.size.width, 100)];
    txtView.font= [UIFont fontWithName:@"HelveticaNeue" size:15];
    txtView.text=msg;
    txtView.userInteractionEnabled=NO;
    [self addSubview:txtView];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeButton.frame = CGRectMake(10, frame.size.height-45, frame.size.width - 20, 35);
    [closeButton setTitle:@"Done" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    closeButton.alpha=1;
    //closeButton.backgroundColor=[UIColor orangeColor];
    UIView *lineview=[[UIView alloc] initWithFrame:CGRectMake(0, 110, frame.size.width, 1)];
    lineview.backgroundColor=[UIColor lightGrayColor];


    [self addSubview:headerView];
    [self addSubview:label];
    [self addSubview:closeButton];
    [self addSubview:lineview];
    
    

}
-(void) showProfileAlertWithTitle:(NSString *)title andMessage:(NSString *)msg withFram:(CGRect)frame{
    originalFrame = frame;
    self.alpha = 0;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    self.layer.masksToBounds = NO;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 8.0f;

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
   headerView.backgroundColor=[UIColor colorWithRed:250/255.0 green:38/255.0 blue:0/255.0 alpha:1.0];
    UILabel *backImageLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    backImageLabel.backgroundColor=[UIColor whiteColor];
    [headerView addSubview:backImageLabel];

    UIImageView *tempImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,5,29,29)];
    tempImageView.backgroundColor=[UIColor whiteColor];

    tempImageView.image=[UIImage imageNamed:@"Logo(PopUp)"];
    [headerView addSubview:tempImageView];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, frame.size.width, 20)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor whiteColor];
     label.font=[UIFont fontWithName:@"Helvetica-Bold" size:15];


    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(0, 50, frame.size.width, 140)];
    txtView.font= [UIFont fontWithName:@"HelveticaNeue" size:15];
    txtView.text=msg;
    txtView.userInteractionEnabled=NO;
    [self addSubview:txtView];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeButton.frame = CGRectMake(150, frame.size.height-45, 120, 35);
    closeButton.backgroundColor=[UIColor colorWithRed:245/255.0 green:130/255.0 blue:32/255.0 alpha:1.0];
    [closeButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    closeButton.alpha=1;

    UIButton *continueBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    continueBtn.frame = CGRectMake(10, frame.size.height-45, 120, 35);
    continueBtn.backgroundColor=[UIColor colorWithRed:245/255.0 green:130/255.0 blue:32/255.0 alpha:1.0];
    [continueBtn setTitle:@"Continue" forState:UIControlStateNormal];
    [continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [continueBtn addTarget:self action:@selector(continueClicked) forControlEvents:UIControlEventTouchUpInside];
    continueBtn.alpha=1;


    UIView *lineview=[[UIView alloc] initWithFrame:CGRectMake(0, 125, frame.size.width, 1)];
    lineview.backgroundColor=[UIColor lightGrayColor];


    [self addSubview:headerView];
    [self addSubview:label];
    [self addSubview:closeButton];
    [self addSubview:continueBtn];
    [self addSubview:lineview];
    
    
    
}

-(void) showRegAlertWithTitle:(NSString *)title andMessage:(NSString *)msg withFram:(CGRect)frame{
    originalFrame = frame;
    self.alpha = 0;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    self.layer.masksToBounds = NO;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 8.0f;

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
    headerView.backgroundColor=[UIColor colorWithRed:250/255.0 green:38/255.0 blue:0/255.0 alpha:1.0];
    UILabel *backImageLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    backImageLabel.backgroundColor=[UIColor whiteColor];
    [headerView addSubview:backImageLabel];

    UIImageView *tempImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,5,29,29)];
    tempImageView.backgroundColor=[UIColor whiteColor];

    tempImageView.image=[UIImage imageNamed:@"Logo(PopUp)"];
    [headerView addSubview:tempImageView];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 20)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];


    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(0, 50, frame.size.width, 140)];
    txtView.font= [UIFont fontWithName:@"HelveticaNeue" size:15];
    txtView.text=msg;
    txtView.userInteractionEnabled=NO;
    [self addSubview:txtView];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeButton.frame = CGRectMake(150, frame.size.height-45, 120, 35);
    closeButton.backgroundColor=[UIColor colorWithRed:245/255.0 green:130/255.0 blue:32/255.0 alpha:1.0];
    [closeButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    closeButton.alpha=1;

    UIButton *continueBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    continueBtn.frame = CGRectMake(10, frame.size.height-45, 120, 35);
    continueBtn.backgroundColor=[UIColor colorWithRed:245/255.0 green:130/255.0 blue:32/255.0 alpha:1.0];
    [continueBtn setTitle:@"Confirmed" forState:UIControlStateNormal];
    [continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [continueBtn addTarget:self action:@selector(confirmClicked) forControlEvents:UIControlEventTouchUpInside];
    continueBtn.alpha=1;


    UIView *lineview=[[UIView alloc] initWithFrame:CGRectMake(0, 125, frame.size.width, 1)];
    lineview.backgroundColor=[UIColor lightGrayColor];


    [self addSubview:headerView];
    [self addSubview:label];
    [self addSubview:closeButton];
    [self addSubview:continueBtn];
    [self addSubview:lineview];
    
    
    
}

-(void) showRegLocAlertWithTitle:(NSString *)title andMessage:(NSString *)msg withFram:(CGRect)frame{
    originalFrame = frame;
    self.alpha = 0;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    self.layer.masksToBounds = NO;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 8.0f;

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
    headerView.backgroundColor=[UIColor colorWithRed:250/255.0 green:38/255.0 blue:0/255.0 alpha:1.0];
    UILabel *backImageLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    backImageLabel.backgroundColor=[UIColor whiteColor];
    [headerView addSubview:backImageLabel];

    UIImageView *tempImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,5,29,29)];
    tempImageView.backgroundColor=[UIColor whiteColor];

    tempImageView.image=[UIImage imageNamed:@"Logo(PopUp)"];
    [headerView addSubview:tempImageView];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 20)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];


    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(0, 50, frame.size.width, 140)];
    txtView.font= [UIFont fontWithName:@"HelveticaNeue" size:15];
    txtView.text=msg;
    txtView.userInteractionEnabled=NO;
    [self addSubview:txtView];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeButton.frame = CGRectMake(150, frame.size.height-45, 120, 35);
    closeButton.backgroundColor=[UIColor colorWithRed:245/255.0 green:130/255.0 blue:32/255.0 alpha:1.0];
    [closeButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    closeButton.alpha=1;

    UIButton *continueBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    continueBtn.frame = CGRectMake(10, frame.size.height-45, 120, 35);
    continueBtn.backgroundColor=[UIColor colorWithRed:245/255.0 green:130/255.0 blue:32/255.0 alpha:1.0];
    [continueBtn setTitle:@"Confirmed" forState:UIControlStateNormal];
    [continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [continueBtn addTarget:self action:@selector(confirmClickedLoc) forControlEvents:UIControlEventTouchUpInside];
    continueBtn.alpha=1;


    UIView *lineview=[[UIView alloc] initWithFrame:CGRectMake(0, 125, frame.size.width, 1)];
    lineview.backgroundColor=[UIColor lightGrayColor];


    [self addSubview:headerView];
    [self addSubview:label];
    [self addSubview:closeButton];
    [self addSubview:continueBtn];
    [self addSubview:lineview];
    
    
    
}


-(void) showAutoShipAlertWithTitle:(NSString *)title andMessage:(NSString *)msg withFram:(CGRect)frame{
    originalFrame = frame;
    self.alpha = 0;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    self.layer.masksToBounds = NO;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 8.0f;

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
   headerView.backgroundColor=[UIColor colorWithRed:245/255.0 green:130/255.0 blue:32/255.0 alpha:1.0];
    UILabel *backImageLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    backImageLabel.backgroundColor=[UIColor whiteColor];
    [headerView addSubview:backImageLabel];

    UIImageView *tempImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,5,29,29)];
    tempImageView.backgroundColor=[UIColor whiteColor];

    tempImageView.image=[UIImage imageNamed:@"Logo(PopUp)"];
    [headerView addSubview:tempImageView];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, frame.size.width, 20)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor whiteColor];
   // label.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];


    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(0, 50, frame.size.width, 100)];
    txtView.font= [UIFont fontWithName:@"HelveticaNeue" size:15];
    txtView.text=msg;
    txtView.userInteractionEnabled=NO;
    [self addSubview:txtView];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeButton.frame = CGRectMake(10, frame.size.height-45, frame.size.width - 20, 35);
    [closeButton setTitle:@"Done" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    closeButton.alpha=1;
    //closeButton.backgroundColor=[UIColor orangeColor];
    UIView *lineview=[[UIView alloc] initWithFrame:CGRectMake(0, 110, frame.size.width, 1)];
    lineview.backgroundColor=[UIColor lightGrayColor];


    [self addSubview:headerView];
    [self addSubview:label];
    [self addSubview:closeButton];
    [self addSubview:lineview];
    

}

-(void) showAppAlertWithTitle:(NSString *)title andMessage:(NSString *)msg withFram:(CGRect)frame{
    originalFrame = frame;
    self.alpha = 0;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    self.layer.masksToBounds = NO;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 8.0f;

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
    headerView.backgroundColor=[UIColor colorWithRed:250/255.0 green:38/255.0 blue:0/255.0 alpha:1.0];
    UILabel *backImageLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    backImageLabel.backgroundColor=[UIColor whiteColor];
    [headerView addSubview:backImageLabel];

    UIImageView *tempImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,5,29,29)];
    tempImageView.backgroundColor=[UIColor whiteColor];

    tempImageView.image=[UIImage imageNamed:@"Logo(PopUp)"];
    [headerView addSubview:tempImageView];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 20)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];


    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(0, 40, frame.size.width, 100)];
    txtView.font= [UIFont fontWithName:@"HelveticaNeue" size:15];
    txtView.text=msg;
    txtView.userInteractionEnabled=NO;
    [self addSubview:txtView];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeButton.frame = CGRectMake(10, frame.size.height-48, frame.size.width - 20, 35);
    [closeButton setTitle:@"Update" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(updateClicked) forControlEvents:UIControlEventTouchUpInside];
    closeButton.alpha=1;
    closeButton.backgroundColor=[UIColor colorWithRed:245/255.0 green:130/255.0 blue:32/255.0 alpha:1.0];
    UIView *lineview=[[UIView alloc] initWithFrame:CGRectMake(0, 135, frame.size.width, 1)];
    lineview.backgroundColor=[UIColor lightGrayColor];


    [self addSubview:headerView];
    [self addSubview:label];
    [self addSubview:closeButton];
    [self addSubview:lineview];
    
    
}

-(void) showConfirmAmountWithTitle:(NSString *)title andMessage:(NSString *)msg withFram:(CGRect)frame{
    originalFrame = frame;
    self.alpha = 0;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    self.layer.masksToBounds = NO;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 8.0f;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
    headerView.backgroundColor=[UIColor colorWithRed:28/255.0 green:121/255.0 blue:173/255.0 alpha:1.0];
    UILabel *backImageLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    backImageLabel.backgroundColor=[UIColor whiteColor];
    [headerView addSubview:backImageLabel];

    UIImageView *tempImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,5,29,29)];
    tempImageView.backgroundColor=[UIColor whiteColor];

    tempImageView.image=[UIImage imageNamed:@"Logo(PopUp)"];
    [headerView addSubview:tempImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-20, 10, frame.size.width, 20)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
    
    UILabel *rs = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, 20, 20)];
    rs.text = @"₹";
    rs.textAlignment = NSTextAlignmentCenter;
    rs.backgroundColor = [UIColor clearColor];
    rs.textColor=[UIColor blackColor];
    rs.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
    [self addSubview:rs];
    
    confirmPaymentTxtField = [[UITextField alloc] initWithFrame:CGRectMake(35, 50, 170, 30)];
    
    confirmPaymentTxtField.keyboardType = UIKeyboardTypeNumberPad;

    confirmPaymentTxtField.delegate=self;
    
    confirmPaymentTxtField.font= [UIFont fontWithName:@"HelveticaNeue" size:16];
    //    txtField.delegate=self;
    //    [txtField becomeFirstResponder];
    confirmPaymentTxtField.backgroundColor=[UIColor clearColor];
    confirmPaymentTxtField.text=msg;

    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    confirmPaymentTxtField.inputAccessoryView = numberToolbar;
    confirmPaymentTxtField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.amount=msg;
    [self addSubview:confirmPaymentTxtField];
    
    UIView *lineviewTxt=[[UIView alloc] initWithFrame:CGRectMake(35, 80, 220, 1)];
    lineviewTxt.backgroundColor=[UIColor colorWithRed:28/255.0 green:121/255.0 blue:173/255.0 alpha:1.0];
    

    UIButton *continueBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   continueBtn.frame = CGRectMake(0, frame.size.height-50, 280, 50);
    continueBtn.backgroundColor=[UIColor colorWithRed:245/255.0 green:130/255.0 blue:32/255.0 alpha:1.0];
    [continueBtn setTitle:@"Make Payment" forState:UIControlStateNormal];
    [continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    continueBtn.titleLabel.text=confirmPaymentTxtField.text;
    continueBtn.titleLabel.hidden=YES;
    [continueBtn addTarget:self action:@selector(makeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    continueBtn.alpha=1;
    
    UIView *lineview=[[UIView alloc] initWithFrame:CGRectMake(0, 120, frame.size.width, 1)];
    lineview.backgroundColor=[UIColor lightGrayColor];
    
    [self addSubview:continueBtn];
    [self addSubview:headerView];
    [self addSubview:label];
   [self addSubview:lineview];
    [self addSubview:lineviewTxt];
    
}
#pragma mark numberToolbar Bar button Methods
-(void)cancelNumberPad
{
    [self.cDelegate confirmPaymentNumberToolbarCancelClicked];
    [confirmPaymentTxtField resignFirstResponder];
//    confirmPaymentTxtField.text = @"";
}

-(void)doneWithNumberPad
{
    [self.cDelegate confirmPaymentNumberToolbarDoneClicked];

    [confirmPaymentTxtField resignFirstResponder];
}

-(void) showMinAlertWithTitle:(NSString *)title andMessage:(NSString *)msg withFram:(CGRect)frame{
    originalFrame = frame;
    
    UIView* viewWithShadow=[[UIView alloc]initWithFrame:frame];
    
    self.alpha = 0;
    self.backgroundColor = [UIColor whiteColor];
       self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 8.0f;

    viewWithShadow.backgroundColor = [UIColor whiteColor];
    viewWithShadow.layer.cornerRadius = 8.0f;
    viewWithShadow.layer.masksToBounds = YES;

    [self addSubview:viewWithShadow];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
    headerView.backgroundColor=[UIColor colorWithRed:250/255.0 green:38/255.0 blue:0/255.0 alpha:1.0];
    UILabel *backImageLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    backImageLabel.backgroundColor=[UIColor whiteColor];
    [headerView addSubview:backImageLabel];

    UIImageView *tempImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,5,29,29)];
    tempImageView.backgroundColor=[UIColor whiteColor];

    tempImageView.image=[UIImage imageNamed:@"Logo(PopUp)"];
    [headerView addSubview:tempImageView];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, frame.size.width, 20)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];


    UIWebView *txtView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 30, frame.size.width, 120)];
//    txtView.font= [UIFont fontWithName:@"HelveticaNeue" size:15];
    [txtView loadHTMLString:msg baseURL:nil];
    txtView.userInteractionEnabled=NO;
    [viewWithShadow addSubview:txtView];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeButton.frame = CGRectMake(0, frame.size.height-39, frame.size.width/2, 39);
    closeButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    closeButton.titleLabel.textAlignment = NSTextAlignmentCenter; // if you want to
    [closeButton setTitle:@"Continue\nShopping" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    closeButton.alpha=1;
    closeButton.backgroundColor= [UIColor colorWithRed:255/255.0f green:95/255.0f blue:32/255.0f alpha:1.0f];
    [closeButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
//    closeButton.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];

    
    UIButton *proceedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    proceedButton.frame = CGRectMake(frame.size.width/2+1, frame.size.height-39, frame.size.width/2, 39);
    proceedButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    // you probably want to center it
    proceedButton.titleLabel.textAlignment = NSTextAlignmentCenter; // if you want to

    [proceedButton setTitle:@"Proceed with\nDelivery Charges" forState:UIControlStateNormal];
    [proceedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [proceedButton addTarget:self action:@selector(proceed) forControlEvents:UIControlEventTouchUpInside];
    proceedButton.alpha=1;
    proceedButton.backgroundColor=[UIColor colorWithRed:255/255.0f green:95/255.0f blue:32/255.0f alpha:1.0f] ;
    [proceedButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];

    //closeButton.backgroundColor=[UIColor orangeColor];
    UIView *lineview=[[UIView alloc] initWithFrame:CGRectMake(0, 140, frame.size.width, 1)];
    lineview.backgroundColor=[UIColor lightGrayColor];

    UIView *midLineview=[[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2+1, frame.size.height-39, 1, 39)];
    midLineview.backgroundColor=[UIColor lightGrayColor];

    [viewWithShadow addSubview:headerView];
    [viewWithShadow addSubview:label];
    [viewWithShadow addSubview:closeButton];
    [viewWithShadow addSubview:lineview];
    [viewWithShadow addSubview:proceedButton];
    [viewWithShadow addSubview:midLineview];

//    [self addSubview:viewWithShadow];


}

-(void) showMinAlert2WithTitle:(NSString *)title andMessage:(NSString *)msg withFram:(CGRect)frame{
    originalFrame = frame;
    
    UIView* viewWithShadow=[[UIView alloc]initWithFrame:frame];
    
    self.alpha = 0;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 8.0f;
    
    viewWithShadow.backgroundColor = [UIColor whiteColor];
    viewWithShadow.layer.cornerRadius = 8.0f;
    viewWithShadow.layer.masksToBounds = YES;
    
    [self addSubview:viewWithShadow];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
    headerView.backgroundColor=[UIColor colorWithRed:250/255.0 green:38/255.0 blue:0/255.0 alpha:1.0];
    UILabel *backImageLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    backImageLabel.backgroundColor=[UIColor whiteColor];
    [headerView addSubview:backImageLabel];

    UIImageView *tempImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,5,29,29)];
    tempImageView.backgroundColor=[UIColor whiteColor];

    tempImageView.image=[UIImage imageNamed:@"Logo(PopUp)"];
    [headerView addSubview:tempImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, frame.size.width, 20)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
    
    
    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(0, 50, frame.size.width, 120)];
    //    txtView.font= [UIFont fontWithName:@"HelveticaNeue" size:15];
    [txtView setText:msg];
    txtView.userInteractionEnabled=NO;
    [viewWithShadow addSubview:txtView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeButton.frame = CGRectMake(0, frame.size.height-49, frame.size.width, 39);
    [closeButton setTitle:@"Done" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    closeButton.alpha=1;
    //    closeButton.backgroundColor=[UIColor colorWithRed:255/255.0f green:102/255.0f blue:0 alpha:1.0];
    [closeButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    //    closeButton.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
    
    
    
    //closeButton.backgroundColor=[UIColor orangeColor];
    UIView *lineview=[[UIView alloc] initWithFrame:CGRectMake(0, 140, frame.size.width, 1)];
    lineview.backgroundColor=[UIColor lightGrayColor];
    
    
    [viewWithShadow addSubview:headerView];
    [viewWithShadow addSubview:label];
    [viewWithShadow addSubview:closeButton];
    [viewWithShadow addSubview:lineview];
    
    //    [self addSubview:viewWithShadow];
    
    
}
-(void) showAlertWithTitle :(NSString*)title andMessage :(NSAttributedString*)msg withFram:(CGRect)frame {

     originalFrame = frame;
    self.alpha = 0;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    self.layer.masksToBounds = NO;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 8.0f;

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
    headerView.backgroundColor=[UIColor colorWithRed:245/255.0 green:130/255.0 blue:32/255.0 alpha:1.0];
    UILabel *backImageLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    backImageLabel.backgroundColor=[UIColor whiteColor];
    [headerView addSubview:backImageLabel];

    UIImageView *tempImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,5,29,29)];
    tempImageView.backgroundColor=[UIColor whiteColor];

    tempImageView.image=[UIImage imageNamed:@"Logo(PopUp)"];
    [headerView addSubview:tempImageView];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, frame.size.width, 20)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor whiteColor];



    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(0, 35, frame.size.width, 150)];
    txtView.font= [UIFont fontWithName:@"HelveticaNeue" size:15];
    txtView.attributedText=msg;
    txtView.userInteractionEnabled=NO;
    txtView.textAlignment=NSTextAlignmentCenter;
    [self addSubview:txtView];

    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 57,100, 20)];
    priceLabel.textColor=[UIColor colorWithRed:72/255.0 green:144/255.0 blue:48/255.0 alpha:1.0];
     priceLabel.font= [UIFont fontWithName:@"HelveticaNeue" size:15];
    priceLabel.text=self.price;
    //[self addSubview:priceLabel];

    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 67,160, 20)];
    dateLabel.textColor=[UIColor colorWithRed:72/255.0 green:144/255.0 blue:48/255.0 alpha:1.0];
    dateLabel.font= [UIFont fontWithName:@"HelveticaNeue" size:15];
    dateLabel.text=self.date;
   // [self addSubview:dateLabel];



    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeButton.frame = CGRectMake(10, frame.size.height-45, frame.size.width - 20, 35);
    [closeButton setTitle:@"Done" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    closeButton.alpha=1;
    //closeButton.backgroundColor=[UIColor orangeColor];
    UIView *lineview=[[UIView alloc] initWithFrame:CGRectMake(0, 190, frame.size.width, 1)];
    lineview.backgroundColor=[UIColor lightGrayColor];
    if (frame.size.height==200) {
//        closeButton.frame= CGRectMake(10, frame.size.height-45-40, frame.size.width - 20, 35);
        lineview.frame=CGRectMake(0, 150, frame.size.width, 1);

    }

    [self addSubview:headerView];
    [self addSubview:label];
    [self addSubview:closeButton];
    [self addSubview:lineview];


}
-(void) showPaymentAlertWithTitle :(NSString*)title andMessage :(NSAttributedString*)msg withFram:(CGRect)frame {
    
    originalFrame = frame;
    self.alpha = 0;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    self.layer.masksToBounds = NO;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 8.0f;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
    headerView.backgroundColor=[UIColor colorWithRed:28/255.0 green:121/255.0 blue:173/255.0 alpha:1.0];
    UILabel *backImageLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    backImageLabel.backgroundColor=[UIColor whiteColor];
    [headerView addSubview:backImageLabel];

    UIImageView *tempImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,5,29,29)];
    tempImageView.image=[UIImage imageNamed:@"Logo(PopUp)"];
    [headerView addSubview:tempImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, frame.size.width, 20)];
    label.text = title;
    label.font= [UIFont fontWithName:@"HelveticaNeue" size:17];
   // label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    
    
    
    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(0, 50, frame.size.width, 150)];
    txtView.font= [UIFont fontWithName:@"HelveticaNeue" size:15];
    txtView.attributedText=msg;
    txtView.userInteractionEnabled=NO;
    [self addSubview:txtView];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 57,100, 20)];
    priceLabel.textColor=[UIColor colorWithRed:72/255.0 green:144/255.0 blue:48/255.0 alpha:1.0];
    priceLabel.font= [UIFont fontWithName:@"HelveticaNeue" size:15];
    priceLabel.text=self.price;
    //[self addSubview:priceLabel];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 67,160, 20)];
    dateLabel.textColor=[UIColor colorWithRed:72/255.0 green:144/255.0 blue:48/255.0 alpha:1.0];
    dateLabel.font= [UIFont fontWithName:@"HelveticaNeue" size:15];
    dateLabel.text=self.date;
    // [self addSubview:dateLabel];
    
    
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeButton.frame = CGRectMake(10, frame.size.height-20, frame.size.width - 20, 35);
    [closeButton setTitle:@"Ok" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    closeButton.alpha=1;
    //closeButton.backgroundColor=[UIColor orangeColor];
    UIView *lineview=[[UIView alloc] initWithFrame:CGRectMake(0, 150, frame.size.width, 1)];
    lineview.backgroundColor=[UIColor lightGrayColor];
    
    
    [self addSubview:headerView];
    [self addSubview:label];
    [self addSubview:closeButton];
    [self addSubview:lineview];
    
    
}
-(void) showPayUPaymentAlertWithTitle :(NSString*)title andMessage :(NSAttributedString*)msg withFram:(CGRect)frame {
    
    originalFrame = frame;
    self.alpha = 0;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    self.layer.masksToBounds = NO;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 8.0f;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
    headerView.backgroundColor=[UIColor colorWithRed:28/255.0 green:121/255.0 blue:173/255.0 alpha:1.0];
    UILabel *backImageLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    backImageLabel.backgroundColor=[UIColor whiteColor];
    [headerView addSubview:backImageLabel];

    UIImageView *tempImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,5,29,29)];
    tempImageView.image=[UIImage imageNamed:@"Logo(PopUp)"];
    [headerView addSubview:tempImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, frame.size.width, 20)];
    label.text = title;
    label.font= [UIFont fontWithName:@"HelveticaNeue" size:17];
    // label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    
    
    
    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(0, 50, frame.size.width, 150)];
    txtView.font= [UIFont fontWithName:@"HelveticaNeue" size:15];
    txtView.attributedText=msg;
    txtView.userInteractionEnabled=NO;
    [self addSubview:txtView];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 57,100, 20)];
    priceLabel.textColor=[UIColor colorWithRed:72/255.0 green:144/255.0 blue:48/255.0 alpha:1.0];
    priceLabel.font= [UIFont fontWithName:@"HelveticaNeue" size:15];
    priceLabel.text=self.price;
    //[self addSubview:priceLabel];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 67,160, 20)];
    dateLabel.textColor=[UIColor colorWithRed:72/255.0 green:144/255.0 blue:48/255.0 alpha:1.0];
    dateLabel.font= [UIFont fontWithName:@"HelveticaNeue" size:15];
    dateLabel.text=self.date;
    // [self addSubview:dateLabel];
    
    
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeButton.frame = CGRectMake(10, frame.size.height-20, frame.size.width - 20, 35);
    [closeButton setTitle:@"Ok" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(proceedToThankYou) forControlEvents:UIControlEventTouchUpInside];
    closeButton.alpha=1;
    //closeButton.backgroundColor=[UIColor orangeColor];
    UIView *lineview=[[UIView alloc] initWithFrame:CGRectMake(0, 150, frame.size.width, 1)];
    lineview.backgroundColor=[UIColor lightGrayColor];
    
    
    [self addSubview:headerView];
    [self addSubview:label];
    [self addSubview:closeButton];
    [self addSubview:lineview];
    
    
}
-(void) showDateWiseOrderPopUp :(NSString*)title andMessage1 :(NSAttributedString*)msg1 andMesaage2:(NSAttributedString*)msg2 withFrame:(CGRect)frame
{
    
}
-(void) showOutstandingBalanceAlertWithTitle :(NSString*)title andMessage :(NSString*)msg withFram:(CGRect)frame {
    
    originalFrame = frame;
    self.alpha = 0;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    self.layer.masksToBounds = NO;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 8.0f;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
    headerView.backgroundColor=[UIColor colorWithRed:28/255.0 green:121/255.0 blue:173/255.0 alpha:1.0];
    UILabel *backImageLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    backImageLabel.backgroundColor=[UIColor whiteColor];
    [headerView addSubview:backImageLabel];

    UIImageView *tempImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,5,29,29)];
    tempImageView.image=[UIImage imageNamed:@"Logo(PopUp)"];
    [headerView addSubview:tempImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, frame.size.width, 20)];
    label.text = title;
    label.font= [UIFont fontWithName:@"HelveticaNeue" size:17];
    // label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    
    
    
    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(0, 50, frame.size.width, 150)];
    txtView.font= [UIFont fontWithName:@"HelveticaNeue" size:15];
    txtView.text=msg;
    txtView.userInteractionEnabled=NO;
    [self addSubview:txtView];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 57,100, 20)];
    priceLabel.textColor=[UIColor colorWithRed:72/255.0 green:144/255.0 blue:48/255.0 alpha:1.0];
    priceLabel.font= [UIFont fontWithName:@"HelveticaNeue" size:15];
    priceLabel.text=self.price;
    //[self addSubview:priceLabel];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 67,160, 20)];
    dateLabel.textColor=[UIColor colorWithRed:72/255.0 green:144/255.0 blue:48/255.0 alpha:1.0];
    dateLabel.font= [UIFont fontWithName:@"HelveticaNeue" size:15];
    dateLabel.text=self.date;
    // [self addSubview:dateLabel];
    
    
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeButton.frame = CGRectMake(10, frame.size.height-30, frame.size.width - 20, 35);
    [closeButton setTitle:@"Ok" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    closeButton.alpha=1;
    //closeButton.backgroundColor=[UIColor orangeColor];
    UIView *lineview=[[UIView alloc] initWithFrame:CGRectMake(0, 150, frame.size.width, 1)];
    lineview.backgroundColor=[UIColor lightGrayColor];
    
    
    [self addSubview:headerView];
    [self addSubview:label];
    [self addSubview:closeButton];
    [self addSubview:lineview];
    
    
}
#pragma mark Custom alert methods
//-(void) navigate{
//  AppDelegate   *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    appDelegate.isThanks=YES;
//    RegisterViewController *registerView = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:[NSBundle mainBundle]];
//    [self.navigationController pushViewController:registerView animated:YES];
//    [appDelegate.checkProductArr removeAllObjects];
//
//}
-(void)viewCartClicked
{
   // [self.cDelegate backtoCartClicked];
}

-(void)keepAllClicked
{
    //[self.cDelegate keepAllOrderClicked];
}
-(void)buttonClicked:(NSString*)str1 str2:(NSString*)str2
{
}
-(void)makeBtnClicked
{
    [self endEditing:YES];
    [self.cDelegate makeClicked:self.amount];
    [self hide];
}
-(void) updateClicked{
    [self.cDelegate updateClicked];
    [self hide];
}

-(void) confirmClicked{
    [self.cDelegate confirmClicked];
    [self hide];
}

-(void) confirmClickedLoc{
    [self.cDelegate confirmClickedLoc];
    [self hide];
}

-(void) continueClicked{
    [self.cDelegate clicked];
    [self hide];
}

- (void)show
{
    NSLog(@"show");
    isShown = YES;
    self.layer.cornerRadius=10;
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.alpha = 0;
    [UIView beginAnimations:@"showAlert" context:nil];
    [UIView setAnimationDelegate:self];
    self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    self.alpha = 1;
    [UIView commitAnimations];
}

- (void)hide
{
    NSLog(@"hide");
    isShown = NO;
    
    [UIView beginAnimations:@"hideAlert" context:nil];
    [UIView setAnimationDelegate:self];
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.alpha = 0;
    [UIView commitAnimations];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"go_back"]isEqualToString:@"yes"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"go_home" object:nil];
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"go_back"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}
-(void)proceedToThankYou
{
    [self.cDelegate ThankYouView];

}
-(void)proceed
{
    [self.cDelegate proceedWithDelivery];
}
- (void)toggle
{
    if (isShown) {
        isShown=NO;
        [self hide];
    } else {
        isShown=YES;
        [self show];
    }
}
#pragma mark Animation delegate

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    if ([animationID isEqualToString:@"showAlert"]) {
        if (finished) {
            [UIView beginAnimations:nil context:nil];
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            [UIView commitAnimations];
        }
    } else if ([animationID isEqualToString:@"hideAlert"]) {
        if (finished) {
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.frame = originalFrame;
        }
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.cDelegate confirmPaymentViewTextFieldDidBeginEditing];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:confirmPaymentTxtField])
    {
        [self.cDelegate confirmPaymentViewTextFieldShouldReturn];
        [confirmPaymentTxtField resignFirstResponder];

    }
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
   self.amount=textField.text;
    return YES;
}

@end
