//
//  ToastPlugin.h
//  ToastPlugin
//
//  Created by cyzf on 16/12/22.
//  Copyright © 2016年 cyzf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import "RCTBridgeModule.h"

#define DEFAULT_DISPLAY_DURATION 2.0f

@interface ToastPlugin : NSObject

{
    //成员变量
    NSString *text;
    UIButton *contentView;
    CGFloat duration;
}

+ (void)showWithText:(NSString *)text_;

+ (void)showWithText:(NSString *)text_ duration:(CGFloat)duration_;

+ (void)showWithText:(NSString *)text_ topOffset:(CGFloat)topOffset_;

+ (void)showWithText:(NSString *)text_ topOffset:(CGFloat)topOffset_ duration:(CGFloat)duration_;

+ (void)showWithText:(NSString *)text_ bottomOffset:(CGFloat)bottomOffset;

+ (void)showWithText:(NSString *)text_ bottomOffset:(CGFloat)bottomOffset_ duration:(CGFloat)duration;

@end
