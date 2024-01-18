//
//  Model.swift
//  Final
//
//  Created by Sameh Fakhouri on 5/8/23.
//

import Foundation

struct Model: Codable {
 
    var deck = PlayingCardDeck()
    
    var playerCards: [PlayingCard]
    var computerCards: [PlayingCard]
    var dealCount: Int = 0
    
    var playerScore: Int {
        var score = 0
        for i in 0..<playerCards.count {
            score += playerCards[i].score()
        }
        return score
    }
    
    var computerScore: Int {
        var score = 0
        for i in 0..<computerCards.count {
            score += computerCards[i].score()
        }
        return score
    }

    var balance: Int
    var bet: Int
    var betIncrement: Int
    
    var playerSelectedCardCount: Int {
        var count = 0;
        for i in 0..<playerCards.count {
            if playerCards[i].isSelected {
                count += 1
            }
        }
        return count
    }
    var maxNumberOfCardsToSelect: Int = 3
    
    var somePlayerCardsAreSelected: Bool {
        var selectedCount = 0
        for i in 0..<playerCards.count {
            if playerCards[i].isSelected {
                selectedCount += 1
            }
        }
        return (selectedCount == 0 ? false : true)
    }
    
    init(json: Data) throws {
        self = try JSONDecoder().decode(Model.self, from: json)
    }
    
    init(url: URL) throws {
        let data = try Data(contentsOf: url)
        self = try Model(json: data)
    }
    
    func json() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    mutating func deal() {
        if dealCount == 0 {
            if self.bet == 0 {
                betIncrement = 0
                increaseBet()
            }
            self.playerCards = [PlayingCard]()
            self.computerCards = [PlayingCard]()
            for _ in 1...5 {
                self.playerCards.append(getPlayingCardFromDeck())
            }
            dealCount = (dealCount + 1) % 3
        } else if dealCount == 1 {
            if !somePlayerCardsAreSelected {
                dealComputerCardsAndDetermineWinner()
                dealCount = (dealCount + 2) % 3
            } else {
                while let index = playerCards.firstIndex(where: { $0.isSelected == true }) {
                    self.playerCards[index] = getPlayingCardFromDeck()
                }
                dealCount = (dealCount + 1) % 3
            }
        } else if dealCount == 2 {
            dealComputerCardsAndDetermineWinner()
            dealCount = (dealCount + 1) % 3
        }
    }

    private mutating func dealComputerCardsAndDetermineWinner() {
        self.computerCards = [PlayingCard]()
        for _ in 1...5 {
            self.computerCards.append(getPlayingCardFromDeck())
        }
        if playerScore >= (computerScore * 2) {
            balance += 4 * bet
            betIncrement = 0
            bet = 0
        } else if playerScore > computerScore {
            balance += 2 * bet
            betIncrement = 0
            bet = 0
        } else {
            betIncrement = 0
            bet = 0
        }
    }
    
    private mutating func getPlayingCardFromDeck() -> PlayingCard {
        if self.deck.isEmpty() {
            self.deck = PlayingCardDeck()
        }
        return self.deck.draw()!
    }
    
    mutating func selectPlayerCard(_ card: PlayingCard) {
        if dealCount == 1 {
            if let index = playerCards.firstIndex(where: { $0.id == card.id }) {
                if self.playerCards[index].isSelected {
                    self.playerCards[index].isSelected = false
                } else {
                    if playerSelectedCardCount < maxNumberOfCardsToSelect {
                        self.playerCards[index].isSelected = true
                    }
                }
            }
        }
    }
    
    mutating func increaseBet() {
        betIncrement += 1
        if (balance >= betIncrement) {
            bet += betIncrement
            balance -= betIncrement
        } else {
            bet += balance
            balance = 0
        }
    }
    
    init() {
        self.playerCards = [PlayingCard]()
        self.computerCards = [PlayingCard]()
        self.balance = 100
        self.bet = 0
        self.betIncrement = 0
    }
    
    
}
