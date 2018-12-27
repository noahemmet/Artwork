//
//  Palette.swift
//  
//
//  Created by Noah Emmet on 5/7/18.
//

import Foundation
import Common

public struct Palette: Codable, Equatable {
    fileprivate static let debugColors: [Color] = {
        #if canImport(UIKit)
        let uiColors: [UIColor] = [#colorLiteral(red: 0.9411764741, green: 0.5739922942, blue: 0.3570979041, alpha: 1), #colorLiteral(red: 0.3693706585, green: 0.7706293926, blue: 0.3746566236, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.436638561, blue: 0.3345648598, alpha: 1), #colorLiteral(red: 0.5645159368, green: 0.5044977297, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.416728598, green: 0.5464304479, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), #colorLiteral(red: 0.4360099082, green: 0.6985016318, blue: 0.9098039269, alpha: 1), #colorLiteral(red: 0.9686274529, green: 0.4635895609, blue: 0.9268717573, alpha: 1), #colorLiteral(red: 0.7287270743, green: 0.4409723056, blue: 0.9098039269, alpha: 1), #colorLiteral(red: 0.7277998581, green: 0.9098039269, blue: 0.5131739374, alpha: 1), #colorLiteral(red: 0.7409872327, green: 0.6923571469, blue: 0.9098039269, alpha: 1), #colorLiteral(red: 0.2299941857, green: 0.6720169421, blue: 0.7538905622, alpha: 1), #colorLiteral(red: 0.7538905622, green: 0.4336123158, blue: 0.25079153, alpha: 1), #colorLiteral(red: 0.7538905622, green: 0.1145514077, blue: 0.4853263863, alpha: 1), #colorLiteral(red: 0.9275234466, green: 0.9376725653, blue: 0.590026319, alpha: 1), #colorLiteral(red: 0.429740393, green: 0.764428595, blue: 0.9376725653, alpha: 1), #colorLiteral(red: 0.2391415367, green: 0.239100693, blue: 0.6142068273, alpha: 1), #colorLiteral(red: 0.5640341879, green: 0.1458682484, blue: 0.6142068273, alpha: 1), #colorLiteral(red: 0.8918329568, green: 0.3474308353, blue: 0, alpha: 1), #colorLiteral(red: 0.4636829258, green: 0.6284356175, blue: 0.1281790544, alpha: 1), #colorLiteral(red: 0.6189031026, green: 0.6237763554, blue: 0.6237763554, alpha: 1), #colorLiteral(red: 0.9053674349, green: 0.8493311603, blue: 0.9316327811, alpha: 1), #colorLiteral(red: 0.3406752008, green: 0.2883505904, blue: 0.3012919936, alpha: 1)]
        let colors: [Color] = uiColors.map { $0.color }
        #else
        let colors: [Color] = [try! Color(hex: "#FF5733"), try! Color(hex: "#66B0BA"), try! Color(hex: "#C49CC6"), try! Color(hex: "#EA5F7B")]
        #endif
        return colors
    }()
    public static func debug() -> Palette {
        return Palette(swatches: Palette.debugColors.map { Swatch(color: $0) })
    }
    
    public var swatches: [Swatch]
    public var maxSwatches: Int?
    public var colors: [Color] { return swatches.map { $0.color }}

    public init(swatches: [Swatch], maxSwatches: Int? = nil) {
        self.swatches = swatches
        self.maxSwatches = maxSwatches
    }
}

public struct Swatch: Codable, Hashable, HasNameAndSummary {
    public static let random: Swatch = Swatch(color: Palette.debugColors.randomElement()!)
    public var name: String
    public var summary: String
    public var color: Color

    public init(name: String, summary: String, color: Color) {
        self.name = name
        self.summary = summary
        self.color = color
    }
    
    public init(color: Color) {
        self.color = color
        name = "\(color)"
        summary = "Swatch Summary"
    }
}
