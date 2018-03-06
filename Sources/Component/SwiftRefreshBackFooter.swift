//
//  SwiftRefreshBackFooter.swift
//  SwiftRefresh
//
//  Created by Zsam on 2018/2/4.
//  Copyright © 2018年 Mzxer. All rights reserved.
//

import UIKit

class SwiftRefreshBackFooter: SwiftRefreshFooter {
    
    public var isRefreshAutomatically: Bool = true
    public var autoRefreshTriggerPercent: CGFloat = 0.1
    
    private var isOverScreen: Bool {
        return (scrollView.contentSize.height + ignoredScrollViewContentInsetBottom) > scrollView.sr_height
    }
    private var willShowOffsetY : CGFloat {
        return scrollView.contentSize.height  + self.ignoredScrollViewContentInsetBottom - scrollView.sr_height
    }
    private var didShowOffsetY : CGFloat {
        return scrollView.contentSize.height  + self.ignoredScrollViewContentInsetBottom + self.sr_height - scrollView.sr_height
    }
    
    
    override var state: SwiftRefreshState {
        willSet {
            let oldState = self.state
            guard newValue != oldState else { return }
            super.state = newValue
            switch newValue {
            case .idle:
                guard oldState == .refreshing else { break }
                UIView.animate(withDuration: SR.animationDuration, animations: {
                    self.scrollView.contentInset = self.scrollViewOriginalInset
                }, completion: nil)
                
            case .refreshing:
                DispatchQueue.main.async {
                    UIView.animate(withDuration: SR.animationDuration, animations: {
                        self.scrollView.contentOffset.y = self.didShowOffsetY
                    }){(finish) in
                        self.refreshingHandler?()
                    }
                }
            default: break
            }
        }
    }
    
    override func prepare() {
        super.prepare()
        
    }
    
    override func scrollViewPanState(didChange change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewPanState(didChange: change)
    }
    
    override func scrollViewContentSize(didChange change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSize(didChange: change)
        self.sr_y = scrollView.contentSize.height + ignoredScrollViewContentInsetBottom
    }
    
    override func scrollViewContentInset(didChange change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentInset(didChange: change)
    }
    
    override func scrollViewContentOffset(didChange change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffset(didChange: change)
        guard let _ = self.window else { return }
        guard self.state != .refreshing else {
            resetInsetForHoveringWhenRefreshing()
            return
        }
        guard isRefreshAutomatically else {
            handleWhenNonautomatical()
            return
        }
        guard isOverScreen else {
            handleWhenNonautomatical()
            return
        }
        
        let trigerOffsetY = willShowOffsetY + (didShowOffsetY - willShowOffsetY) * autoRefreshTriggerPercent
        if scrollView.contentOffset.y > trigerOffsetY {
            self.beginRefreshing()
        }
    }
    
    private func handleWhenNonautomatical() {
        let offsetY = scrollView.contentOffset.y
        let pullingPercent = -(offsetY - willShowOffsetY) / self.sr_height
        
        guard scrollView.isDragging else {
            switch state {
            case .pulling:   self.beginRefreshing()
            default:  self.pullingPercent = pullingPercent
            }
            return
        }
        
        switch offsetY {
        case didShowOffsetY ..< CGFloat.greatestFiniteMagnitude:
            if self.state == .idle {
                self.state = .pulling
            }
        case   -(CGFloat.greatestFiniteMagnitude) ..< didShowOffsetY:
            if self.state == .pulling {
                self.state = .idle
            }
        default: break
        }
    }
    
    private func resetInsetForHoveringWhenRefreshing() {
        switch scrollView.contentOffset.y {
        case willShowOffsetY ..< CGFloat.greatestFiniteMagnitude:
            scrollView.contentInset.bottom = self.ignoredScrollViewContentInsetBottom + self.sr_height
        default: break
        }
    }
}

extension SwiftRefreshBackFooter {
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard self.isHidden else { return }
    }
}


extension SwiftRefreshBackFooter {
    
    public func adjust(height: CGFloat) {
        let oldHeight = self.sr_height
        let offset = height - oldHeight
        self.scrollView.contentInset.bottom += offset
        self.sr_y = scrollView.contentSize.height
    }
    
    func resetY() {
        self.sr_y = scrollView.contentSize.height + ignoredScrollViewContentInsetBottom
    }
}

