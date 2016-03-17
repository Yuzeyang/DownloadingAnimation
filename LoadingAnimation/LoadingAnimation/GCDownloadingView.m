//
//  GCDownloadingView.m
//  LoadingAnimation
//
//  Created by 宫城 on 16/3/17.
//  Copyright © 2016年 宫城. All rights reserved.
//

#import "GCDownloadingView.h"

@interface GCDownloadingView ()

@property (nonatomic, strong) CALayer *loadingLayer;
@property (nonatomic, strong) CALayer *doneLayer;
@property (nonatomic, strong) CALayer *failLayer;

@end

@implementation GCDownloadingView

+ (instancetype)showDownloadingViewAddedTo:(UIView *)view {
    GCDownloadingView *downloadingView = [[self alloc] initWithView:view];
    [view addSubview:downloadingView];
    return downloadingView;
}

+ (BOOL)hideDownloadingViewForView:(UIView *)view {
    GCDownloadingView *downloadingView = [self downloadViewForView:view];
    if (downloadingView != nil) {
        [downloadingView removeFromSuperview];
        return YES;
    }
    return NO;
}

+ (instancetype)downloadViewForView:(UIView *)view {
    NSEnumerator *subviewsEnumerator = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnumerator) {
        if ([subview isKindOfClass:self]) {
            return (GCDownloadingView *)subview;
        }
    }
    return nil;
}

- (id)initWithView:(UIView *)view {
    return [self initWithFrame:view.frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.downloadingViewWidth = 100;
        [self setUpWithFrame:frame];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"downloadingViewWidth"];
}

- (void)setUpWithFrame:(CGRect)frame {
    self.frame = CGRectMake(0, 0, self.downloadingViewWidth, self.downloadingViewWidth);
    self.center = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)/2);
    
    CGPoint center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    
    self.loadingLayer = [CALayer layer];
    self.loadingLayer.contents = (__bridge id)([UIImage imageNamed:@"icon_downloading.png"].CGImage);
    self.loadingLayer.bounds = CGRectMake(0, 0, self.downloadingViewWidth * 0.9, self.downloadingViewWidth * 0.9);
    self.loadingLayer.position = center;
    [self.layer addSublayer:self.loadingLayer];
    
    self.doneLayer = [CALayer layer];
    self.doneLayer.contents = (__bridge id)([UIImage imageNamed:@"icon_downloadingdone.png"].CGImage);
    self.doneLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.loadingLayer.frame)/2, CGRectGetHeight(self.loadingLayer.frame)/2);
    self.doneLayer.position = CGPointMake(center.x, center.y * 1.1);
    self.doneLayer.opacity = 0.0;
    [self.layer addSublayer:self.doneLayer];
    
    self.failLayer = [CALayer layer];
    self.failLayer.contents = (__bridge id)([UIImage imageNamed:@"icon_downloadingfail.png"].CGImage);
    self.failLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.loadingLayer.frame)/2, CGRectGetHeight(self.loadingLayer.frame)/2);
    self.failLayer.position = center;
    self.failLayer.opacity = 0.0;
    [self.layer addSublayer:self.failLayer];
    
    [self addObserver:self forKeyPath:@"downloadingViewWidth" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setDownloadingStatus:(GCDownloadingStatus)downloadingStatus {
    if (downloadingStatus == GCDownloadingStatusStart) {
        CABasicAnimation *rotationZAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationZAnimation.fromValue = @(0);
        rotationZAnimation.toValue = @(M_PI*2);
        rotationZAnimation.repeatDuration = HUGE_VAL;
        rotationZAnimation.duration = 1.0;
        rotationZAnimation.cumulative = YES;
        rotationZAnimation.beginTime = CACurrentMediaTime();
        [self.loadingLayer addAnimation:rotationZAnimation forKey:@"rotationZAnimation"];
        
        NSArray *values = [self valueArrayWithWidth:self.downloadingViewWidth];
        CAKeyframeAnimation *boundsAnimation = [self bounsAnimationWithValues:values];
        [self.loadingLayer addAnimation:boundsAnimation forKey:nil];
    } else if (downloadingStatus == GCDownloadingStatusStop) {
        [self.loadingLayer removeAllAnimations];
    } else if (downloadingStatus == GCDownloadingStatusDone) {
        [self.loadingLayer removeAllAnimations];
        self.failLayer.opacity = 0.0;
        NSArray *values = [self valueArrayWithWidth:self.downloadingViewWidth * 0.5];
        CAKeyframeAnimation *boundsAnimation = [self bounsAnimationWithValues:values];
        [self.doneLayer addAnimation:boundsAnimation forKey:nil];
        
        [UIView animateWithDuration:1.0 animations:^{
            self.doneLayer.opacity = 1.0;
        }];
    } else {
        [self.loadingLayer removeAllAnimations];
        self.doneLayer.opacity = 0.0;
        NSArray *values = [self valueArrayWithWidth:self.downloadingViewWidth * 0.5];
        CAKeyframeAnimation *boundsAnimation = [self bounsAnimationWithValues:values];
        [self.failLayer addAnimation:boundsAnimation forKey:nil];
        
        [UIView animateWithDuration:1.0 animations:^{
            self.failLayer.opacity = 1.0;
        }];
    }
}

- (NSArray *)valueArrayWithWidth:(CGFloat)width {
    return @[[NSValue valueWithCGRect:CGRectMake(0, 0, width * 0.7, width * 0.7)],
             [NSValue valueWithCGRect:CGRectMake(0, 0, width, width)],
             [NSValue valueWithCGRect:CGRectMake(0, 0, width * 0.9, width * 0.9)]];
}

- (CAKeyframeAnimation *)bounsAnimationWithValues:(NSArray *)values {
    CAKeyframeAnimation *boundsAnimation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    boundsAnimation.duration = 0.6;
    boundsAnimation.beginTime = CACurrentMediaTime();
    boundsAnimation.values = values;
    boundsAnimation.keyTimes = @[@(0),@(0.3),@(0.6)];
    boundsAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    boundsAnimation.removedOnCompletion = NO;
    boundsAnimation.fillMode = kCAFillModeForwards;
    return boundsAnimation;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"downloadingViewWidth"]) {
        CGFloat width = [[change valueForKey:NSKeyValueChangeNewKey] floatValue];
        self.loadingLayer.bounds = CGRectMake(0, 0, width, width);
        CGPoint center = self.doneLayer.position;
        center.y = center.y * (1 + 0.1 * width / 90) / 1.1;
        self.doneLayer.position = center;
    }
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

@end
