//
//  UIViewController+Swizzling.m
//  SwizzlingTestOC
//
//  Created by Linus on 16/3/25.
//  Copyright © 2016年 Linus. All rights reserved.
//

#import "UIViewController+Swizzling.h"
#import <objc/runtime.h>

@implementation UIViewController (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewDidAppear:);
        SEL swizzledSelector = @selector(swizzledViewDidAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddedMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        NSLog(@"%@",didAddedMethod?@"YES":@"NO");
        
        if (didAddedMethod) {
            class_replaceMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        }else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
    });
}

- (void)swizzledViewDidAppear:(BOOL)animated {
    [self swizzledViewDidAppear:animated];
    NSLog(@"View Controller: %@ did appear animated: %@", NSStringFromClass([self class]), animated?@"YES":@"NO");
}

@end
