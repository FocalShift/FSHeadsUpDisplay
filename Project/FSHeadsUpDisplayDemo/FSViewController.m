//
//  FSViewController.m
//  FSHeadsUpDisplayDemo
//
//  Created by Bennett Smith on 2/21/14.
//  Copyright (c) 2014 FocalShift, LLC. All rights reserved.
//

#import "FSViewController.h"
#import <FSHeadsUpDisplay/FSHeadsUpDisplay.h>

@interface FSViewController ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) NSTimer *messageTimer;
@property (nonatomic, assign) NSUInteger messageIndex;
@property (nonatomic, strong) FSHeadsUpDisplay *hud;
@end

@implementation FSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"FSHeadsUpDisplay";
    
    self.messages = @[
                      @"The Quick Brown Fox Jumped Over The Lazy Rabbit.",
                      @"Nihilne te nocturnum praesidium Palati, nihil urbis vigiliae.",
                      @"Plura mihi bona sunt, inclinet, amari petere vellent.",
                      @"Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua.",
                      @"Curabitur blandit tempus ardua ridiculus sed magna.",
                      @"Qui ipsorum lingua Celtae, nostra Galli appellantur.",
                      @"Count Down To The End",
                      @"5", @"4", @"3", @"2", @"1",
                      @"Kaboom!"
                    ];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.hud = [FSHeadsUpDisplay HeadsUpDisplayForView:self.view];
    [FSHeadsUpDisplay setDefaultHeadsUpDisplay:self.hud];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showHeadsUpDisplay:(id)sender {
    self.messageIndex = 0;
    self.messageTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(displayNextMessage:) userInfo:nil repeats:YES];
}

- (void)displayNextMessage:(NSTimer *)timer {
    [FSHeadsUpDisplay showMessage:self.messages[self.messageIndex] title:self.title];
    self.messageIndex++;
    if (self.messageIndex == self.messages.count) {
        [self.messageTimer invalidate];
        self.messageTimer = nil;
    }
}

@end
