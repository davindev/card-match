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
  private let flipDelayTime = 3
  private let unmatchedDelayTime = 1

  @State private var cards = CardMatch.cards

  @State private var workItem: DispatchWorkItem?

  // 게임 시작 카운트다운
  private func handleCountdown() {
    CardMatch.timer(
      time: countdown,
      runBlock: {
        countdown -= 1

        if countdown == 0 {
          handleFlipAllCardsBackSide()
          handleProgress()
        }
      }
    )
  }

  // 남은 시간을 Progress Bar로 표시
  private func handleProgress() {
    CardMatch.timer(
      time: totalTime,
      runBlock: {
        remainingTime -= 1
        progress = Double(remainingTime) / Double(totalTime)
      },
      expireBlck: {
        print("") // 게임 종료 함수 추가
      }
    )
  }

  // 모든 카드를 뒷면으로 뒤집음
  private func handleFlipAllCardsBackSide() {
    for (index, _) in cards.enumerated() {
      cards[index].isFlipped = false
    }
  }

  // 선택한 카드를 앞면으로 뒤집음
  private func handleFlipOneCardFrontSide(currentCard: CardMatch.Card) {
    // 현재 카드가 이미 뒤집어져 있거나 매칭된 경우
    if currentCard.isFlipped || currentCard.isMatched {
      return
    }

    let checkableCards = cards.filter { card in
      return card.isFlipped && !card.isMatched
    }

    // 뒤집어진 카드가 0개인 경우
    if checkableCards.count == 0 {
      for (index, _) in cards.enumerated() {
        if cards[index].id == currentCard.id {
          cards[index].isFlipped = true

          workItem = DispatchWorkItem {
            if cards[index].isFlipped && !cards[index].isMatched {
              cards[index].isFlipped = false
            }
          }

          DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(flipDelayTime), execute: workItem!)

          return
        }
      }
    }

    workItem?.cancel()

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

        // 게임 종료 함수 추가

        return
      }

      // 두 카드의 값이 일치하지 않는 경우
      for (index, _) in cards.enumerated() {
        if cards[index].id == currentCard.id {
          cards[index].isFlipped = true
          break
        }
      }

      for (index, _) in cards.enumerated() {
        if let checkableCard = checkableCards.first, cards[index].id == checkableCard.id || cards[index].id == currentCard.id {
          DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(unmatchedDelayTime)) {
            cards[index].isFlipped = false
          }
        }
      }
      
      return
    }

    // 뒤집어진 카드가 2개인 경우
    for (index, _) in cards.enumerated() {
      if !cards[index].isMatched {
        cards[index].isFlipped = false
      }
    }

    for (index, _) in cards.enumerated() {
      if cards[index].id == currentCard.id {
        cards[index].isFlipped = true

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(flipDelayTime), execute: workItem!)

        return
      }
    }
  }

  var body: some View {
    NavigationView {
      VStack {
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
              Image(card.value)
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
