//
//  ViewController.m
//  Test
//
//  Created by Lee on 2020/6/28.
//  Copyright © 2020 Lee. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) CALayer *movingLayer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.layer addSublayer:self.movingLayer];
    [self addAnimation];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [self.view addGestureRecognizer:self.tapGesture];
}

-(void)click:(UITapGestureRecognizer *)tapGesture {
    CGPoint touchPoint = [tapGesture locationInView:self.view];
    if ([self.movingLayer.presentationLayer hitTest:touchPoint]) {
        NSLog(@"presentationLayer");
        if (self.movingLayer.speed == 0) {
            [self startAnimating];
        } else {
            [self stopAnimating];
        }
    }
}

-(void)startAnimating {
    //先判断是否已设置动画，如果已设置则执行动画
    if([self.movingLayer animationForKey:@"moveAnimationKey"]){
        //如果动画正在执行则返回，避免重复执行动画
        if (self.movingLayer.speed == 1) {
            //speed == 1表示动画正在执行
            return;
        }
        //让动画执行
        self.movingLayer.speed = 1;
        //取消上次设置的时间
        self.movingLayer.beginTime = 0;
        //获取上次动画停留的时刻
        CFTimeInterval pauseTime = self.movingLayer.timeOffset;
        //取消上次记录的停留时刻
        self.movingLayer.timeOffset = 0;
        //计算暂停的时间，设置相对于父坐标系的开始时间
        self.movingLayer.beginTime = [self.movingLayer convertTime:CACurrentMediaTime() fromLayer:nil] - pauseTime;
    } else{
        //添加动画
        [self addAnimation];
    }
}
-(void)addAnimation
{
    CAKeyframeAnimation *moveLayerAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveLayerAnimation.values = @[[NSValue valueWithCGPoint:CGPointMake(0, 100)],
                                  [NSValue valueWithCGPoint:CGPointMake([UIScreen mainScreen].bounds.size.width - self.movingLayer.bounds.size.width, 100)]];
    moveLayerAnimation.duration = 2.0;
    moveLayerAnimation.autoreverses = YES;
    moveLayerAnimation.repeatCount = INFINITY;
    moveLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.movingLayer addAnimation:moveLayerAnimation forKey:@"moveAnimationKey"];
}

-(void)stopAnimating {
    //如果动画已经暂停，则返回，避免重复，时间会记录错误，造成动画继续后不能连续。
    if (self.movingLayer.speed == 0) {
        return;
    }
    //将当前动画执行到的时间保存到layer的timeOffet中
   //一定要先获取时间再暂停动画
    CFTimeInterval pausedTime = [self.movingLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    //将动画暂停
    self.movingLayer.speed = 0;
    //记录动画暂停时间
    self.movingLayer.timeOffset = pausedTime;
}

- (CALayer *)movingLayer {
    if (!_movingLayer) {
        CGSize layerSize = CGSizeMake(100, 100);
        CALayer *movingLayer = [CALayer layer];
        movingLayer.bounds = CGRectMake(0, 100, layerSize.width, layerSize.height);
        movingLayer.anchorPoint = CGPointMake(0, 0);
        [movingLayer setBackgroundColor:[UIColor orangeColor].CGColor];
        _movingLayer = movingLayer;
    }
    return _movingLayer;
}

- (void)dealloc {
    [self.view removeGestureRecognizer:self.tapGesture];
    self.tapGesture = nil;
}

@end
