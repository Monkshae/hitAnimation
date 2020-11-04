//
//  ViewController.m
//  Test
//
//  Created by Lee on 2020/6/28.
//  Copyright © 2020 Lee. All rights reserved.
//

#import "ViewController.h"
#import "DanmuMessageAnimationHelper.h"

@interface ViewController ()

@property (nonatomic, assign) CGPoint point;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)addMenuWihPoint:(CGPoint)point {
    UIMenuController *menu = [UIMenuController sharedMenuController];
    menu.arrowDirection = UIMenuControllerArrowDown;
    UIMenuItem *reportItem = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(reportAction:)];
    menu.menuItems = @[reportItem];
    CGRect targetRect = CGRectMake(point.x, point.y - 10, 44, 44);
    [menu showMenuFromView:self.view rect:targetRect];
}

- (void)reportAction:(id)sender {

}

- (IBAction)didButtonClicked:(UIButton *)sender {
    __weak typeof(self)weakSelf= self;
    [[DanmuMessageAnimationHelper sharedInstance] danmakuMessageAnimationWithMessage:@"" inContainer:self.view tapBlock:^(CGPoint point) {
//        weakSelf.point = point;
        [weakSelf addMenuWihPoint:point];
    }];
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
 
}

@end
