//
//  UIView+UIViewController.m
//  05 Responder
//
//  Created by wangxinkai on 14-8-23.
//  Copyright (c) 2014年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "UIView+UIViewController.h"

@implementation UIView (UIViewController)

- (UIViewController *)viewController {
    
    //通过响应者链，取得此视图所在的视图控制器
    UIResponder *next = self.nextResponder;
    do {
        
        //判断响应者对象是否是视图控制器类型
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
        
    }while(next != nil);
    
    return nil;
}

@end
