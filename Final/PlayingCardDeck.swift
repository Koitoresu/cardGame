 //
//  PlayingCardDeck.swift
//  PlayingCard
//
//  Created by Sameh Fakhouri on 10/11/18.
//  Copyright © 2018 CUNY Lehman College. All rights reserved.
//

import Foundation
 
 struct PlayingCardDeck: Codable { 
    
    private(set) var cards = [PlayingCard]()
    
    mutating func draw() -> PlayingCard? {
        if cards.count > 0 {
            return cards.remove(at: 0)
        } else {
            return nil
        }
    }
    
    func isEmpty() -> Bool {
        (self.cards.count == 0 ? true : false)
    }
    
    init() {
        var id: Int = 1
        for suit in PlayingCard.Suit.all {
            for rank in PlayingCard.Rank.all {
                cards.append(PlayingCard(suit: suit, rank: rank, id: id, isFaceUp: false, isSelected: false))
                id += 1
            }
        }

        cards.shuffle()
        cards.shuffle()
    }
}

