//
//  Painting.swift
//  FingerPaint
//
//  Created by Noah Emmet on 5/16/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif
import Common

public struct Painting: ArtType, Codable, Hashable {
    
	public static let empty = Painting(frame: .zero, strokes: [], backgroundColor: nil)
    
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
		let painting = Painting(frame: frame, strokes: strokes, pictureFrame: PictureFrame.debug(), backgroundColor: backgroundColor)
        return painting
    }
	
	public var frame: CGRect
    public var strokes: [Stroke]
    public var pictureFrame: PictureFrame
    public var backgroundColor: Color?
    
    public init(frame: CGRect, strokes: [Stroke],  pictureFrame: PictureFrame = .debug(), backgroundColor: Color?) {
		self.frame = frame
        self.strokes = strokes
        self.pictureFrame = pictureFrame
        self.backgroundColor = backgroundColor
    }
	
	public var boundingBox: CGRect {
		let points = strokes.flatMap { $0.path.elements.flatMap { e in e.points }}
		let boundingBox = points.boundingBox
		return boundingBox
	}
}

extension Painting: CustomDebugStringConvertible {
    public var debugDescription: String {
        return """
        Painting(strokes: \(strokes.count), bounds: \(boundingBox))
        """
    }
}
