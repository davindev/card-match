//
//  GameView.swift
//  CardMatch
//
//  Created by vinnie on 2023/08/16.
//

import SwiftUI

struct GameView: View {
  var body: some View {
    NavigationView{
      NavigationLink("Go to the ScoreView", destination: ScoreView())
        .navigationTitle("GameView")
    }
    .navigationBarBackButtonHidden(true)
  }
}

struct GameView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      GameView()
    }
  }
}
