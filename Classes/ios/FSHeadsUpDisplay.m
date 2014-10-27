//
//  FSHeadsUpDisplay.m
//
//  Created by Bennett Smith on 2/20/14.
//  Copyright (c) 2014 FocalShift, LLC. All rights reserved.
//

#import <FSHeadsUpDisplay/FSHeadsUpDisplay.h>
#import <QuartzCore/QuartzCore.h>
#import <FSClassExtensions/NSThread+FSClassExtensions.h>

@interface FSHeadsUpDisplay ()
@property (nonatomic, strong) NSTimer *dismissalTimer;
@property (nonatomic, strong) UIView *labelsContainer;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@end

static FSHeadsUpDisplay *defaultHeadsUpDisplay = nil;

@implementation FSHeadsUpDisplay

+ (FSHeadsUpDisplay *)HeadsUpDisplayForView:(UIView *)superview {
    FSHeadsUpDisplay *hud = [[FSHeadsUpDisplay alloc] initWithFrame:CGRectZero];
    [superview addSubview:hud];
    [hud setupConstraints];
    return hud;
}

+ (void)setDefaultHeadsUpDisplay:(FSHeadsUpDisplay *)hud {
    if (defaultHeadsUpDisplay) {
        [defaultHeadsUpDisplay.dismissalTimer invalidate];
        [defaultHeadsUpDisplay hideAnimated:NO];
        [defaultHeadsUpDisplay removeFromSuperview];
        defaultHeadsUpDisplay.messageLabel = nil;
        defaultHeadsUpDisplay.titleLabel = nil;
        defaultHeadsUpDisplay.labelsContainer = nil;
        defaultHeadsUpDisplay = nil;
    }
    defaultHeadsUpDisplay = hud;
}

+ (FSHeadsUpDisplay *)defaultHeadsUpDisplay {
    return defaultHeadsUpDisplay;
}

+ (void)showMessage:(NSString *)message title:(NSString *)title {
    [defaultHeadsUpDisplay showMessage:message title:title];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 10.0f;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
        self.hidden = YES;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        _hudDismissalTime = 5.0f;
        _labelsContainer = [self constructLabelsContainer];
        _titleLabel = [self constructTitleLabel];
        _messageLabel = [self constructMessageLabel];
        
        [_labelsContainer addSubview:_titleLabel];
        [_labelsContainer addSubview:_messageLabel];
        [self addSubview:_labelsContainer];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"HUD dealloc called!");
}

- (UIView *)constructLabelsContainer {
    UIView *container = [[UIView alloc] initWithFrame:CGRectZero];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    return container;
}

- (UILabel *)constructTitleLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = [UIFont boldSystemFontOfSize:18.0f];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = NO;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

- (UILabel *)constructMessageLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = [UIFont boldSystemFontOfSize:14.0f];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = NO;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

- (void)showMessage:(NSString *)message title:(NSString *)title {
    [NSThread ensureMainThread:^{
        self.messageLabel.text = [message copy];
        self.titleLabel.text = [title copy];
        self.opaque = NO;
        self.superview.userInteractionEnabled = NO;
        
        [self.dismissalTimer invalidate];
        self.dismissalTimer = [NSTimer scheduledTimerWithTimeInterval:self.hudDismissalTime target:self selector:@selector(dismissHeadsUpDisplay:) userInfo:nil repeats:NO];
        
        [self.superview bringSubviewToFront:self];

        [self setNeedsUpdateConstraints];
        [self setNeedsLayout];
        [self setNeedsDisplay];
        
        if ([self isHidden] == YES) {
            [self showAnimated:YES];
        }
    }];
}

- (void)setupConstraints {
    float height = 150.0f;
    NSDictionary *views = @{ @"superview": self.superview, @"self": self, @"container": _labelsContainer, @"title": _titleLabel, @"message": _messageLabel };
    NSDictionary *metrics = @{ @"verticalSpace": @16.0, @"border": @30.0, @"height": @(height) };
    
    [_labelsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[title]-[message]-|" options:NSLayoutFormatAlignAllCenterX metrics:metrics views:views]];
    [_labelsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[title]-|" options:0 metrics:metrics views:views]];
    [_labelsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[message]-|" options:0 metrics:metrics views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[container]-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[container]-|" options:0 metrics:metrics views:views]];
    
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeWidth multiplier:0.85f constant:0.0f]];
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:height]];
}

- (void)updateConstraints {
    // Add code to update constraints here.
    [super updateConstraints];
}

- (void)showAnimated:(BOOL)animated {
    [NSThread ensureMainThread:^{
        if (animated) {
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
        else {
            self.alpha = 0.8f;
            self.transform = CGAffineTransformIdentity;
            self.hidden = NO;
        }
    }];
}

- (void)hideAnimated:(BOOL)animated {
    [NSThread ensureMainThread:^{
        if (self.dismissalTimer) {
            [self.dismissalTimer invalidate];
        }
        
        if (animated) {
            [UIView animateWithDuration:0.3f animations:^{
                self.alpha = 0.0f;
            } completion:^(BOOL finished) {
                UIView *superview = [self superview];
                superview.userInteractionEnabled = YES;
                self.hidden = YES;
            }];
        }
        else {
            UIView *superview = [self superview];
            superview.userInteractionEnabled = YES;
            self.hidden = YES;
        }
    }];
}

- (void)dismissHeadsUpDisplay:(NSTimer *)timer {
    [self hideAnimated:YES];
}

@end
