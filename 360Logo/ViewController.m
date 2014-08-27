//
//  ViewController.m
//  360Logo
//
//  Created by Jason Pepas on 8/26/14.
//  Copyright (c) 2014 Jason Pepas. All rights reserved.
//

#import "ViewController.h"
#import "RingView.h"

@interface ViewController ()

@end

@implementation ViewController
            
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RingView *ringView = [[RingView alloc] initWithRadius:150];
    [self.view addSubview:ringView];
    ringView.center = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    button.frame = self.view.bounds;
    [button addTarget:ringView
               action:@selector(shuffleRingTips)
     forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"thanks to Sam Davies!";
    label.font = [UIFont systemFontOfSize:12];
    [label sizeToFit];
    [self.view addSubview:label];
    
    CGRect labelFrame = label.frame;
    labelFrame.origin.x = (self.view.bounds.size.width - label.bounds.size.width) / 2.0;
    labelFrame.origin.y = self.view.bounds.size.height - label.bounds.size.height - 20;
    label.frame = labelFrame;
}

@end
