//
//  Path+CatmullRom.swift
//  Common
//
//  Created by Noah Emmet on 12/5/18.
//

import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

public extension Path {
	init(catmullRomPoints points: [CGPoint], closed: Bool, alpha: CGFloat) {
		self.init()
		
		guard points.count >= 4 else {
			if points.count > 0 {
				move(to: points[0])
				for point in points.dropFirst(1) {
					move(to: point)
				}
			} else {
				print("no points")
			}
			return
		}
		
		let startIndex = closed ? 0 : 1
		let endIndex = closed ? points.count : points.count - 2
		
		for i in startIndex..<endIndex {
			let p0 = points[i-1 < 0 ? points.count - 1 : i - 1]
			let p1 = points[i]
			let p2 = points[(i+1) % points.count]
			let p3 = points[(i+1) % points.count + 1]
			
			let d1 = p1.delta(to: p0).length
			let d2 = p2.delta(to: p1).length
			let d3 = p3.delta(to: p2).length
			
			var b1 = p2.multiply(by: pow(d1, 2 * alpha))
			b1 = b1.delta(to: p0.multiply(by: pow(d2, 2 * alpha)))
			b1 = b1.add(to: p1.multiply(by: 2 * pow(d1, 2 * alpha) + 3 * pow(d1, alpha) * pow(d2, alpha) + pow(d2, 2 * alpha)))
			b1 = b1.multiply(by: 1.0 / (3 * pow(d1, alpha) * (pow(d1, alpha) + pow(d2, alpha))))
			
			var b2 = p1.multiply(by: pow(d3, 2 * alpha))
			b2 = b2.delta(to: p3.multiply(by: pow(d2, 2 * alpha)))
			b2 = b2.add(to: p2.multiply(by: 2 * pow(d3, 2 * alpha) + 3 * pow(d3, alpha) * pow(d2, alpha) + pow(d2, 2 * alpha)))
			b2 = b2.multiply(by: 1.0 / (3 * pow(d3, alpha) * (pow(d3, alpha) + pow(d2, alpha))))
			
			if i == startIndex {
				move(to: p1)
			}
			
			addCurve(to: p2, control1: b1, control2: b2)
		}
		if closed {
			closeSubpath()
		}
	}
}
