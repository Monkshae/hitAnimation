//
//  ViewController.m
//  Test
//
//  Created by Lee on 2020/6/28.
//  Copyright © 2020 Lee. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

//@property (nonatomic, weak) CALayer *movingLayer;
@property (nonatomic, strong) UILabel *movingLabel;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
//@property (nonatomic, strong) UILongPressGestureRecognizer *longTapGesture;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.movingLabel];
    [self addAnimation];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [self.view addGestureRecognizer:self.tapGesture];
}

- (void)addMenu {
    UIMenuController *menu = [UIMenuController sharedMenuController];
    menu.arrowDirection = UIMenuControllerArrowDown;
    UIMenuItem *reportItem = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(reportAction:)];
    menu.menuItems = @[reportItem];
    CGRect targetRect = CGRectMake(self.movingLabel.layer.presentationLayer.position.x, self.movingLabel.layer.presentationLayer.position.y - 50, 44, 44);
    [menu showMenuFromView:self.view rect:targetRect];
}

- (void)reportAction:(id)sender {
    
}

-(void)click:(UITapGestureRecognizer *)tapGesture {
    CGPoint touchPoint = [tapGesture locationInView:self.view];
    if ([self.movingLabel.layer.presentationLayer hitTest:touchPoint]) {
        NSLog(@"presentationLayer");
        if (self.movingLabel.layer.speed == 0) {
            [self startAnimating];
        } else {
            [self stopAnimating];
            [self addMenu];
            NSLog(@"position = %@",NSStringFromCGPoint(self.movingLabel.layer.presentationLayer.position));


        }
    }
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
    moveLayerAnimation.values = @[[NSValue valueWithCGPoint:CGPointMake(50, 150)],
                                  [NSValue valueWithCGPoint:CGPointMake([UIScreen mainScreen].bounds.size.width - self.movingLabel.layer.bounds.size.width/2, 150)]];
    moveLayerAnimation.duration = 2.0;
    moveLayerAnimation.autoreverses = YES;
    moveLayerAnimation.removedOnCompletion = NO;
    moveLayerAnimation.repeatCount = INFINITY;
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

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(reportAction:)) {
        return YES;
    }
    return NO;
}

- (void)dealloc {
    [self.view removeGestureRecognizer:self.tapGesture];
    self.tapGesture = nil;
}

@end
