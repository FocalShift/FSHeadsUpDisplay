//
//  FSHeadsUpDisplay.m
//
//  Created by Bennett Smith on 2/20/14.
//  Copyright (c) 2014 FocalShift, LLC. All rights reserved.
//

#import <FSHeadsUpDisplay/FSHeadsUpDisplay.h>
#import <QuartzCore/QuartzCore.h>

@interface FSHeadsUpDisplay ()
@property (nonatomic, strong) NSTimer *dismissalTimer;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@end

@implementation FSHeadsUpDisplay

+ (void)showMessage:(NSString *)message title:(NSString *)title {
    static FSHeadsUpDisplay *hud = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIView *rootView = [FSHeadsUpDisplay rootView];
        hud = [[FSHeadsUpDisplay alloc] initWithFrame:CGRectZero];
        [rootView addSubview:hud];
        
        [hud setTranslatesAutoresizingMaskIntoConstraints:NO];
        [rootView addConstraint:[NSLayoutConstraint constraintWithItem:hud attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
        [rootView addConstraint:[NSLayoutConstraint constraintWithItem:hud attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
        
        hud.widthConstraint = [NSLayoutConstraint constraintWithItem:hud attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeWidth multiplier:0.9f constant:0.0f];
        hud.heightConstraint = [NSLayoutConstraint constraintWithItem:hud attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeHeight multiplier:0.25f constant:0.0f];

        [rootView addConstraint:hud.widthConstraint];
        [rootView addConstraint:hud.heightConstraint];
    });
    
    hud.messageLabel.text = [message copy];
    hud.opaque = NO;
    hud.superview.userInteractionEnabled = NO;
    
    [hud.dismissalTimer invalidate];
    hud.dismissalTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:hud selector:@selector(dismissHeadsUpDisplay:) userInfo:nil repeats:NO];
    
    [hud setNeedsLayout];
    [hud setNeedsDisplay];
    
    if ([hud isHidden] == YES) {
        [hud showAnimated];
    }
}

+ (UIView *)rootView {
    UIWindow *topWindow = [[[UIApplication sharedApplication].windows sortedArrayUsingComparator:^NSComparisonResult(UIWindow *win1, UIWindow *win2) {
        return win1.windowLevel - win2.windowLevel;
    }] lastObject];
    UIView *rootView = topWindow.rootViewController.view;
    return rootView;
}

- (UILabel *)constructMessageLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont boldSystemFontOfSize:16.0f];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = NO;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    
    
    return label;
}

- (NSArray *)prepareConstraintsForLabel:(UILabel *)label withParent:(UIView *)parent {
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSMutableArray *constraints = [NSMutableArray array];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeWidth multiplier:0.85f constant:0.0f]];
    // Rely on intrinsic size for height of the UILabel
    
    return [NSArray arrayWithArray:constraints];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius = 10.0f;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        self.hidden = YES;

        // TODO: Add title and activity indicator.
        
        // The height of the view is 20px + 20px + 10px + title height + message height
        // Title label is centered horizontally and placed 20px below the top of the superview.
        // Message label is centered horizontally and placed 20 px below the bottom of the title label.
        // Activity indicator is centered horizontally and placed 10 px below the bottom of the message label.
        
        _messageLabel = [self constructMessageLabel];
        [self addSubview:_messageLabel];
        [self addConstraints:[self prepareConstraintsForLabel:_messageLabel withParent:self]];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"bye bye!");
}

- (void)showAnimated {
    self.hidden = NO;
    self.alpha = 0.0f;
    self.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.8f;
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)hideAnimated {
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        UIView *superview = [self superview];
        superview.userInteractionEnabled = YES;
        self.hidden = YES;
    }];
}

- (void)dismissHeadsUpDisplay:(NSTimer *)timer {
    [self hideAnimated];
}

@end
