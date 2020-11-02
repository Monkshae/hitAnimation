//
//  DanmuMessageAnimationHelper.h
//  Test
//
//  Created by Lee on 2020/11/2.
//  Copyright © 2020 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DanmuMessageAnimationHelper : NSObject

+ (instancetype)sharedInstance;

- (void)danmakuMessageAnimationWithMessage:(NSString *)message inContainer:(UIView *)container tapBlock:(void (^)(CGPoint point))tapBlock;

@end

NS_ASSUME_NONNULL_END
