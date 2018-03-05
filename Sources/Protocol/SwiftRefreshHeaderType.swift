//
//  SwiftRefreshHeaderType.swift
//  SwiftRefresh
//
//  Created by Zsam on 2018/1/28.
//  Copyright © 2018年 Mzxer. All rights reserved.
//

import UIKit



public protocol SwiftRefreshBaseType {
    func beginRefreshing()
    
//    func changeOriginalInset()
}

public protocol SwiftRefreshHeaderType: SwiftRefreshBaseType {
    func endRefreshing()
    var ignoredScrollViewContentInsetTop: CGFloat {get set}
}


public protocol SwiftRefreshFooterType: SwiftRefreshBaseType {
    var ignoredScrollViewContentInsetBottom: CGFloat {get set}
    func resetNoMoreData()
    func endRefreshing(hasMoreData: Bool)
}


public protocol SwiftRefreshDisplayViewType {
    func changeState(from fromState: SwiftRefreshState, to toState: SwiftRefreshState)
}
