//
//  SwiftRefreshBase.swift
//  SwiftRefresh
//
//  Created by Zsam on 2018/1/28.
//  Copyright © 2018年 Mzxer. All rights reserved.
//

import UIKit


open class SwiftRefreshBase: UIView, SwiftRefreshBaseType {
   
    var refreshingHandler: SRClosure?
    var state: SwiftRefreshState = .idle {
        willSet {
            let oldState = self.state
            guard newValue != oldState else { return }
            displayView?.changeState(from: oldState, to: newValue)
        }
    }
    var panGR: UIPanGestureRecognizer? {
        return scrollView?.panGestureRecognizer
    }
    var pullingPercent: CGFloat = 0
    var scrollViewOriginalInset: UIEdgeInsets = .zero
    
    weak var scrollView: UIScrollView!
    weak var displayView: (UIView & SwiftRefreshDisplayViewType)?
    // MARK: - initialize
    override public init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    public convenience init(refreshingHandler: @escaping SRClosure) {
        self.init(frame: .zero)
        self.refreshingHandler = refreshingHandler
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.sr_width = superview?.sr_width ?? 0
        displayView?.frame = self.bounds
    }
    
    //MARK:- left for subclass override
    func prepare() {}
    // invoke when scrollView's contentOffset change
    func scrollViewContentOffset(didChange change: [NSKeyValueChangeKey : Any]?){}
    // invoke when scrollView's contentSize change
    func scrollViewContentSize(didChange change: [NSKeyValueChangeKey : Any]?){}
    // invoke when scrollView's contentInset change
    func scrollViewContentInset(didChange change: [NSKeyValueChangeKey : Any]?){}
    // invoke when scrollView's pan state change
    func scrollViewPanState(didChange change: [NSKeyValueChangeKey : Any]?){}

    
    deinit {
        removeObservers()
    }
}


extension SwiftRefreshBase {
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        removeObservers()
        guard let newSV = newSuperview else {
            debugPrint("superview is nil")
            return
        }
        guard let newSuperview = newSV as? UIScrollView else {
            fatalError("superview should be UIScrollView")
        }
        func defaultSetUp() {
            self.sr_x = 0
            newSuperview.alwaysBounceVertical = true
            scrollViewOriginalInset = newSuperview.contentInset
            scrollView = newSuperview
        }
        defaultSetUp()
        addObservers()
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        // provice the method beginRefreshing being invoked before the view show
        if state == .willRefresh {
            state = .refreshing
        }
    }
}




//MARK:- KVO
extension SwiftRefreshBase {
    
    func addObservers() {
        let options:NSKeyValueObservingOptions = [.new, .old]
        scrollView?.addObserver(self, forKeyPath: SR.KPath.contentOffset, options: options, context: nil)
        scrollView?.addObserver(self, forKeyPath: SR.KPath.contentInset, options: options, context: nil)
        scrollView?.addObserver(self, forKeyPath: SR.KPath.contentSize, options: options, context: nil)
        panGR?.addObserver(self, forKeyPath: SR.KPath.panState, options: options, context: nil)
    }
    
    fileprivate func removeObservers() {
        scrollView?.removeObserver(self, forKeyPath: SR.KPath.contentOffset)
        scrollView?.removeObserver(self, forKeyPath: SR.KPath.contentInset)
        scrollView?.removeObserver(self, forKeyPath: SR.KPath.contentSize)
        panGR?.removeObserver(self, forKeyPath:  SR.KPath.panState)
    }
    
    open override func observeValue(forKeyPath keyPath: String?,
                                    of object: Any?,
                                    change: [NSKeyValueChangeKey : Any]?,
                                    context: UnsafeMutableRawPointer?) {
//        guard self.isUserInteractionEnabled else { return }
        
        guard let keyPath = keyPath else { return }
        switch keyPath {
        case SR.KPath.contentSize: scrollViewContentSize(didChange: change )
        case SR.KPath.contentOffset: scrollViewContentOffset(didChange: change)
        case SR.KPath.contentInset: scrollViewContentSize(didChange: change)
        case SR.KPath.panState: scrollViewPanState(didChange: change)
        default: break
        }
    }
}
//MARK:- Option Method
extension SwiftRefreshBase {
    public var isRefreshing: Bool {
        return state == .refreshing || state == .willRefresh
    }
    
    public func beginRefreshing() {
        UIView.animate(withDuration: SR.animationDuration) {
            self.alpha = 1.0
        }
        pullingPercent = 1.0
        guard self.window == nil else {
            state = .refreshing
            return
        }
        guard state != .refreshing else { return }
        state = .willRefresh
        setNeedsDisplay()
    }
    
    public func setDisplayView<V: UIView & SwiftRefreshDisplayViewType>(view: V) {
        self.subviews.forEach { $0.removeFromSuperview()}
        displayView = view
        self.addSubview(view)
        self.setNeedsLayout()
    }
}
