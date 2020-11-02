//
//  UIControl+block.h
//  wespy
//
//  Created by pengjizong on 2020/2/9.
//  Copyright © 2020 wepie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITapGestureRecognizer (block)

@property (nonatomic, copy) void(^clickAction)(UITapGestureRecognizer *tap);

@end

NS_ASSUME_NONNULL_END
