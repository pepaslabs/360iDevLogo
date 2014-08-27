//
//  RingView.h
//  360Logo
//
//  Created by Jason Pepas on 8/26/14.
//  Copyright (c) 2014 Jason Pepas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RingView : UIView

- (instancetype)initWithRadius:(CGFloat)radius;
- (void)shuffleRingTips;

@end
