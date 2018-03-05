//
//  UIView+SwiftRefresh.swift
//  SwiftRefresh
//
//  Created by Zsam on 2018/2/2.
//  Copyright © 2018年 Mzxer. All rights reserved.
//

import UIKit

extension  UIView {
    var sr_x: CGFloat {
        get {return frame.origin.x}
        set {frame.origin.x = newValue}
    }
    
    var sr_y: CGFloat {
        get {return frame.origin.y}
        set {frame.origin.y = newValue}
    }
    
    var sr_height: CGFloat {
        get {return frame.size.height}
        set {frame.size.height = newValue}
    }
    
    var sr_width: CGFloat {
        get {return frame.size.width}
        set {frame.size.width = newValue}
    }
}
