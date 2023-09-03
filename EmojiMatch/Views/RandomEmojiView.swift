//
//  RandomEmojiView.swift
//  EmojiMatch
//
//  Created by vinnie on 2023/09/04.
//

import SwiftUI

struct RandomEmojiView: View {
  private let emojis = ["☁️", "🍋", "🎾", "💗"]
  @State private var randomEmoji = ""

  var body: some View {
    ForEach(0..<20, id: \.self) { emoji in
      Text(randomEmoji)
        .font(.system(size: .random(in: 140...200)))
        .position(
          x: .random(in: 0...UIScreen.main.bounds.width),
          y: .random(in: 0...UIScreen.main.bounds.height)
        )
    }
    .onAppear {
      randomEmoji = emojis.randomElement() ?? ""
    }
  }
}

struct RandomEmojiView_Previews: PreviewProvider {
  static var previews: some View {
    RandomEmojiView()
  }
}

