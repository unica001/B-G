//
//  SKSplashView.h
//  SKSplashView
//
//  Created by Sachin Kesiraju on 10/25/14.
//  Copyright (c) 2014 Sachin Kesiraju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@class SKSplashIcon;
@class SKSplashView;

@protocol SKSplashDelegate <NSObject>
@optional
- (void) splashView: (SKSplashView *) splashView didBeginAnimatingWithDuration: (float) duration;
- (void) splashViewDidEndAnimating: (SKSplashView *) splashView;
@end

typedef NS_ENUM(NSInteger, SKSplashAnimationType)
{
    SKSplashAnimationTypeFade =0,
    SKSplashAnimationTypeBounce,
    SKSplashAnimationTypeShrink,
    SKSplashAnimationTypeZoom,
    SKSplashAnimationTypeNone
};

@interface SKSplashView : UIView

@property (strong, nonatomic) UIImage *backgroundImage;
@property (nonatomic, assign) CGFloat animationDuration; //Default: 1s

@property (weak, nonatomic) id <SKSplashDelegate> delegate;

//Init splash view
- (instancetype)initWithAnimationType: (SKSplashAnimationType) animationType;
- (instancetype)initWithSplashIcon: (SKSplashIcon *)icon animationType: (SKSplashAnimationType) animationType;

//Start animation
- (void)startAnimation;
- (void)startAnimationWhileExecuting: (NSURLRequest *) request withCompletion:(void(^)(NSData *data, NSURLResponse *response, NSError *error)) completion; //NOTE: Splash View returns regardless of whether request was success -> error handling highly recommended

@end
