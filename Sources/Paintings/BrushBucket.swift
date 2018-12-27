//
//  BrushBucket.swift
//  FingerPaint
//
//  Created by Noah Emmet on 5/7/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public struct BrushBucket {
    public static func debug() -> BrushBucket {
        let pencils = (1..<10).map { Brush.fingerBrush(thickness: CGFloat($0 * 4)) }
        return BrushBucket(brushes: pencils)
    }
    public var brushes: [Brush]
    public var maxBrushes: Int?

    public init(brushes: [Brush], maxBrushes: Int? = nil) {
        self.brushes = brushes
        self.maxBrushes = maxBrushes
    }
}
