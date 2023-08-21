//
//  ContentView.swift
//  CardMatch
//
//  Created by vinnie on 2023/08/16.
//

import SwiftUI

struct ContentView: View {
  init() {
    UINavigationBar.setAnimationsEnabled(false)
  }

  var body: some View {
    NavigationStack {
      NavigationLink("Go to the GameView") { GameView() }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
