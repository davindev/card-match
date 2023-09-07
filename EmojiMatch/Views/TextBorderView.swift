//
//  TextBorderView.swift
//  EmojiMatch
//
//  Created by vinnie on 2023/09/07.
//

import SwiftUI

struct TextBorderView: View {
  let text: Text
  let borderColor: Color
  let borderWidth: Double

  var body: some View {
    text
      .shadow(color: borderColor, radius: borderWidth)
      .shadow(color: borderColor, radius: borderWidth)
      .shadow(color: borderColor, radius: borderWidth)
      .shadow(color: borderColor, radius: borderWidth)
      .shadow(color: borderColor, radius: borderWidth)
      .shadow(color: borderColor, radius: borderWidth)
      .shadow(color: borderColor, radius: borderWidth)
      .shadow(color: borderColor, radius: borderWidth)
      .shadow(color: borderColor, radius: borderWidth)
      .shadow(color: borderColor, radius: borderWidth)
  }
}

struct TextBorderView_Previews: PreviewProvider {
  static var previews: some View {
    TextBorderView(
      text: Text("hello"),
      borderColor: Color.red,
      borderWidth: 1.0
    )
  }
}
