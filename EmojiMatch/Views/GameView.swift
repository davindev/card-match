//
//  GameView.swift
//  EmojiMatch
//
//  Created by vinnie on 2023/08/16.
//

import SwiftUI

struct GameView: View {
  @State private var countdown = 3
  private let countdownColors = [EmojiMatch.yellow04, EmojiMatch.yellow03, EmojiMatch.yellow02]

  @State var timer: Timer?
  private let totalTime = 60 * 2
  @State private var remainingTime = 60 * 2
  @State var isTimerRunning = false
  @State private var progress = 1.0

  @State private var cards = EmojiMatch.cards.shuffled()
  private let allCardsCount = 30
  private let cardRows = Array(repeating: GridItem(.flexible(), spacing: 83), count: 6)

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
    EmojiMatch.timer(
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
    timer = EmojiMatch.timer(
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
    for index in cards.indices {
      cards[index].isFlipped = false
    }
  }

  // 선택한 카드를 앞면으로 뒤집음
  private func handleFlipOneCardFrontSide(currentCard: EmojiMatch.Card) {
    // 현재 카드가 이미 뒤집어져 있거나 매칭된 경우
    if currentCard.isFlipped || currentCard.isMatched {
      return
    }

    let checkableCards = cards.filter { card in
      card.isFlipped && !card.isMatched
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
          card.isMatched
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
          DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(unmatchedDelayTime)) {
            if cards[index].isFlipped && !cards[index].isMatched {
              cards[index].isFlipped = false
              currentCombo = 0
            }
          }
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
      card.isMatched
    }

    finalScore = (matchedCards.count * cardScore) + (remainingTime * timeScore) + (accumulatedCombo * comboScore)

    isEndedGame = true
  }

  var body: some View {
    NavigationStack {
      ZStack {
        VStack {
          HStack {
            Text("Combo  \(currentCombo)")
              .font(.custom("LOTTERIACHAB", size: 20))
              .foregroundColor(Color.gray)

            Spacer()

            HStack {
              NavigationLink(destination: ContentView()) {
                Image(systemName: "house.circle.fill")
                  .font(.system(size: 40))
                  .foregroundColor(EmojiMatch.yellow03)
              }

              if isTimerRunning {
                Button(action: handleStopTimer ) {
                  Image(systemName: "stop.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(EmojiMatch.red)
                }
              } else {
                Button(action: handleRunTimer ) {
                  Image(systemName: "play.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(EmojiMatch.green)
                }
              }
            }
          }
          .padding(.leading, 30)
          .padding(.trailing, 30)
          .padding(.bottom, 60)

          LazyHGrid(rows: cardRows) {
            ForEach(cards, id: \.id) { card in
              if card.isFlipped {
                ZStack {
                  Image("card_front")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60)
                  Text(card.value)
                    .font(.system(size: 30))
                }
              } else {
                Image("card_back")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 60)
                  .onTapGesture { handleFlipOneCardFrontSide(currentCard: card) }
              }
            }
          }

          ProgressView(value: progress)
            .scaleEffect(x: 1, y: 3, anchor: .center)
            .accentColor(EmojiMatch.yellow03)
            .padding(.top, 60)
            .padding(.leading, 30)
            .padding(.trailing, 30)
        }

        if countdown > 0 {
          VStack {
            TextBorderView(
              text: Text(String(countdown))
                .font(.custom("LOTTERIACHAB", size: 180))
                .foregroundColor(countdownColors[countdown - 1]),
              borderColor: EmojiMatch.yellow05,
              borderWidth: 1.0
            )
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(Color.black.opacity(0.4))
        }

        // FIXME: NavigationLink의 isActive를 이용하여 페이지를 이동하는 방식은 deprecated 되었으나 navigationDestination이 정상 동작하지 않아 임시로 사용
        NavigationLink("", isActive: $isEndedGame) {
          ScoreView(finalScore: $finalScore)
        }
      }
      .onAppear { handleCountdown() }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .navigationBarBackButtonHidden(true)
    }
  }
}

struct GameView_Previews: PreviewProvider {
  static var previews: some View {
    GameView()
  }
}
