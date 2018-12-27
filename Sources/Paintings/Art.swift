//
//  Art.swift
//  Artwork
//
//  Created by Noah Emmet on 10/22/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public protocol ArtType: Codable { }

public enum Art: Hashable {
    case painting(Painting)
}

extension Art: Codable {
    
    public enum Kind: Int, Codable, CodingKey {
        case _kind
        case painting
        init(_ art: Art) throws {
            switch art {
            case .painting: self = .painting
            }
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Kind.self)
        let kind: Kind = try container.decode(Kind.self, forKey: ._kind)
        switch kind {
        case ._kind: 
            fatalError("__kind should never be encoded in the first place")
        case .painting:
            let painting: Painting = try container.value(forKey: .painting)
            self = .painting(painting)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Kind.self)
        try container.encode(Kind(self), forKey: ._kind)
        switch self {
        case .painting(let painting):
            try container.encode(painting, forKey: .painting)
        }
    }
}
