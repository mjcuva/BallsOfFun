//
//  growBallView.m
//  Balls of Fun
//
//  Created by Marc Cuva on 5/17/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "growBallView.h"

@implementation GrowBallView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(resizeBall:)];
        [self addGestureRecognizer:pinchGesture];
    }
    
    return self;
}

- (void)setGrowing:(BOOL)growing{
    if(!growing){
        [self growBall];
    }
    _growing = growing;
}

- (void)growBall{
    
    dispatch_queue_t queue = dispatch_queue_create("Grow Ball", NULL);
    dispatch_async(queue, ^{
        while(!self.growing){
            dispatch_sync(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0 animations:^{
                    CGFloat width = self.frame.size.width + .5;
                    CGFloat height = self.frame.size.height + .5;
                    self.frame = CGRectMake(self.frame.origin.x - (.5 / 2), self.frame.origin.y - (.5 / 2), width, height);
                    [self setNeedsDisplay];
                }];
            });
        }
    });
}

- (void)resizeBall:(UIPinchGestureRecognizer *)sender{
    if(sender.state == UIGestureRecognizerStateChanged || sender.state == UIGestureRecognizerStateRecognized){
        CGFloat newRadius = self.frame.size.width * sender.scale;
        if(newRadius > self.superview.frame.size.width * 2/3)
            newRadius = self.superview.frame.size.width * 2/3;
        
        self.frame = CGRectMake(self.frame.origin.x - ((newRadius - self.frame.size.width) / 2), self.frame.origin.y - ((newRadius - self.frame.size.height) / 2), newRadius, newRadius);
        sender.scale = 1;
        [self setNeedsDisplay];
    }
}



@end