//
//  CAKeyframeAnimation+AnimationKey.m
//  Test
//
//  Created by Lee on 2020/11/2.
//  Copyright © 2020 Lee. All rights reserved.
//

#import "CAKeyframeAnimation+AnimationKey.h"
#import <objc/runtime.h>

@implementation CAKeyframeAnimation (AnimationKey)

- (NSString *)animationKey {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAnimationKey:(NSString *)animationKey {
    objc_setAssociatedObject(self, @selector(animationKey), animationKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
