//
//  View.swift
//  Final
//
//  Created by Sameh Fakhouri on 5/4/23.
//

import SwiftUI

struct View: View {
    
    @ObservedObject var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                playerView
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.35, alignment: .top)
                computerView
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.35, alignment: .top)
                buttonView
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.15, alignment: .top)
            }
            .font(Font.system(size: 18))
            .padding(.vertical)
        }
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
                        .onTapGesture {
                            viewModel.selectPlayerCard(card)
                        }
                }
            }
            .padding(.horizontal)
        }
    }
    
    var computerView: some View {
        VStack {
            Text("Computer Score: $\(viewModel.computerScore)")

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                ForEach(viewModel.computerCards) { card in
                    CardView(card: card)
                }
            }
            .padding(.horizontal)
        }
    }

    var buttonView: some View {
        HStack {
            restartButton
            Spacer()
            dealButton
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
            viewModel.deal()
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
        
        init(card: PlayingCard) {
            self.card = card
            if card.isSelected {
                lineColor = DrawingConstants.selectedColor
            } else {
                lineColor = DrawingConstants.defaultColor
            }

        }
        
        var body: some View {
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    .foregroundColor(lineColor)
                    .overlay(Text(card.description), alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .font(Font.system(size: DrawingConstants.fontSize))
            }
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

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            View()
        }
    }
}
