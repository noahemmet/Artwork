//
//  Painting.swift
//  FingerPaint
//
//  Created by Noah Emmet on 5/16/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation
import Common

public struct Painting: ArtType, Codable, Hashable {
    
    public static let defaultSize = CGSize(width: 300, height: 400)
    public static let empty = Painting(strokes: [], size: .zero, backgroundColor: nil)
    
	public static func random(in frame: CGRect = .init(width: 400, height: 400), swatches: [Swatch], strokes: Range<Int> = 1..<5, curves: Range<Int> = 1..<5) -> Painting {
        let strokes: [Stroke] = strokes.map { _ in
            let kind = StrokePath.Kind.allCases.randomElement()!
            let points: [CGPoint]
            switch kind {
            case .curved:
                points = CGPoint.randomPoints(in: frame, range: 0 ..< 20)
            case .shape:
                points = CGPoint.randomPoints(in: frame, range: 0 ..< 20)
            case .single:
                points = CGPoint.randomPoints(in: frame, range: 0 ..< 1)
            case .straight:
                points = CGPoint.randomPoints(in: frame, range: 0 ..< 2)
            }
            let strokePath = StrokePath(kind: kind, points: points)
            let thickness = CGFloat.random(in: 1 ..< 10)
            let brush = Brush.fingerBrush(thickness: thickness)
            var swatch = swatches.randomElement()!
            swatch.color.randomize(within: 0.3)
            let stroke = Stroke(strokePath: strokePath, brush: brush, swatch: swatch)
            return stroke
        }
        let backgroundColor = swatches.randomElement()!.color
        let painting = Painting(strokes: strokes, size: frame.size, pictureFrame: PictureFrame.debug(), backgroundColor: backgroundColor)
        return painting
    }
	
    public var strokes: [Stroke]
    public var size: CGSize
    public var pictureFrame: PictureFrame
    public var backgroundColor: Color?
    
    public init(strokes: [Stroke], size: CGSize, pictureFrame: PictureFrame = .debug(), backgroundColor: Color?) {
        self.strokes = strokes
        self.size = size
        self.pictureFrame = pictureFrame
        self.backgroundColor = backgroundColor
    }
}

extension Painting: CustomDebugStringConvertible {
    public var debugDescription: String {
        return """
        Painting(strokes: \(strokes.count), size: \(size))
        """
    }
}
