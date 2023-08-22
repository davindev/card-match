//
//  GameView.swift
//  CardMatch
//
//  Created by vinnie on 2023/08/16.
//

import SwiftUI

struct GameView: View {
  @State private var countdown = 3

  @State var timer: Timer?
  private let totalTime = 60 * 2
  @State private var remainingTime = 60 * 2
  @State var isTimerRunning = false
  @State private var progress = 1.0

  @State private var cards = CardMatch.cards
  private let allCardsCount = 30

  private let flipDelayTime = 3
  private let unmatchedDelayTime = 1

  @State private var currentCombo = 0
  @State private var accumulatedCombo = 0

  private let cardScore = 1000
  private let timeScore = 500
  private let comboScore = 300
  @State private var finalScore = 0

  @State var isEndedGame = false

  @State private var workItem: DispatchWorkItem?

  // 게임 시작 카운트다운
  private func handleCountdown() {
    CardMatch.timer(
      time: countdown,
      runBlock: {
        countdown -= 1

        if countdown == 0 {
          handleFlipAllCardsBackSide()
          handleRunTimer()
        }
      }
    )
  }

  // 타이머 시작
  private func handleRunTimer() {
    timer = CardMatch.timer(
      time: remainingTime,
      runBlock: {
        remainingTime -= 1
        progress = Double(remainingTime) / Double(totalTime)
      },
      stopBlock: {
        handleStopTimer()
        handleEndGame()
      }
    )

    isTimerRunning = true
  }

  // 타이머 중지
  private func handleStopTimer() {
    timer?.invalidate()
    timer = nil
    isTimerRunning = false
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
      for index in cards.indices {
        if cards[index].id == currentCard.id {
          cards[index].isFlipped = true

          workItem = DispatchWorkItem {
            if cards[index].isFlipped && !cards[index].isMatched {
              cards[index].isFlipped = false
              currentCombo = 0
            }
          }

          DispatchQueue.main.asyncAfter(
            deadline: .now() + .seconds(flipDelayTime),
            execute: workItem!
          )

          return
        }
      }
    }

    workItem?.cancel()

    // 뒤집어진 카드가 1개인 경우
    if checkableCards.count == 1 {
      // 두 카드의 값이 일치하는 경우
      if let checkableCard = checkableCards.first, checkableCard.value == currentCard.value {
        for index in cards.indices {
          if cards[index].id == checkableCard.id || cards[index].id == currentCard.id {
            cards[index].isFlipped = true
            cards[index].isMatched = true
          }
        }

        currentCombo += 1
        accumulatedCombo += 1

        let matchedCards = cards.filter { card in
          return card.isMatched
        }

        if matchedCards.count == allCardsCount {
          handleEndGame()
        }

        return
      }

      // 두 카드의 값이 일치하지 않는 경우
      for index in cards.indices {
        if cards[index].id == currentCard.id {
          cards[index].isFlipped = true
          break
        }
      }

      for index in cards.indices {
        if let checkableCard = checkableCards.first, cards[index].id == checkableCard.id || cards[index].id == currentCard.id {
          DispatchQueue.main.asyncAfter(
            deadline: .now() + .seconds(unmatchedDelayTime),
            execute: workItem!
          )
        }
      }

      return
    }

    // 뒤집어진 카드가 2개인 경우
    for index in cards.indices {
      if !cards[index].isMatched {
        cards[index].isFlipped = false
      }
    }
    
    handleFlipOneCardFrontSide(currentCard: currentCard)
  }

  private func handleEndGame() {
    let matchedCards = cards.filter { card in
      return card.isMatched
    }

    finalScore = (matchedCards.count * cardScore) + (remainingTime * timeScore) + (accumulatedCombo * comboScore)

    isEndedGame = true
  }

  var body: some View {
    NavigationStack {
      VStack {
        if countdown > 0 {
          Text(String(countdown))
        } else {
          ProgressView(value: progress)
            .padding(.horizontal)
        }

        if countdown == 0 {
          if isTimerRunning {
            Button("Timer Stop") {
              handleStopTimer()
            }
          } else {
            Button("Timer Start") {
              handleRunTimer()
            }
          }
        }

        NavigationLink("메인 페이지로 이동") {
          ContentView()
        }

        Text(String(currentCombo))

        ForEach(cards, id: \.id) { card in
          Button(action: { handleFlipOneCardFrontSide(currentCard: card) }) {
            if card.isFlipped {
              Image(card.value)
            } else {
              Text("뒷면")
            }
          }
        }

        // FIXME: NavigationLink의 isActive를 이용하여 페이지를 이동하는 방식은 deprecated 되었으나 navigationDestination이 정상 동작하지 않아 임시로 사용
        NavigationLink("", isActive: $isEndedGame) {
          ScoreView(score: $finalScore)
        }
      }
      .onAppear { handleCountdown() }
      .navigationBarBackButtonHidden(true)
    }
  }
}

struct GameView_Previews: PreviewProvider {
  static var previews: some View {
    GameView()
  }
}
