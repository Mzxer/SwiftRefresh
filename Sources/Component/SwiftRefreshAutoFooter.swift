//
//  SwiftRefreshAutoFooter.swift
//  SwiftRefresh
//
//  Created by Zsam on 2018/2/4.
//  Copyright © 2018年 Mzxer. All rights reserved.
//

import UIKit

class SwiftRefreshAutoFooter: SwiftRefreshFooter {

    public var isRefreshAutomatically: Bool = true
    public var autoRefreshTriggerPercent: CGFloat = 1.0
    
    
    private var isContentOverContainer: Bool {
        return scrollView.contentInset.top + scrollView.contentSize.height > scrollView.sr_height
    }
    private var willShowOffsetY : CGFloat {
        return scrollView.contentSize.height  + self.scrollView.contentInset.bottom - scrollView.sr_height
    }
    private var didShowOffsetY : CGFloat {
        return willShowOffsetY + self.sr_height
    }
    private var triggerOffsetY : CGFloat {
        return willShowOffsetY  - self.sr_height + (self.sr_height * autoRefreshTriggerPercent)

    }
    
    override var state: SwiftRefreshState {
        willSet {
            let oldState = self.state
            guard newValue != oldState else { return }
            super.state = newValue
            switch newValue {
            case .refreshing:
                delay(0.5, task: {
                    self.refreshingHandler?()
                })
            default: break
            }
        }
    }
    
    override func prepare() {
        super.prepare()
    }
    
    // handle when panGR end
    override func scrollViewPanState(didChange change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewPanState(didChange: change)
        guard state == .idle else { return }
        guard scrollView.panGestureRecognizer.state == .ended else { return }
        if isContentOverContainer {
            guard scrollView.contentOffset.y >=
                scrollView.contentSize.height +
                scrollView.contentInset.bottom -
                scrollView.sr_height else { return }
        }else {
            guard  scrollView.contentOffset.y >= -scrollView.contentInset.top else { return }
        }
        beginRefreshing()
    }
    
    override func scrollViewContentSize(didChange change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSize(didChange: change)
        
        self.sr_y = scrollView.contentSize.height 
    }
    
    override func scrollViewContentOffset(didChange change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffset(didChange: change)
        guard state == .idle && isRefreshAutomatically else { return }
        guard isContentOverContainer else { return }
        guard scrollView.contentOffset.y >= triggerOffsetY else { return }
    
        if let old = change?[.oldKey] as? CGPoint,
           let new = change?[.newKey] as? CGPoint,
           new.y <= old.y {return}
        
        beginRefreshing()
    }
}

extension SwiftRefreshAutoFooter {
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if let _ = newSuperview {
            guard !self.isHidden else { return }
            self.scrollView.contentInset.bottom += self.sr_height
        }else {
            guard !self.isHidden else { return }
            self.scrollView.contentInset.bottom -= self.sr_height
        }
    }
}


