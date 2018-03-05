//
//  UIScrollViewExtensions.swift
//  SwiftRefresh
//
//  Created by Zsam on 2018/2/6.
//  Copyright © 2018年 Mzxer. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    func neverAdjustsInset(on controller: UIViewController) {
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }else {
            controller.automaticallyAdjustsScrollViewInsets = false
        }
    }
}
