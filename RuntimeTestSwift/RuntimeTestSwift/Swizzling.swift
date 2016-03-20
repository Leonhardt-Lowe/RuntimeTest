//
//  Swizzling.swift
//  RuntimeTestSwift
//
//  Created by Linus on 16/3/19.
//  Copyright © 2016年 Linus. All rights reserved.
//

import UIKit

extension UIViewController {
    override public static func initialize() {
        
        struct Static {
            static var token: dispatch_once_t = 0;
        }
        
        dispatch_once(&Static.token) {
            let originalSelector = Selector("viewDidAppear:")
            let swizzledSelector = Selector("swizzledViewDidAppear:")
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod:Bool = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            }else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
                
        }
    }
    
    func swizzledViewDidAppear(animated: Bool) {
        self.swizzledViewDidAppear(animated)
        
        print("View Controller: \(self) did appear animated: \(animated)")
    }

    
}