//
//  Stroke.swift
//  FingerPaint
//
//  Created by Noah Emmet on 5/16/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation
import Common

public struct Stroke: Codable, Hashable {
    public var strokePath: StrokePath
    public var brush: Brush
    public var swatch: Swatch
    
    public init(strokePath: StrokePath, brush: Brush, swatch: Swatch) {
        self.strokePath = strokePath
        self.brush = brush
        self.swatch = swatch
    }
	
	#if canImport(CoreGraphics)
    public var path: Path {
        switch self.strokePath {
        case .curved(let curved):
            return curved.path
        case .straight(let straight):
            var path = Path()
			path.addLine(from: straight.p1, to: straight.p2)
            return path
        case .shape(let shape):
			var path = Path()
            path.addLines(from: shape.points)
            return path
        case .single(let single):
            var path = Path()
            let centerRect = CGRect(center: single.point, size: CGSize(dimension: brush.thickness))
//            path.addEllipse(in: centerRect)
			path.addLine(from: single.point, to: single.point) // ??
            return path
        }
    }
	#endif
}

public enum StrokePathType: String, Codable, CaseIterable {
    case curved
    case straight
    case shape
    case single
    public init(_ strokePath: StrokePath) {
        switch strokePath {
        case .curved:
            self = .curved
        case .straight:
            self = .straight
        case .shape:
            self = .shape
        case .single:
            self = .single
        }
    }
}

public protocol StrokePathProtocol: Codable { }

public enum StrokePath: Hashable {
    
    case curved(Curved)
    case straight(Straight)
    case shape(Shape)
    case single(Single)
    
    public struct Curved: Codable, Hashable, StrokePathProtocol { public let path: Path }
    public struct Straight: Codable, Hashable, StrokePathProtocol { public let p1, p2: CGPoint }
    public struct Shape: Codable, Hashable, StrokePathProtocol { public let points: [CGPoint] }
    public struct Single: Codable, Hashable, StrokePathProtocol { public let point: CGPoint }
    
    public init(type strokePathType: StrokePathType, points: [CGPoint]) {
        switch strokePathType {
        case .curved:
            let path = Path(catmullRomPoints: points, closed: false, alpha: 1.0)
			self = .curved(.init(path: path))
        case .straight:
            assert(points.count == 2)
            self = .straight(.init(p1: points[0], p2: points[1]))
        case .shape:
            self = .shape(.init(points: points))
        case .single:
            assert(points.count == 1)
            self = .single(.init(point: points[0]))
        }
    }
    
    public init(type strokePathType: StrokePathType, touchPoints: [TouchPoint]) {
        let points = touchPoints.cgPoints
        self.init(type: strokePathType, points: points)
    }
    
    public var strokePathProtocol: StrokePathProtocol {
        switch self {
        case .curved(let curved): return curved
        case .straight(let straight): return straight
        case .shape(let shape): return shape
        case .single(let single): return single
        }
    }
}

extension StrokePath: Codable {
    // MARK: Codable
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let base: StrokePathType = try container.decode(StrokePathType.self, forKey: .strokePathType)
        
        switch base {
        case .curved:
            let data: Data = try container.decode(Data.self, forKey: .curved)
            let path = try Path(data: data)
			self = .curved(.init(path: path))
        case .straight:
            let points: [CGPoint] = try container.decode([CGPoint].self, forKey: .straight)
            self = .straight(.init(p1: points[0], p2: points[1]))
        case .shape:
            let points: [CGPoint] = try container.decode([CGPoint].self, forKey: .shape)
            self = .shape(.init(points: points))
        case .single:
            let dict = try container.decode([String: [CGFloat]].self, forKey: .single)
            let point = try dict["point"].unwrap()
            let x = point[0]
            let y = point[1]
            let cgPoint = CGPoint(x: x, y: y)
            self = .single(.init(point: cgPoint))            
//                ▿ 1 element
//                    ▿ 0 : 2 elements
//            - key : "point"
//            ▿ value : 2 elements
//            - 0 : 349.8986552313961
//            - 1 : 71.83152859903785

//            let point: CGPoint = try container.decode(CGPoint.self, forKey: .single)
//            self = .single(.init(point: point))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(StrokePathType(self), forKey: .strokePathType)
        switch self {
        case .curved(let curved):
            let data = try curved.path.toJSONData(options: [])
            try container.encode(data, forKey: .curved)
        case .straight(let straight):
            let points = [straight.p1, straight.p2]
            try container.encode(points, forKey: .straight)
        case .shape(let shape):
            try container.encode(shape.points, forKey: .shape)
        case .single(let single):
            try container.encode(single, forKey: .single)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case strokePathType
        case curved
        case straight
        case shape
        case single
    }
}
