//
//  ScoreView.swift
//  EmojiMatch
//
//  Created by vinnie on 2023/08/17.
//

import SwiftUI

struct ScoreView: View {
  @Binding var score: Int

  var body: some View {
    NavigationStack {
      Text("ScoreView \(score)")
        .navigationBarBackButtonHidden(true)
    }
  }
}

struct ScoreView_Previews: PreviewProvider {
  static var previews: some View {
    ScoreView(score: Binding.constant(0))
  }
}
