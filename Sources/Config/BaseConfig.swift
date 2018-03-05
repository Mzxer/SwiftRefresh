//
//  BaseConfig.swift
//  SwiftRefresh
//
//  Created by Zsam on 2018/2/2.
//  Copyright © 2018年 Mzxer. All rights reserved.
//

import Foundation

public struct SwiftRefresh<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}
public extension NSObjectProtocol {
    public var sr: SwiftRefresh<Self> {
        return SwiftRefresh(self)
    }
}
