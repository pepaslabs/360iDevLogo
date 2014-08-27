//
//  RingView.m
//  360Logo
//
//  Created by Jason Pepas on 8/26/14.
//  Copyright (c) 2014 Jason Pepas. All rights reserved.
//

#import "RingView.h"
#import <pop/POP.h>

@interface RingView ()
@property (nonatomic, strong) NSMutableArray *startLayers;
@property (nonatomic, strong) NSMutableArray *endLayers;
@end


@implementation RingView

- (instancetype)initWithRadius:(CGFloat)radius
{
    self = [super initWithFrame:CGRectMake(0, 0, radius*2, radius*2)];
    if (self == nil)
    {
        return nil;
    }

    CGFloat previousLineWidth;
    CGFloat currentLineWidth;
    CGFloat iteratedRadius;
    
    previousLineWidth = 0;
    currentLineWidth = 24.0;
    iteratedRadius = (self.bounds.size.width / 2.0) - (previousLineWidth/2.0) - (currentLineWidth/2.0);
    [self _addRingWithColor:[UIColor colorWithRed:24/255.0 green:54/255.0 blue:78/255.0 alpha:1]
                     radius:iteratedRadius
                  lineWidth:currentLineWidth
                      start:[self _randomStrokeStart]
                        end:[self _randomStrokeEnd]];
    
    previousLineWidth = currentLineWidth;
    currentLineWidth = 8.0;
    iteratedRadius = iteratedRadius - (previousLineWidth/2.0) - (currentLineWidth/2.0);
    [self _addRingWithColor:[UIColor colorWithRed:31/255.0 green:76/255.0 blue:113/255.0 alpha:1]
                     radius:iteratedRadius
                  lineWidth:currentLineWidth
                      start:[self _randomStrokeStart]
                        end:[self _randomStrokeEnd]];
    
    previousLineWidth = currentLineWidth;
    currentLineWidth = 18.0;
    iteratedRadius = iteratedRadius - (previousLineWidth/2.0) - (currentLineWidth/2.0);
    [self _addRingWithColor:[UIColor colorWithRed:12/255.0 green:99/255.0 blue:172/255.0 alpha:1]
                     radius:iteratedRadius
                  lineWidth:currentLineWidth
                      start:[self _randomStrokeStart]
                        end:[self _randomStrokeEnd]];
    
    previousLineWidth = currentLineWidth;
    currentLineWidth = 16.0;
    iteratedRadius = iteratedRadius - (previousLineWidth/2.0) - (currentLineWidth/2.0);
    [self _addRingWithColor:[UIColor colorWithRed:31/255.0 green:76/255.0 blue:113/255.0 alpha:1]
                     radius:iteratedRadius
                  lineWidth:currentLineWidth
                      start:[self _randomStrokeStart]
                        end:[self _randomStrokeEnd]];
    
    previousLineWidth = currentLineWidth;
    currentLineWidth = 10.0;
    iteratedRadius = iteratedRadius - (previousLineWidth/2.0) - (currentLineWidth/2.0);
    [self _addRingWithColor:[UIColor colorWithRed:24/255.0 green:52/255.0 blue:75/255.0 alpha:1]
                     radius:iteratedRadius
                  lineWidth:currentLineWidth
                      start:[self _randomStrokeStart]
                        end:[self _randomStrokeEnd]];
    
    [self _setupLabel];
    
    return self;
}

- (CGFloat)_randomStrokeStart
{
    int fuzzDegrees = arc4random_uniform(30) - 15;
    CGFloat startDegrees = 150 + fuzzDegrees;
    CGFloat start = startDegrees / 360.0;
    return start;
}

- (CGFloat)_randomStrokeEnd
{
    int fuzzDegrees = arc4random_uniform(30) - 15;
    CGFloat startDegrees = 30 + fuzzDegrees;
    CGFloat start = startDegrees / 360.0;
    return start;
}

- (void)_addRingWithColor:(UIColor*)color
                   radius:(CGFloat)radius
                lineWidth:(CGFloat)width
                    start:(CGFloat)start
                      end:(CGFloat)end
{
    CGRect rect = CGRectMake((self.bounds.size.width - (radius * 2)) / 2,
                             (self.bounds.size.height - (radius * 2)) / 2,
                             radius * 2,
                             radius * 2);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect
                                                    cornerRadius:radius];
    
    {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = color.CGColor;
        shapeLayer.lineWidth = width;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeStart = start;
        shapeLayer.strokeEnd = 1;
        [self.layer addSublayer:shapeLayer];
        [self.startLayers addObject:shapeLayer];
    }
    
    {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = color.CGColor;
        shapeLayer.lineWidth = width;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeStart = 0;
        shapeLayer.strokeEnd = end;
        [self.layer addSublayer:shapeLayer];
        [self.endLayers addObject:shapeLayer];
    }
}

- (void)shuffleRingTips
{
    for (int i = 0; i < self.startLayers.count; i++)
    {
        [self _shuffleRingTipsAtIndex:i];
    }
}

- (void)_shuffleRingTipsAtIndex:(NSUInteger)index
{
    [self _shuffleRingStartAtIndex:index];
    [self _shuffleRingEndAtIndex:index];
}

- (void)_shuffleRingStartAtIndex:(NSUInteger)index
{
    CAShapeLayer *layer = [self.startLayers objectAtIndex:index];
    
    POPBasicAnimation *popAnimation = [POPBasicAnimation animation];
    popAnimation.duration = 0.3;
    popAnimation.fromValue = @(layer.strokeStart);
    popAnimation.toValue = @([self _randomStrokeStart]);
    popAnimation.property = [POPAnimatableProperty propertyWithName:@"strokeStart" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.readBlock = ^(id obj, CGFloat values[]) {
            values[0] = [obj strokeStart];
        };
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            [obj setStrokeStart:values[0]];
        };
    }];
    
    [layer pop_addAnimation:popAnimation forKey:@"strokeStartAnimation"];
}

- (void)_shuffleRingEndAtIndex:(NSUInteger)index
{
    CAShapeLayer *layer = [self.endLayers objectAtIndex:index];
    
    POPBasicAnimation *popAnimation = [POPBasicAnimation animation];
    popAnimation.duration = 0.3;
    popAnimation.fromValue = @(layer.strokeEnd);
    popAnimation.toValue = @([self _randomStrokeEnd]);
    popAnimation.property = [POPAnimatableProperty propertyWithName:@"strokeEnd" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.readBlock = ^(id obj, CGFloat values[]) {
            values[0] = [obj strokeEnd];
        };
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            [obj setStrokeEnd:values[0]];
        };
    }];
    
    [layer pop_addAnimation:popAnimation forKey:@"strokeEndAnimation"];
}

- (void)_setupLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"360|iDev";
    label.font = [UIFont systemFontOfSize:48];
    [label sizeToFit];
    [self addSubview:label];
    
    CGRect labelFrame = label.frame;
    labelFrame.origin.x = (self.bounds.size.width / 2.0) - 40;
    label.frame = labelFrame;
    
    CGPoint labelCenter = label.center;
    labelCenter.y = (self.bounds.size.height / 2.0);
    label.center = labelCenter;
}

#pragma mark - lazy-loaded properties

- (NSMutableArray*)startLayers
{
    if (_startLayers == nil)
    {
        _startLayers = [NSMutableArray new];
    }
    return _startLayers;
}

- (NSMutableArray*)endLayers
{
    if (_endLayers == nil)
    {
        _endLayers = [NSMutableArray new];
    }
    return _endLayers;
}

@end
