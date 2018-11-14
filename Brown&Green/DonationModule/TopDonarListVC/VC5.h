//
//  VC5.h
//  Video
//
//  Created by Anand on 03/05/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC5 : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *collection;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

- (IBAction)btn_Back_Clicked:(UIButton *)sender;
- (IBAction)btn_Next_Clicked:(UIButton *)sender;


@end
