//
//  SwiftRefreshHeader.swift
//  SwiftRefresh
//
//  Created by Zsam on 2018/1/28.
//  Copyright © 2018年 Mzxer. All rights reserved.
//

import UIKit

class SwiftRefreshHeader: SwiftRefreshBase, SwiftRefreshHeaderType {

    public var ignoredScrollViewContentInsetTop: CGFloat = 0
    
    private var willShowOffsetY : CGFloat {
        return -scrollViewOriginalInset.top
    }
    private var didShowOffsetY : CGFloat {
        return -(self.sr_height + scrollViewOriginalInset.top)
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
        self.sr_height = SR.headerHeight
        self.sr_y = -(self.sr_height + ignoredScrollViewContentInsetTop)
    }
    
    override func scrollViewPanState(didChange change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewPanState(didChange: change)
    }
    
    override func scrollViewContentOffset(didChange change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffset(didChange: change)
    
        guard state != .refreshing else {
            guard let _ = self.window else { return }
            resetInsetForHoveringWhenRefreshing()
            return
        }
        
 
        let offsetY = scrollView.contentOffset.y
        let pullingPercent = -(offsetY - willShowOffsetY) / self.sr_height
        
        guard scrollView.isDragging else {
            switch state {
            case .pulling:   self.beginRefreshing()
            default:         self.pullingPercent = pullingPercent
            }
            return
        }
        
        switch offsetY {
        case -(CGFloat.greatestFiniteMagnitude) ..< didShowOffsetY:
            if self.state == .idle {
                self.state = .pulling
            }
        case didShowOffsetY ..< CGFloat.greatestFiniteMagnitude:
            if self.state == .pulling {
                self.state = .idle
            }
        default: break
        }
    }
    
    
    private func resetInsetForHoveringWhenRefreshing() {
        switch scrollView.contentOffset.y {
        case  -(CGFloat.greatestFiniteMagnitude) ..< willShowOffsetY:
            scrollView.contentInset.top =  scrollViewOriginalInset.top + self.sr_height
        default: break
        }
    }
}


extension SwiftRefreshHeader {
    
  
    
    public func endRefreshing() {
        self.state = .idle
    }
}

