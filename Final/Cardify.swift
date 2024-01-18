//
//  Cardify.swift
//  Final
//
//  Created by Koy Torres on 5/17/23.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    var rotation : Double // rotation in degrees
    
    var animatableData: Double {
        get {
            rotation
        }
        
        set {
            rotation = newValue
        }
    }
    
    init (isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            } else {
                RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                    .fill()
            }
            content
                .opacity(rotation < 90  ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0.0, 1.0, 0.0))
    
    }

    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10.0
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        return self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
