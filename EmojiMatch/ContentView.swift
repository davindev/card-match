//
//  ContentView.swift
//  EmojiMatch
//
//  Created by vinnie on 2023/08/16.
//

import SwiftUI

struct ContentView: View {
  init() {
    UINavigationBar.setAnimationsEnabled(false)
  }

  private let emojis = ["☁️", "🍋", "🎾", "💗"]
  @State private var backgroundEmoji = ""

  var body: some View {
    NavigationStack {
      ZStack {
        ForEach(0..<20, id: \.self) { emoji in
          Text(backgroundEmoji)
            .font(.system(size: .random(in: 140...200)))
            .position(
              x: .random(in: 0...UIScreen.main.bounds.width),
              y: .random(in: 0...UIScreen.main.bounds.height)
            )
        }
        .onAppear {
          backgroundEmoji = emojis.randomElement() ?? ""
        }

        VStack {
          Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 300)

          NavigationLink(destination: GameView()) {
            Text("시작하기")
              .frame(width: 130, height: 46)
              .background(EmojiMatch.yellow03)
              .cornerRadius(8)
              .font(.custom("LOTTERIACHAB", size: 24))
              .foregroundColor(EmojiMatch.yellow01)
          }
          .padding(.top, 14)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(EmojiMatch.yellow01)
      .navigationBarBackButtonHidden(true)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
