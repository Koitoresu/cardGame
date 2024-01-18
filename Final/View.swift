//
//  ContentView.swift
//  Final
//
//  Created by Sameh Fakhouri on 5/4/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ViewModel = ViewModel()
    
    @State private var dealt = Set<Int>()

    @Namespace private var dealingNameSpace
    

    private func deal(_ card: PlayingCard) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: PlayingCard) -> Bool {
        !dealt.contains(card.id)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                playerView
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.35, alignment: .top)
                    .background(Color.green)
                computerView
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.35, alignment: .top)
                    .background(Color.red)
                buttonView
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.15, alignment: .top)
                    .background(Color.orange)
            }
            .font(Font.system(size: 18))
            .padding(.vertical)
//            .animation(.default)
        }
        .background(Color.gray)
    }
    
    var playerView: some View {
        VStack {
            HStack {
                Text("Balance: $\(viewModel.balance)")
                Spacer()
                Text("Player Score: \(viewModel.playerScore)")
                Spacer()
                Text("Bet: $\(viewModel.bet)")
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                ForEach(viewModel.playerCards) { card in
                    CardView(card: card)
                        .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                        .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                        .onTapGesture {
                            withAnimation {
                                viewModel.selectPlayerCard(card)
                            }
                        }
                }
            }
            .padding(.horizontal)
            .animation(Animation.easeIn)
        }
    }
    
    var computerView: some View {
        VStack {
            Text("Computer Score: \(viewModel.computerScore)")

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                ForEach(viewModel.computerCards) { card in
                    CardView(card: card)
                        .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                        .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                }
            }
            .padding(.horizontal)
            .animation(Animation.linear)
        }
    }

    var buttonView: some View {
        HStack {
            restartButton
            Spacer()
//            dealButton
            deckBody
            Spacer()
            increaseBetButton
        }
        .padding(.horizontal)
    }
    
    var restartButton: some View {
        return Button {
            viewModel.newGame()
        } label: {
            VStack {
                Image(systemName: "arrowtriangle.right.circle")
                    .imageScale(.large)
                    .font(.largeTitle)
                Text("New Game")
                    .font(.caption)
            }
        }
    }
    
    var dealButton: some View {
        return Button {
            viewModel.deal() //deal has the determineWinner
        } label: {
            VStack {
                Image(systemName: "circle.grid.cross")
                    .imageScale(.large)
                    .font(.largeTitle)
                Text("Deal")
                    .font(.caption)
            }
        }
        .disabled((viewModel.balance == 0) && (viewModel.dealCount == 0))
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(viewModel.deck.cards) { card in
                CardView(card: card)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                    .cardify(isFaceUp: card.isFaceUp)
            }
        }
        .frame(width: CardConstants.undealtWidth,
               height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture {
            viewModel.deal()
        }
        .disabled((viewModel.balance == 0) && (viewModel.dealCount == 0))
    }

    var increaseBetButton: some View {
        return Button {
            viewModel.increaseBet()
        } label: {
            VStack {
                Image(systemName: "plus.square.on.square")
                    .imageScale(.large)
                    .font(.largeTitle)
                Text("Bet")
                    .font(.caption)
            }
        }
        .disabled(viewModel.balance == 0)
    }
    
    struct CardView: View {
        let card: PlayingCard
        let lineColor: Color
        let cardColor: Color
        
        init(card: PlayingCard) {
            self.card = card
            if card.isSelected {
                lineColor = DrawingConstants.selectedColor
            } else {
                lineColor = DrawingConstants.defaultColor
            }
            switch card.suit {
            case .clubs:
                cardColor = Color.blue
            case .diamonds:
                cardColor = Color.purple
            case .hearts:
                cardColor = Color.white
            case .spades:
                cardColor = Color.yellow
            }

        }
        
        var body: some View {
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                shape.fill(cardColor).foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    .foregroundColor(lineColor)
                    .overlay(Text(card.description), alignment: .center)
                    .font(Font.system(size: DrawingConstants.fontSize))
            }
//            .cardify(isFaceUp: card.isFaceUp)
            .aspectRatio(DrawingConstants.aspectRatio, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
        }
    }


    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let fontSize: CGFloat = 18
        static let aspectRatio: CGFloat = 2/3
        static let defaultColor = Color.gray
        static let selectedColor = Color.black
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 3
        static let totalDealDuration: Double = 2.0
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
