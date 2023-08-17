//
//  ContentView.swift
//  CardMatch
//
//  Created by vinnie on 2023/08/16.
//

import SwiftUI

struct ContentView: View {
  init(){
    UINavigationBar.setAnimationsEnabled(false)
  }
    
  var body: some View {
    NavigationView{
      NavigationLink("Go to the GameView", destination: GameView())
        .navigationTitle("ContentView")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
