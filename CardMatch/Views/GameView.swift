//
//  GameView.swift
//  CardMatch
//
//  Created by vinnie on 2023/08/16.
//

import SwiftUI

struct GameView: View {
  @State private var countdown = 3

  private let totalTime = 60 * 2
  @State private var remainingTime = 60 * 2
  @State private var progress = 1.0

  @State private var cards = CardMatch.cards

  // 게임 시작 카운트다운
  private func handleCountdown() {
    CardMatch.timer(time: countdown) {
      countdown -= 1
      
      if countdown == 0 {
        handleFlipAllCardsBackSide()
        handleProgress()
      }
    }
  }

  // 남은 시간을 Progress Bar로 표시
  private func handleProgress() {
    CardMatch.timer(time: totalTime) {
      remainingTime -= 1
      progress = Double(remainingTime) / Double(totalTime)
    }
  }

  // 게임 시작 시 모든 카드를 뒷면으로 뒤집음
  private func handleFlipAllCardsBackSide() {
    for (index, _) in cards.enumerated() {
      cards[index].isFlipped = false
    }
  }

  // 선택한 카드를 앞면으로 뒤집음
  private func handleFlipOneCardFrontSide(currentCard: CardMatch.Card) {
    // 현재 카드가 이미 뒤집어져 있거나 매칭된 경우 무시한다
    if currentCard.isFlipped || currentCard.isMatched {
      return
    }

    // 확인이 필요한 카드 리스트
    let checkableCards = cards.filter { card in
      return !card.isMatched && card.isFlipped
    }

    var workItem: DispatchWorkItem?

    // 뒤집어진 카드가 0개인 경우
    if checkableCards.count == 0 {
      for (index, _) in cards.enumerated() {
        if cards[index].id == currentCard.id {
          cards[index].isFlipped = true

          workItem = DispatchWorkItem {
            if !cards[index].isMatched && cards[index].isFlipped {
              cards[index].isFlipped = false
            }
          }

          DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: workItem!) // 3초 후 뒤집기

          return
        }
      }
    }

    // 뒤집어진 카드가 1개인 경우
    if checkableCards.count == 1 {
      // 두 카드의 값이 일치하는 경우
      if let checkableCard = checkableCards.first, checkableCard.value == currentCard.value {
        for (index, _) in cards.enumerated() {
          if cards[index].id == checkableCard.id || cards[index].id == currentCard.id {
            cards[index].isFlipped = true
            cards[index].isMatched = true
          }
        }
        
        return
      }
      
      // 두 카드의 값이 일치하지 않는 경우
      workItem?.cancel()

      // 현재 선택한 카드를 우선 뒤집고
      for (index, _) in cards.enumerated() {
        if cards[index].id == currentCard.id {
          cards[index].isFlipped = true
        }
      }

      // 그 다음 다시 뒤로 뒤집는다
      for (index, _) in cards.enumerated() {
        if let checkableCard = checkableCards.first, cards[index].id == checkableCard.id || cards[index].id == currentCard.id {
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // 1초 후 뒤집음
            cards[index].isFlipped = false
          }
        }
      }
      
      return
    }

    workItem?.cancel()

    // 뒤집어진 카드가 2개인 경우
    for (index, _) in cards.enumerated() {
      // 매칭되지 않은 모든 카드들은 뒤로 뒤집는다
      if !cards[index].isMatched {
        cards[index].isFlipped = false
      }
    }

    // 현재 선택된 카드만 뒤집는다
    for (index, _) in cards.enumerated() {
      if cards[index].id == currentCard.id {
        cards[index].isFlipped = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // 3초 후 뒤집음
          if !cards[index].isMatched && cards[index].isFlipped {
            cards[index].isFlipped = false
          }
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
            handleFlipOneCardFrontSide(currentCard: card)
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
