//
//  ToastPlugin.m
//  ToastPlugin
//
//  Created by cyzf on 16/12/22.
//  Copyright © 2016年 cyzf. All rights reserved.
//

#import "ToastPlugin.h"
#import <QuartzCore/QuartzCore.h>

@interface ToastPlugin(private)

- (id)initWithText:(NSString *)text_;
- (void)setDuration:(CGFloat)duration_;

- (void)dismissToast;
- (void)toastTaped:(UIButton *)sender_;

- (void)showAnimation;
- (void)hideAnimation;

- (void)show;
- (void)showFromTopOffset:(CGFloat)topOffset_;
- (void)showFromBottomOffset:(CGFloat)bottomOffset_;

@end


@implementation ToastPlugin
RCT_EXPORT_MODULE(ToastPlugin);

//私有接口

- (id)initWithText:(NSString *)text_
{
    self = [super init];
    if (self) {
        text = [text_ copy];
        //计算输入的文本大小
        UIFont *font = [UIFont boldSystemFontOfSize:14];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        CGRect textRect = [text boundingRectWithSize:CGSizeMake(280, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSParagraphStyleAttributeName:paragraphStyle.copy,NSFontAttributeName:font} context:nil];
        CGSize textSize = textRect.size;
        
        //创建label
        UILabel *textLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, textSize.width+12, textSize.height+12)];
        textLable.backgroundColor = [UIColor clearColor];
        textLable.textColor = [UIColor whiteColor];
        textLable.textAlignment = NSTextAlignmentCenter;
        textLable.font = font;
        textLable.text = text;
        textLable.numberOfLines = 0;
        
        //创建容器控件
        contentView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, textLable.frame.size.width, textLable.frame.size.height)];
        contentView.layer.cornerRadius = 5.0f;
        contentView.layer.borderWidth = 1.0f;
        contentView.layer.borderColor=[[UIColor grayColor]colorWithAlphaComponent:0.5].CGColor;
        contentView.backgroundColor = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.75f];
        [contentView addSubview:textLable];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [contentView addTarget:self action:@selector(toastTaped:) forControlEvents:UIControlEventTouchDown];
        contentView.alpha = 0.0f;
        //[textLable release];
        
        duration = DEFAULT_DISPLAY_DURATION;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
        
    }
    return self;
}
/*
 手机屏幕转向（竖向和横向相互转化时，触发事件）
 */
- (void)deviceOrientationDidChanged:(NSNotification *)notify_
{
    //隐藏动画效果
    [self hideAnimation];
}

- (void)setDuration:(CGFloat)duration_
{
    duration = duration_;
}

- (void)dismissToast
{
    [contentView removeFromSuperview];
}
- (void)toastTaped:(UIButton *)sender_
{
    [self hideAnimation];
}

- (void)showAnimation
{
    [UIView beginAnimations:@"show" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3];
    contentView.alpha = 1.0f;
    [UIView commitAnimations];
}
- (void)hideAnimation
{
    [UIView beginAnimations:@"hide" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dismissToast)];
    [UIView setAnimationDuration:0.3];
    contentView.alpha = 0.0f;
    [UIView commitAnimations];
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    contentView.center = window.center;
    [window addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}
- (void)showFromTopOffset:(CGFloat)topOffset_
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    contentView.center = CGPointMake(window.center.x, topOffset_+contentView.frame.size.height/2);
    [window addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation)withObject:nil afterDelay:duration];
}
- (void)showFromBottomOffset:(CGFloat)bottomOffset_
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    contentView.center = CGPointMake(window.center.x, window.frame.size.height-(bottomOffset_+contentView.frame.size.height/2));
    [window addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}

//公共接口
+ (void)showWithText:(NSString *)text_
{
    [ToastPlugin showWithText:text_ duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)showWithText:(NSString *)text_ duration:(CGFloat)duration_
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ToastPlugin *toast = [[ToastPlugin alloc] initWithText:text_];
        [toast setDuration:duration_];
        [toast show];
    });
}

+ (void)showWithText:(NSString *)text_ topOffset:(CGFloat)topOffset_
{
    [ToastPlugin showWithText:text_ topOffset:topOffset_ duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)showWithText:(NSString *)text_ topOffset:(CGFloat)topOffset_ duration:(CGFloat)duration_
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ToastPlugin *toast = [[ToastPlugin alloc] initWithText:text_];
        [toast setDuration:duration_];
        [toast showFromTopOffset:topOffset_];
    });
}

+ (void)showWithText:(NSString *)text_ bottomOffset:(CGFloat)bottomOffset
{
    [ToastPlugin showWithText:text_ bottomOffset:bottomOffset duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)showWithText:(NSString *)text_ bottomOffset:(CGFloat)bottomOffset_ duration:(CGFloat)duration
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ToastPlugin *toast = [[ToastPlugin alloc] initWithText:text_];
        [toast setDuration:duration];
        [toast showFromBottomOffset:bottomOffset_];
    });
}

//React Native 调用的js方法
RCT_EXPORT_METHOD(show: (NSDictionary *)options)
{
    NSString *text_ = options[@"message"];
    if (!text_) {
        text_ = @"";
    }
    CGFloat duration_ = options[@"duration"]?[options[@"duration"] floatValue]:DEFAULT_DISPLAY_DURATION;
    if (duration_ > 3.5f) {
        duration_ = 3.5f;
    }
    NSString *location = options[@"location"]?:@"bottom";
    if([location isEqualToString:@"center"]){
        [ToastPlugin showWithText:text_ duration:duration_];
    }else if([location isEqualToString:@"top"]){
        [ToastPlugin showWithText:text_ topOffset:50 duration:duration_];
    }else{
        [ToastPlugin showWithText:text_ bottomOffset:50 duration:duration_];
    }
}


@end


