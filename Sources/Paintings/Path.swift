//
//  Path.swift
//  Pathology
//
//  Created by Kyle Truscott on 3/2/16.
//  Copyright © 2016 keighl. All rights reserved.
//

import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

public struct Path: Codable, Hashable {
    var elements: [Element]
	
	public init() {
		elements = []
	}
	
    public func toJSONArray() -> [[String: Any]] {
        return elements.map { $0.toDictionary() }
    }
    
    public func toJSONData(options: JSONSerialization.WritingOptions) throws -> Data {
        let data = try JSONSerialization.data(withJSONObject: toJSONArray(), options: options)
        return data
    }
	
//	public func data() throws -> Data {
//		let path = self.toPath()
//		let data = try path.toJSONData(options: [])
//		return data
//	}
	
//	class func random(in frame: CGRect, curves curveRange: Range<Int>) -> CGPath {
//		let path = CGMutablePath()
//		let firstPoint = CGPoint.random(in: frame)
//		path.move(to: firstPoint)
//
//		let numCurves = Int.random(in: curveRange)
//		for _ in 0 ..< numCurves {
//			path.addQuadCurve(to: CGPoint.random(in: frame), control: CGPoint.random(in: frame))
//		}
//		return path
//	}
	
	mutating public func move(to point: CGPoint) {
		elements.append(Element(type: .moveToPoint, points: [point]))
	}
	
	mutating public func addLine(from p1: CGPoint, to p2: CGPoint) {
		// FIXME: "[Unknown process name] CGPathAddLineToPoint: no current point"
		elements.append(Element(type: .moveToPoint, points: [p1]))
		elements.append(Element(type: .addLineToPoint, points: [p1, p2]))
	}
	
	mutating public func addLines(from points: [CGPoint]) {
		for point in points {
			// FIXME: "[Unknown process name] CGPathAddLineToPoint: no current point"
			elements.append(Element(type: .moveToPoint, points: [points[0]]))
			elements.append(Element(type: .addLineToPoint, points: [point]))
		}
	}
	
	mutating public func addQuadCurve(to point: CGPoint) {
		elements.append(Element(type: .addQuadCurveToPoint, points: [point]))
	}
	
	mutating public func addCurve(to point: CGPoint, control1: CGPoint, control2: CGPoint) {
		elements.append(Element(type: .addCurveToPoint, points: [point, control1, control2]))
	}
	
	mutating public func closeSubpath() {
		elements.append(Element(type: .closeSubpath, points: []))
	}
	
	#if canImport(CoreGraphics)
    public func toCGPath() -> CGPath {
        let path = CGMutablePath()
        for el in elements {
            let endPoint = el.endPoint()
            let ctrl1 = el.ctrlPoint1()
            let ctrl2 = el.ctrlPoint2()
            
            switch el.type {
            case .moveToPoint:
                path.move(to: endPoint)
            case .addLineToPoint:
                path.addLine(to: endPoint)
            case .addQuadCurveToPoint:
                path.addQuadCurve(to: ctrl1, control: endPoint)
            case .addCurveToPoint:
                path.addCurve(to: endPoint, control1: ctrl1, control2: ctrl2)
//                path.addCurveToPoint(path, nil, ctrl1.x, ctrl1.y, ctrl2.x, ctrl2.y, endPoint.x, endPoint.y)
            case .closeSubpath:
                path.closeSubpath()
            case .invalid:
                break
            }
        }
        return path
    }
	#endif
}


extension Path {
    public init(data: Data) throws {
		let obj = try JSONSerialization.jsonObject(with: data, options: [])
		let arr = try (obj as? [[String: Any]]).unwrap()
		self.elements = try arr.map { try Element(dictionary: $0) }
    }
    
    public init(jsonArray: [[String: Any]]) throws {
		self.elements = try jsonArray.map { try Element(dictionary: $0) }
    }
}
