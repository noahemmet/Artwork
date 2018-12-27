//
//  Brush.swift
//  FingerPaint
//
//  Created by Noah Emmet on 5/7/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public struct Brush: Codable, Hashable {
    public var name: String
    public var summary: String
    public var brushTip: BrushTip
    public var thickness: CGFloat

    public init(name: String, summary: String, brushTip: BrushTip, thickness: CGFloat) {
        self.name = name
        self.summary = summary
        self.brushTip = brushTip
        self.thickness = thickness
    }
}

public enum BrushTip: String, Codable, Hashable, CaseIterable {
    case finger
}

// MARK: Brush Types

public extension Brush {
    static func fingerBrush(thickness: CGFloat) -> Brush {
      return Brush(name: "Finger", summary: "Not necessarily yours.", brushTip: .finger, thickness: thickness)  
    } 
}
