//
//  SwiftRefreshFooter.swift
//  SwiftRefresh
//
//  Created by Zsam on 2018/2/4.
//  Copyright © 2018年 Mzxer. All rights reserved.
//

import UIKit

class SwiftRefreshFooter: SwiftRefreshBase, SwiftRefreshFooterType {
    public var ignoredScrollViewContentInsetBottom: CGFloat = 0

    override func prepare() {
        super.prepare()
        self.sr_height = SR.footerHeight
    }
}

extension SwiftRefreshFooter {
    
    func endRefreshing(hasMoreData: Bool) {
        
        if hasMoreData {
            self.state = .idle
        }else {
            self.state = .noMoreData
        }
    }
    
    func resetNoMoreData() {
        self.state = .idle
    }
}
