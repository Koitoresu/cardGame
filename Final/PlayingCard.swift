//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by Sameh Fakhouri on 10/2/18.
//  Copyright © 2018 CUNY Lehman College. All rights reserved.
//

import Foundation

struct PlayingCard: CustomStringConvertible, Identifiable, Codable {

    var description: String {
        return "\(rank)\(suit)"
    }
    
    var suit: Suit
    var rank: Rank
    var id: Int
    
    var isFaceUp: Bool 
    var isSelected: Bool
    
    func score() -> Int {
        suit.order * rank.order
    }
    
    enum Suit: String, CustomStringConvertible, Codable {
        case clubs      = "♣️"
        case hearts     = "❤️"
        case diamonds   = "♦️"
        case spades     = "♠️"
        
        static var all = [Suit.spades, .hearts, .diamonds, .clubs]

        var order: Int {
            switch self {
            case .clubs: return 1
            case .diamonds: return 2
            case .hearts: return 3
            case .spades: return 4
            }
        }
        var description: String {
            return self.rawValue
        }
    }
        
    enum Rank: CustomStringConvertible, Codable {
        case ace
        case face(String)
        case numeric(Int)
        
        var description: String {
            switch self {
            case .ace: return "A"
            case .numeric(let pips): return String(pips)
            case .face(let kind): return kind
            }
        }
        
        var order: Int {
            switch self {
            case .numeric(let pips): return pips
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            case .ace: return 14
            default: return 0
            }
        }
        
        static var all: [Rank] {
            var allRanks = [Rank.ace]
            for pips in 2...10 {
                allRanks.append(.numeric(pips))
            }
            allRanks += [.face("J"), .face("Q"), .face("K")]
            
            return allRanks
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let face = try? container.decode(String.self, forKey: .face) {
                self = .face(face)
            } else if let numeric = try? container.decode(Int.self, forKey: .numeric) {
                self = .numeric(numeric)
            } else {
                self = .ace
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            switch self {
            case .face(let face):
                try container.encode(face, forKey: .face)
            case .numeric(let numeric):
                try container.encode(numeric, forKey: .numeric)
            case .ace:
                break
            }
        }
        
        enum CodingKeys: CodingKey {
            case face
            case numeric
        }
        
        var face: String? {
            switch self {
            case .face(let face):
                return face
            default:
                return nil
            }
        }
        
        var numeric: Int? {
            switch self {
            case .numeric(let numeric):
                return numeric
            default:
                return nil
            }
        }

    }
}
