//
//  GameView.swift
//  CardMatch
//
//  Created by vinnie on 2023/08/16.
//

import SwiftUI

struct GameView: View {
  // 게임 시작 전 3초 카운트다운 실행
  @State private var countdown = 3

  private func handleCountdown() {
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
      if countdown  > 0 {
        countdown -= 1
      } else {
        timer.invalidate()
        flipAllCards()
        handleProgress()
      }
    })
  }

  // 남은 시간을 progress bar로 표시
  private let totalTime = 120.0 // 2분
  @State private var remainingTime = 120.0
  @State private var progress = 1.0

  private func handleProgress() {
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
      if remainingTime > 0 {
        remainingTime -= 1
        progress = remainingTime / totalTime
      } else {
        timer.invalidate()
      }
    })
  }
  
  // 카드 목록 생성
  struct Card {
    let id: Int
    let value: String
    var isFlipped: Bool
    var isMatched: Bool
  }
  
  @State private var cards = [
    Card(id: 0, value: "🐶", isFlipped: true, isMatched: false),
    Card(id: 1, value: "🐶", isFlipped: true, isMatched: false),
    Card(id: 2, value: "🐱", isFlipped: true, isMatched: false),
    Card(id: 3, value: "🐱", isFlipped: true, isMatched: false),
    Card(id: 4, value: "🐹", isFlipped: true, isMatched: false),
    Card(id: 5, value: "🐹", isFlipped: true, isMatched: false),
  ]

  // 게임 시작 시 모든 카드를 뒷면으로 뒤집음
  private func flipAllCards() {
    for (index, _) in cards.enumerated() {
      cards[index].isFlipped = false
    }
  }
  
  // 카드를 뒤집음
  private func flipOneCard(card: Card) {
    // 이미 뒤집어져 있거나 매칭된 경우 무시한다
    if card.isFlipped || card.isMatched {
      return
    }
    
    let flippedCards = cards.filter { card in
      return card.isFlipped
    }

    // 뒤집어진 카드가 0개인 경우
    if flippedCards.count == 0 {
      for (index, _) in cards.enumerated() {
        if cards[index].id == card.id {
          cards[index].isFlipped = true

          DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // 3초 후 뒤집음
            cards[index].isFlipped = false
          }

          return
        }
      }
      
      return
    }

    // 뒤집어진 카드가 1개인 경우
    if flippedCards.count == 1 {
      // 두 카드의 값이 일치하는 경우
      if let flippedCard = flippedCards.first, flippedCard.value == card.value {
        for (index, _) in cards.enumerated() {
          if cards[index].id == card.id || cards[index].id == flippedCard.id {
            cards[index].isFlipped = true
            cards[index].isMatched = true
          }
        }
        
        return
      }
      
      // 두 카드의 값이 일치하지 않는 경우
      for (index, _) in cards.enumerated() {
        cards[index].isFlipped = false
      }
      
      return
    }

    // 뒤집어진 카드가 2개인 경우
    for (index, _) in cards.enumerated() {
      // 매칭되지 않은 모든 카드들은 뒤로 뒤집는다
      if !cards[index].isMatched {
        cards[index].isFlipped = false
      }
    }

    // 현재 선택된 카드만 뒤집는다
    for (index, _) in cards.enumerated() {
      if cards[index].id == card.id {
        cards[index].isFlipped = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // 3초 후 뒤집음
          cards[index].isFlipped = false
        }

        return
      }
    }
  }

  var body: some View {
    NavigationView {
      VStack {
        NavigationLink("Go to the ScoreView", destination: ScoreView())
          .navigationTitle("GameView")

        if countdown > 0 {
          Text(String(countdown))
            .padding()
        } else {
          ProgressView(value: progress)
            .padding(.horizontal)
        }
        
        ForEach(cards, id: \.id) { card in
          Button(action: {
            flipOneCard(card: card)
          }) {
            if card.isFlipped {
              Text("Value: \(card.value)")
            } else {
              Text("뒷면")
            }
          }
        }
      }
    }
    .navigationBarBackButtonHidden(true)
    .onAppear(perform: handleCountdown)
  }
}

struct GameView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      GameView()
    }
  }
}
