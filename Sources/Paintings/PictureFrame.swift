//
//  PictureFrame.swift
//  Artwork
//
//  Created by Noah Emmet on 11/11/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif
import Common

public struct PictureFrame: Codable, Hashable {
    public static func debug() -> PictureFrame { return PictureFrame(ratio: .oneToOne, border: .init())}
    
    public var ratio: Ratio
    public var border: Border?

    public init(ratio: Ratio, border: Border?) {
        self.ratio = ratio
        self.border = border
    }
}

extension PictureFrame {
    public struct Border: Codable, Hashable {
        public var thickness: CGFloat
        public var color: Color

        public init(thickness: CGFloat = 2, color: Color = .black) {
            self.thickness = thickness
            self.color = color
        }
    }
}
