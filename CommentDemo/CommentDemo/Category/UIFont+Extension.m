//
//  UIFont+Extension.m
//  CommentDemo
//
//  Created by STzen on 2018/5/10.
//  Copyright © 2018年 hih-d-11371. All rights reserved.
//

#define IOS8_2 (SystemVersion >= 8.2f)
#define IOS9 (SystemVersion >= 9.0f)
#define SystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

#import "UIFont+Extension.h"

@implementation UIFont (Extension)

+ (UIFont *)customFontWithName:(NSString *)name size:(CGFloat)size {
    if (IOS9) {
        return [UIFont fontWithName:name size:size];
    } else {
        if (IOS8_2) {
            return [UIFont systemFontOfSize:size weight:UIFontWeightRegular];
        } else {
            return [UIFont systemFontOfSize:size];
        }
    }
}

@end
