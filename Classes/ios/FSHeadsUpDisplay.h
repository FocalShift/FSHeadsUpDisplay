//
//  FSHeadsUpDisplay.h
//
//  Created by Bennett Smith on 2/20/14.
//  Copyright (c) 2014 FocalShift, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSHeadsUpDisplay : UIView
+ (FSHeadsUpDisplay *)HeadsUpDisplayForView:(UIView *)view;
+ (void)setDefaultHeadsUpDisplay:(FSHeadsUpDisplay *)hud;
+ (FSHeadsUpDisplay *)defaultHeadsUpDisplay;
+ (void)showMessage:(NSString *)message title:(NSString *)title;

@property (nonatomic, assign) NSTimeInterval hudDismissalTime;

- (void)showMessage:(NSString *)message title:(NSString *)title;
- (void)showAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated;
@end
