//
//  Timer.swift
//  CardMatch
//
//  Created by vinnie on 2023/08/19.
//

import Foundation

public func timer(time: Int, runBlock: (() -> Void)? = nil, expireBlck: (() -> Void)? = nil) {
  var totalTime = time

  Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
    if totalTime > 0 {
      totalTime -= 1

      if let runBlock = runBlock {
        runBlock()
      }
    } else {
      timer.invalidate()

      if let expireBlck = expireBlck {
        expireBlck()
      }
    }
  }
}
