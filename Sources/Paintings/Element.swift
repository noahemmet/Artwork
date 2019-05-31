//
//  Element.swift
//  Pathology
//
//  Created by Kyle Truscott on 3/2/16.
//  Copyright © 2016 keighl. All rights reserved.
//

import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif
import Common

public extension Path {
	enum ElementType: String, Codable, Hashable, CaseIterable {
        case invalid
        case moveToPoint
        case addLineToPoint
        case addQuadCurveToPoint
        case addCurveToPoint
        case closeSubpath
    }
    
	struct Element: Codable, Hashable {
        public var type: ElementType
        public var points: [CGPoint]
		
		public init(type: ElementType, points: [CGPoint]) {
			self.type = type
			self.points = points
		}
        
        public func toDictionary() -> [String: Any] {
            return [
                "type": type.rawValue,
                "points": points.map { return [$0.x, $0.y] }
            ]
        }
        
        public func toJSONData(options: JSONSerialization.WritingOptions) throws -> Data {
            let data = try JSONSerialization.data(withJSONObject: toDictionary(), options: options)
            return data
        }
        
        public func endPoint() -> CGPoint {
            if points.count >= 1 {
                return points[0]
            }
            return .zero
        }
        
        public func ctrlPoint1() -> CGPoint {
            if points.count >= 2 {
                return points[1]
            }
            return .zero
        }
        
        public func ctrlPoint2() -> CGPoint {
            if points.count >= 3 {
                return points[2]
            }
            return .zero
        }
    }
}

extension Path.Element {
    public init(dictionary: [String: Any]) throws {
		let type = try (dictionary["type"] as? String).unwrap(orThrow: "Can't find \"type\" in dictionary: \(dictionary)")
		self.type = try Path.ElementType(rawValue: type).unwrap()
		let pointJSONs = try (dictionary["points"] as? [[Any]]).unwrap(orThrow: "no points key")
		let numberedPoints: [[CGFloat]] = try pointJSONs.map { pointJSON in
			return try pointJSON.map { x in
				if let int = x as? Int {
					return CGFloat(int)
				} else if let double = x as? Double {
					return CGFloat(double)
				} else if let float = x as? Float {
					return CGFloat(float)
				} else if let float = x as? CGFloat {
					return float
				} else {
					throw ThrownError("invalid point: \(x)")
				}
			}
		}
//		let points = try (pointJSONs as? [[CGFloat]]).unwrap(orThrow: "Points are of type: \(firstPoint.self)")
		self.points = numberedPoints.map { CGPoint(x: $0[0], y: $0[1]) }
    }
}
