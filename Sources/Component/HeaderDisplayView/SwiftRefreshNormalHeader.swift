//
//  SwiftRefreshNormalHeader.swift
//  SwiftRefresh
//
//  Created by Zsam on 2018/2/4.
//  Copyright © 2018年 Mzxer. All rights reserved.
//

import UIKit

class SwiftRefreshNormalHeader: SwiftRefreshHeader {
    override func prepare() {
        super.prepare()
        let displayView = NormalDisplayView()
        self.setDisplayView(view: displayView)
    }
}


class SwiftRefreshNormalFooter: SwiftRefreshAutoFooter {
    override func prepare() {
        super.prepare()
        let displayView = NormalDisplayView()
        self.setDisplayView(view: displayView)
    }
}
