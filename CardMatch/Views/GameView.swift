//
//  GameView.swift
//  CardMatch
//
//  Created by vinnie on 2023/08/16.
//

import SwiftUI

struct GameView: View {
  @State private var countdown = 3
  
  private let totalTime = 120.0 // 2분
  @State private var remainingTime = 120.0
  @State private var progress = 1.0

  // 게임 시작 전 3초 카운트다운 실행
  private func handleCountdown() {
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
      if countdown  > 0 {
        countdown -= 1
      } else {
        timer.invalidate()
        handleProgress()
      }
    })
  }
  
  // 남은 시간을 progress bar로 표시
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

  var body: some View {
    NavigationView{
      VStack{
        NavigationLink("Go to the ScoreView", destination: ScoreView())
          .navigationTitle("GameView")

        if countdown > 0 {
          Text(String(countdown))
            .padding()
        } else {
          ProgressView(value: progress)
            .padding(.horizontal)
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
