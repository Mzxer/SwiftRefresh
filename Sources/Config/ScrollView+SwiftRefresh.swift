//
//  ScrollView+SwiftRefresh.swift
//  SwiftRefresh
//
//  Created by Zsam on 2018/1/28.
//  Copyright © 2018年 Mzxer. All rights reserved.
//

import UIKit


private var SwiftRefreshHeaderClassKey: Void?
private var SwiftRefreshFooterClassKey: Void?
private var SwiftRefreshHeaderClassKeyPath = "SwiftRefreshHeaderClass"
private var SwiftRefreshFooterClassKeyPath = "SwiftRefreshFooterClass"


extension SwiftRefresh where Base: UIScrollView {
    
    public typealias SwiftRefreshHeaderClass = UIView & SwiftRefreshHeaderType
    public typealias SwiftRefreshFooterClass = UIView & SwiftRefreshFooterType
    /// 下拉刷新控件
    public var header: SwiftRefreshHeaderClass?  {
        return objc_getAssociatedObject(base, &SwiftRefreshHeaderClassKey) as? SwiftRefreshHeaderClass
    }
    
    /// 上拉刷新控件
    public var footer: SwiftRefreshFooterClass? {
        return objc_getAssociatedObject(base, &SwiftRefreshFooterClassKey) as? SwiftRefreshFooterClass
    }
    
    public func set(header: SwiftRefreshHeaderClass){
        removeHeader()
        base.insertSubview(header, at: 0)
        base.setAssociatedObject(objc: header, for: &SwiftRefreshHeaderClassKey, with: SwiftRefreshHeaderClassKeyPath)
    }
    
    public func set(footer: SwiftRefreshFooterClass){
        removeFooter()
        base.insertSubview(footer, at: 0)
        base.setAssociatedObject(objc: footer, for: &SwiftRefreshFooterClassKey, with: SwiftRefreshFooterClassKeyPath)
    }
    
    public func removeHeader() {
        base.sr.header?.removeFromSuperview()
        base.setAssociatedObject(objc: nil, for: &SwiftRefreshHeaderClassKey, with: SwiftRefreshHeaderClassKeyPath)
    }
    
    public func removeFooter() {
        base.sr.footer?.removeFromSuperview()
        base.setAssociatedObject(objc: nil, for: &SwiftRefreshFooterClassKey, with: SwiftRefreshFooterClassKeyPath)
    }
}

extension UIScrollView {
    fileprivate func setAssociatedObject(objc: Any?, for key: UnsafeRawPointer, with keyPath: String) {
        self.willChangeValue(forKey: keyPath)
        objc_setAssociatedObject(self, key, objc, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.didChangeValue(forKey: keyPath)
    }
}

extension UIScrollView {

    public var totalDataCount: Int {
        var totalCount = 0
        if let tableView = self as? UITableView {
            for section in 0..<tableView.numberOfSections {
                totalCount += tableView.numberOfRows(inSection: section)
            }
        }
        
        if let collectionView = self as? UICollectionView  {
            for section in 0..<collectionView.numberOfSections {
                totalCount += collectionView.numberOfItems(inSection: section)
            }
        }
        return totalCount
    }
}

