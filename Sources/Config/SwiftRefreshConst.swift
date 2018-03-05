//
//  RefreshConst.swift
//  SwiftRefreshExample
//
//  Created by zsam on 16/7/7.
//  Copyright © 2016年 zsam. All rights reserved.
//

import UIKit

public typealias SRClosure = () -> Void


/// 刷新控件的状态
public enum SwiftRefreshState: String {
    case idle
    case pulling
    case willRefresh
    case refreshing
    case noMoreData
}


struct SR {
    
    static let headerHeight: CGFloat = 54
    static let footerHeight: CGFloat = 44
    static let animationDuration: TimeInterval = 0.25
    static let Font = UIFont.boldSystemFont(ofSize: 14)
    static let textColor = UIColor(red: 90 / 255, green: 90 / 255, blue: 90 / 255, alpha: 1)
    
//    public enum State: String {
//        case idle
//        case pulling
//        case willRefresh
//        case refreshing
//        case noMoreData
//    }
    
    struct KPath {
        static let contentOffset = "contentOffset"
        static let contentInset = "contentInset"
        static let contentSize = "contentSize"
        static let panState = "state"
        static let lastUpdatedTime = "RefreshHeaderLastUpdatedTimeKey"
    }
    
    struct HText {
        static let idle = "下拉可以刷新"
        static let pulling = "松开立即刷新"
        static let refreshing = "正在刷新数据中..."
    }
    
    struct AFText {
        static let idle = "点击或上拉加载更多"
        static let refreshing = "正在加载更多的数据..."
        static let noMoreData = "已经全部加载完毕"
    }
    
    struct BFText {
        static let idle = "点击或上拉加载更多"
        static let pulling = "松开立即加载更多"
        static let refreshing = "正在加载更多的数据..."
        static let noMoreData = "已经全部加载完毕"
    }
    
    static func bundleFile(_ fileName: String) -> String {
        return "SwiftRefresh.bundle/" + fileName
    }
    
    static func framWorkFile(_ fileName: String) -> String {
        return "Frameworks/SwiftRefresh.framework/SwiftRefresh.bundle/" + fileName
    }
    
}

func delay(_ timeInterval: TimeInterval, task: SRClosure?) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() +
                                  Double(Int64(timeInterval * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
                                  execute: {
        task?()
    })
}





