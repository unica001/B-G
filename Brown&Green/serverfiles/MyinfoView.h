//
//  MyinfoView.h
//  MenuDemo
//
//  Created by raghvendra rajwat on 1/5/15.
//  Copyright (c) 2015 raghvendra Rajawat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol continueDelegate <NSObject>

@ optional
-(void)clicked;
-(void) confirmClicked;
-(void) confirmClickedLoc;
-(void) updateClicked;
-(void)makeClicked :(NSString*)amount;
-(void)viewCartClicked;
-(void)keepAllClicked;
-(void)confirmPaymentViewTextFieldDidBeginEditing;
-(void)confirmPaymentViewTextFieldShouldReturn;
-(void)confirmPaymentNumberToolbarCancelClicked;
-(void)confirmPaymentNumberToolbarDoneClicked;
-(void)proceedWithDelivery;
-(void)ThankYouView;
@end



@interface MyinfoView : UIView<UITextFieldDelegate>
{
    CGRect originalFrame;
    BOOL isShown;
    UITextField *confirmPaymentTxtField;
}

@property(nonatomic) id <continueDelegate> cDelegate;
@property (nonatomic) BOOL isShown;
@property(nonatomic) NSString *price;
@property(nonatomic) NSString *date;
@property(nonatomic) NSString *amount;

- (void)show;
- (void)hide;
- (void)toggle;
-(void) showAlertWithTitle :(NSString*)title andMessage :(NSAttributedString*)msg withFram:(CGRect)frm;
-(void)showMinAlertWithTitle :(NSString*)title andMessage :(NSString*)msg withFram:(CGRect)frm;
-(void) showMinAlert2WithTitle:(NSString *)title andMessage:(NSString *)msg withFram:(CGRect)frame;
-(void)showAutoShipAlertWithTitle :(NSString*)title andMessage :(NSString*)msg withFram:(CGRect)frm;
-(void)showCancelAlertWithTitle :(NSString*)title andMessage :(NSString*)msg withFram:(CGRect)frm;
-(void) showOneTimeCancelAlertWithTitle:(NSString *)title andMessage:(NSAttributedString *)msg withFram:(CGRect)frame;
-(void) showProfileAlertWithTitle:(NSString *)title andMessage:(NSString *)msg withFram:(CGRect)frame;
-(void) showRegAlertWithTitle:(NSString *)title andMessage:(NSString *)msg withFram:(CGRect)frame;
-(void) showRegLocAlertWithTitle:(NSString *)title andMessage:(NSString *)msg withFram:(CGRect)frame;
-(void) showCurrentAutoshipCancelAlertWithTitle:(NSString *)title andMessage:(NSAttributedString *)msg withFram:(CGRect)frame;
-(void) showAppAlertWithTitle:(NSString *)title andMessage:(NSString *)msg withFram:(CGRect)frame;
-(void) showConfirmAmountWithTitle:(NSString *)title andMessage:(NSString *)msg withFram:(CGRect)frame;
-(void) showPaymentAlertWithTitle :(NSString*)title andMessage :(NSAttributedString*)msg withFram:(CGRect)frame;
-(void) showDateWiseOrderPopUp :(NSString*)title andMessage1 :(NSAttributedString*)msg1 andMesaage2:(NSAttributedString*)msg2 withFrame:(CGRect)frame;
-(void) showOutstandingBalanceAlertWithTitle :(NSString*)title andMessage :(NSString*)msg withFram:(CGRect)frame;
-(void) showPayUPaymentAlertWithTitle :(NSString*)title andMessage :(NSAttributedString*)msg withFram:(CGRect)frame;

@end
