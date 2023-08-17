//
//  ScoreView.swift
//  CardMatch
//
//  Created by vinnie on 2023/08/17.
//

import SwiftUI

struct ScoreView: View {
  var body: some View {
    Text("ScoreView")
      .navigationBarBackButtonHidden(true)
  }
}

struct ScoreView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ScoreView()
    }
  }
}
