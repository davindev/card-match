//
//  Cards.swift
//  EmojiMatch
//
//  Created by vinnie on 2023/08/19.
//

import Foundation

public struct Card {
  let id: Int
  let value: String
  var isFlipped: Bool
  var isMatched: Bool
}

public let cards = [
  Card(id: 1, value: "😆", isFlipped: true, isMatched: false),
  Card(id: 2, value: "😆", isFlipped: true, isMatched: false),
  Card(id: 3, value: "🩵", isFlipped: true, isMatched: false),
  Card(id: 4, value: "🩵", isFlipped: true, isMatched: false),
  Card(id: 5, value: "👻", isFlipped: true, isMatched: false),
  Card(id: 6, value: "👻", isFlipped: true, isMatched: false),
  Card(id: 7, value: "🐹", isFlipped: true, isMatched: false),
  Card(id: 8, value: "🐹", isFlipped: true, isMatched: false),
  Card(id: 9, value: "🍀", isFlipped: true, isMatched: false),
  Card(id: 10, value: "🍀", isFlipped: true, isMatched: false),
  Card(id: 11, value: "🌙", isFlipped: true, isMatched: false),
  Card(id: 12, value: "🌙", isFlipped: true, isMatched: false),
  Card(id: 13, value: "🥕", isFlipped: true, isMatched: false),
  Card(id: 14, value: "🥕", isFlipped: true, isMatched: false),
  Card(id: 15, value: "⚽️", isFlipped: true, isMatched: false),
  Card(id: 16, value: "⚽️", isFlipped: true, isMatched: false),
  Card(id: 17, value: "🍩", isFlipped: true, isMatched: false),
  Card(id: 18, value: "🍩", isFlipped: true, isMatched: false),
  Card(id: 19, value: "🧸", isFlipped: true, isMatched: false),
  Card(id: 20, value: "🧸", isFlipped: true, isMatched: false),
  Card(id: 21, value: "🎀", isFlipped: true, isMatched: false),
  Card(id: 22, value: "🎀", isFlipped: true, isMatched: false),
  Card(id: 23, value: "🎈", isFlipped: true, isMatched: false),
  Card(id: 24, value: "🎈", isFlipped: true, isMatched: false),
  Card(id: 25, value: "📚", isFlipped: true, isMatched: false),
  Card(id: 26, value: "📚", isFlipped: true, isMatched: false),
  Card(id: 27, value: "🧽", isFlipped: true, isMatched: false),
  Card(id: 28, value: "🧽", isFlipped: true, isMatched: false),
  Card(id: 29, value: "🧩", isFlipped: true, isMatched: false),
  Card(id: 30, value: "🧩", isFlipped: true, isMatched: false),
]
