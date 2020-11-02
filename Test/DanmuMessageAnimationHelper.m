//
//  DanmuMessageAnimationHelper.m
//  Test
//
//  Created by Lee on 2020/11/2.
//  Copyright © 2020 Lee. All rights reserved.
//

#import "DanmuMessageAnimationHelper.h"
#import "UITapGestureRecognizer+block.h"

@interface DanmuMessageAnimationHelper ()<CAAnimationDelegate>

@property (nonatomic, weak) UIView *container;
@property (nonatomic, strong) UILabel *movingLabel;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation DanmuMessageAnimationHelper

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static DanmuMessageAnimationHelper *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[DanmuMessageAnimationHelper alloc] init];
    });
    return instance;
}

- (void)danmakuMessageAnimationWithMessage:(NSString *)message inContainer:(UIView *)container tapBlock:(nonnull void (^)(CGPoint))tapBlock {
    self.container = container;
    [self.container addSubview:self.movingLabel];
    [self addAnimation];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] init];
    __weak typeof(self) weakSelf = self;
    self.tapGesture.clickAction = ^(UITapGestureRecognizer * _Nonnull tap) {
        CGPoint touchPoint = [weakSelf.tapGesture locationInView:weakSelf.container];
        if ([weakSelf.movingLabel.layer.presentationLayer hitTest:touchPoint]) {
            NSLog(@"presentationLayer");
            if (weakSelf.movingLabel.layer.speed == 0) {
                [weakSelf startAnimating];
            } else {
                [weakSelf stopAnimating];
                if (tapBlock) {
                    tapBlock(weakSelf.movingLabel.layer.presentationLayer.position);
                }
                NSLog(@"position = %@",NSStringFromCGPoint(weakSelf.movingLabel.layer.presentationLayer.position));


            }
        }
    };
    [container addGestureRecognizer:self.tapGesture];
}

-(void)startAnimating {
    //先判断是否已设置动画，如果已设置则执行动画
    if([self.movingLabel.layer animationForKey:@"moveAnimationKey"]){
        //如果动画正在执行则返回，避免重复执行动画
        if (self.movingLabel.layer.speed == 1) {
            //speed == 1表示动画正在执行
            return;
        }
        //让动画执行
        self.movingLabel.layer.speed = 1;
        //取消上次设置的时间
        self.movingLabel.layer.beginTime = 0;
        //获取上次动画停留的时刻
        CFTimeInterval pauseTime = self.movingLabel.layer.timeOffset;
        //取消上次记录的停留时刻
        self.movingLabel.layer.timeOffset = 0;
        //计算暂停的时间，设置相对于父坐标系的开始时间
        self.movingLabel.layer.beginTime = [self.movingLabel.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pauseTime;
    } else{
        //添加动画
        [self addAnimation];
    }
}
-(void)addAnimation
{
    CAKeyframeAnimation *moveLayerAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveLayerAnimation.values = @[[NSValue valueWithCGPoint:CGPointMake(-50, 150)],
                                  [NSValue valueWithCGPoint:CGPointMake([UIScreen mainScreen].bounds.size.width + 50, 150)]];
    moveLayerAnimation.duration = 5.0;
    moveLayerAnimation.autoreverses = NO;
    moveLayerAnimation.removedOnCompletion = NO;
    moveLayerAnimation.repeatCount = 1;//INFINITY;
    moveLayerAnimation.delegate = self;
    moveLayerAnimation.fillMode = kCAFillModeForwards;
    moveLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.movingLabel.layer addAnimation:moveLayerAnimation forKey:@"moveAnimationKey"];
}

-(void)stopAnimating {
    //如果动画已经暂停，则返回，避免重复，时间会记录错误，造成动画继续后不能连续。
    if (self.movingLabel.layer.speed == 0) {
        return;
    }
    //将当前动画执行到的时间保存到layer的timeOffet中
   //一定要先获取时间再暂停动画
    CFTimeInterval pausedTime = [self.movingLabel.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    //将动画暂停
    self.movingLabel.layer.speed = 0;
    //记录动画暂停时间
    self.movingLabel.layer.timeOffset = pausedTime;
}

- (UILabel *)movingLabel {
    if (!_movingLabel) {
        UILabel *movingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 100, 100)];
        movingLabel.text = @"这是一个测试";
        movingLabel.font = [UIFont systemFontOfSize:14];
        movingLabel.textAlignment = NSTextAlignmentLeft;
        movingLabel.backgroundColor = UIColor.purpleColor;
        _movingLabel = movingLabel;
    }
    return _movingLabel;
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    NSLog(@"aaaaa");
    [self.movingLabel removeFromSuperview];
    self.movingLabel = nil;
    
    [self.container removeGestureRecognizer:self.tapGesture];
    self.tapGesture = nil;
}


@end
