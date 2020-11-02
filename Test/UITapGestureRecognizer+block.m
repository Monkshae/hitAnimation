//
//  UIControl+block.m
//  wespy
//
//  Created by pengjizong on 2020/2/9.
//  Copyright © 2020 wepie. All rights reserved.
//

#import "UITapGestureRecognizer+block.h"
#import <objc/runtime.h>

@implementation UITapGestureRecognizer (block)

static char *const kAction = "kAction";

- (void)setClickAction:(void (^)(UITapGestureRecognizer * _Nonnull))clickAction
{
    objc_setAssociatedObject(self, kAction, clickAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self removeTarget:self action:@selector(buttonClick:)];
    
    if (clickAction) {
        
        [self addTarget:self action:@selector(buttonClick:)];
    }
}

- (void (^)(UITapGestureRecognizer * _Nonnull))clickAction
{
    return objc_getAssociatedObject(self, kAction);
}

- (void)buttonClick:(UITapGestureRecognizer *)tap
{
    if (self.clickAction) {
        self.clickAction(tap);
    }
}

@end
