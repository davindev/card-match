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

  private let emojis = ["☁️", "🍋", "🎾", "🩷"]
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
        .onAppear() {
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
              .background(Color(red: 252/255.0, green: 178/255.0, blue: 26/255.0))
              .cornerRadius(8)
              .font(.custom("LOTTERIACHAB", size: 24))
              .foregroundColor(Color(red: 255/255.0, green: 252/255.0, blue: 222/255.0))
          }
          .padding(.top, 14)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color(red: 255/255.0, green: 252/255.0, blue: 222/255.0))
      .navigationBarBackButtonHidden(true)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
