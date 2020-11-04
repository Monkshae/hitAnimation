//
//  DanmuMessageAnimationHelper.m
//  Test
//
//  Created by Lee on 2020/11/2.
//  Copyright © 2020 Lee. All rights reserved.
//

#import "DanmuMessageAnimationHelper.h"
#import "UITapGestureRecognizer+block.h"
#import "CAKeyframeAnimation+AnimationKey.h"


@interface DanmakuLabel : UILabel

@end

@implementation DanmakuLabel

@end



@interface DanmuMessageAnimationHelper ()<CAAnimationDelegate>

@property (nonatomic, weak) UIView *container;
//@property (nonatomic, strong) UILabel *movingLabel;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end


static NSInteger a = 0;

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
    __weak typeof(self) weakSelf = self;
    [container addGestureRecognizer:self.tapGesture];
    a++;
    
    DanmakuLabel *movingLabel = [[DanmakuLabel alloc]initWithFrame:CGRectMake(0, 100, 100, 30)];
    movingLabel.text = [NSString stringWithFormat:@"这是一个测试%@",@(a)];
    movingLabel.font = [UIFont systemFontOfSize:14];
    movingLabel.textAlignment = NSTextAlignmentLeft;
    movingLabel.backgroundColor = UIColor.purpleColor;
    
    [container addSubview:movingLabel];
    [self addAnimationWithLayer:movingLabel.layer];
    
    self.tapGesture.clickAction = ^(UITapGestureRecognizer * _Nonnull tap) {
        CGPoint touchPoint = [weakSelf.tapGesture locationInView:container];
        DanmakuLabel *danmakuLabel = nil;
        for (UIView *v in [container subviews]) {
            if ([v isKindOfClass:[DanmakuLabel class]]) {
                if ([v.layer.presentationLayer hitTest:touchPoint]) {
                    danmakuLabel = (DanmakuLabel *)v;
                    break;
                }
            }
        }
        NSLog(@"text = %@",danmakuLabel.text);
        if (danmakuLabel.layer.speed == 0) {
            [weakSelf startAnimatingWithLayer:danmakuLabel.layer];
        } else {
            [weakSelf stopAnimatingWithLayer:danmakuLabel.layer];
            if (tapBlock) {
                tapBlock(danmakuLabel.layer.presentationLayer.position);
            }
        }
    };
}

-(void)startAnimatingWithLayer:(CALayer *)layer {
    //先判断是否已设置动画，如果已设置则执行动画
    NSString *key = [self getKeyWithLayer:layer];
    if([layer animationForKey:key]){
        //如果动画正在执行则返回，避免重复执行动画
        if (layer.speed == 1) {
            //speed == 1表示动画正在执行
            return;
        }
        //让动画执行
        layer.speed = 1;
        //取消上次设置的时间
        layer.beginTime = 0;
        //获取上次动画停留的时刻
        CFTimeInterval pauseTime = layer.timeOffset;
        //取消上次记录的停留时刻
        layer.timeOffset = 0;
        //计算暂停的时间，设置相对于父坐标系的开始时间
        layer.beginTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pauseTime;
    } else{
        //添加动画
        [self addAnimationWithLayer:layer];
    }
}
-(void)addAnimationWithLayer:(CALayer *)layer
{
    CAKeyframeAnimation *moveLayerAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveLayerAnimation.values = @[[NSValue valueWithCGPoint:CGPointMake(-50, 100 + 30/2)],
                                  [NSValue valueWithCGPoint:CGPointMake([UIScreen mainScreen].bounds.size.width + 100, 100 + 30/2)]];
    moveLayerAnimation.duration = 5.0;
    moveLayerAnimation.autoreverses = NO;
    moveLayerAnimation.removedOnCompletion = NO;
    moveLayerAnimation.repeatCount = 1;//INFINITY;
    moveLayerAnimation.delegate = self;
    moveLayerAnimation.fillMode = kCAFillModeForwards;
    moveLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
     
    NSString *key = [self getKeyWithLayer:layer];//[NSString stringWithFormat:@"moveAnimationKey_%p",layer];
    [layer addAnimation:moveLayerAnimation forKey:key];
//    layer.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 100, 100, 30);
}

-(void)stopAnimatingWithLayer:(CALayer *)layer {
    //如果动画已经暂停，则返回，避免重复，时间会记录错误，造成动画继续后不能连续。
    if (layer.speed == 0) {
        return;
    }
    //将当前动画执行到的时间保存到layer的timeOffet中
   //一定要先获取时间再暂停动画
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    //将动画暂停
    layer.speed = 0;
    //记录动画暂停时间
    layer.timeOffset = pausedTime;
}

//- (UILabel *)movingLabel {
//    if (!_movingLabel) {
//        UILabel *movingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 100, 100)];
//        movingLabel.text = @"这是一个测试";
//        movingLabel.font = [UIFont systemFontOfSize:14];
//        movingLabel.textAlignment = NSTextAlignmentLeft;
//        movingLabel.backgroundColor = UIColor.purpleColor;
//        _movingLabel = movingLabel;
//    }
//    return _movingLabel;
//}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
//    CAKeyframeAnimation *keyAnimation = (CAKeyframeAnimation *)anim;
//    CAKeyframeAnimation *animation = [anim animation];
//    self.container.layer.name
//    self.container.layer
//    NSLog(@"aaaaa 从屏幕删除的label的key %@",);
//    [self.movingLabel removeFromSuperview];
//    self.movingLabel = nil;
    
//    [self.container removeGestureRecognizer:self.tapGesture];
//    self.tapGesture = nil;
    
//    [self.container.layer remove];
    
    for (UIView *v in [self.container subviews]) {
        if ([v isKindOfClass:[DanmakuLabel class]]) {
            if (v.layer.presentationLayer.position.x == [UIScreen mainScreen].bounds.size.width + 100) {
                [v removeFromSuperview];
            }
        }
    }
}

- (NSString *)getKeyWithLayer:(CALayer *)layer {
    return [NSString stringWithFormat:@"moveAnimationKey_%p",layer];
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        _tapGesture = tap;
    }
    return _tapGesture;
}

@end
