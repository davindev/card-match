//
//  EmojiMatchApp.swift
//  EmojiMatch
//
//  Created by vinnie on 2023/08/16.
//

import SwiftUI
import FirebaseCore

@main
struct EmojiMatchApp: App {
  init() {
    FirebaseApp.configure()
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
