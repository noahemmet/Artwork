//
//  Swatch.swift
//  Artwork
//
//  Created by Noah Emmet on 5/29/19.
//  Copyright © 2019 Sticks. All rights reserved.
//

import Foundation
import Common

public struct Swatch: Codable, Hashable {
	public var name: String
	public var summary: String?
	public var color: Color
	
	public init(name: String, summary: String? = nil, color: Color) {
		self.name = name
		self.summary = summary
		self.color = color
	}
	
	public init(_ name: String, summary: String? = nil, _ hex: String) {
		self.name = name
		self.summary = summary
		self.color = try! Color(hex: hex)
	}
	
	public init(color: Color) {
		self.color = color
		name = "\(color)"
		summary = "Swatch Summary"
	}
}
