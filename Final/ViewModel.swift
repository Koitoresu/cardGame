//
//  ViewModel.swift
//  Final
//
//  Created by Sameh Fakhouri on 5/4/23.
//

import Foundation

class ViewModel: ObservableObject { 
    
    @Published private var model = Model() {
        didSet {
            scheduledAutoSave()
        }
    }
    
    private var autoSaveTimer: Timer?

    var playerCards: [PlayingCard] {
        model.playerCards
    }
    
    var playerScore: Int {
        model.playerScore
    }
    
    var deck: PlayingCardDeck {
        model.deck
    }
    
    var computerScore: Int {
        model.computerScore
    }

    var computerCards: [PlayingCard] {
        model.computerCards
    }
    
    var balance: Int {
        model.balance
    }

    var bet: Int {
        model.bet
    }
    
    var dealCount: Int {
        model.dealCount
    }
    
    func newGame() {
        model = Model()
    }
    
    func deal() {
        model.deal()
    }
    
    func increaseBet() {
        model.increaseBet()
    }
    
    func selectPlayerCard(_ card: PlayingCard) {
        model.selectPlayerCard(card)
    }
    
    private func save(to url: URL) {
        let thisFunction = "\(String(describing: self)).\(#function)"
        do {
            let data: Data = try model.json()
            print("\(thisFunction) json = \(String(data: data, encoding: .utf8) ?? "nil")")
            
            try data.write(to: url)
            print("\n\(thisFunction) success!!!")
        } catch let encodingError where encodingError is EncodingError {
            print("\n \(thisFunction) couldn't encode Final as JSON because \(encodingError.localizedDescription)")
        } catch let error {
            print("\n\(thisFunction) error = \(error)")
        }
    }
    
    private struct AutoSave {
        static var coalescingInterval = 5.0
        static let fileName = "Autosaved.model"
        static var url: URL? {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            
            return documentDirectory?.appendingPathComponent(fileName)
        }
    }
    
    private func scheduledAutoSave() {
        autoSaveTimer?.invalidate() 
        autoSaveTimer = Timer.scheduledTimer(withTimeInterval: AutoSave.coalescingInterval, repeats: false) {
            _ in
            self.autoSave()
        }
    }
    
    private func autoSave() {
        if let url = AutoSave.url {
            save(to: url)
        }
    }
    
    init() {
        model = Model()
        if let url = AutoSave.url, let autoSavedModel = try? Model(url: url) {
            model = autoSavedModel
        }
    }

}
