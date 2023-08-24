//
//  ScoreView.swift
//  EmojiMatch
//
//  Created by vinnie on 2023/08/17.
//

import SwiftUI
import FirebaseFirestore

struct Score: Hashable {
  let name: String
  let score: Int
}

struct ScoreView: View {
  @Binding var finalScore: Int
  @State private var scores: [Score] = []
  private let scoresMaxCount = 20

  private func handleFetchScores() async {
    do {
      let db = try await Firestore
        .firestore()
        .collection("scores")
        .order(by: "score")
        .limit(to: scoresMaxCount)
        .getDocuments()

      var newScores = db.documents.compactMap { document in
        let data = document.data()

        if let name = data["name"] as? String,
           let score = data["score"] as? Int
        {
          return Score(name: name, score: score)
        }

        return nil
      }

      for (index, newScore) in newScores.enumerated() {
        if newScore.score >= finalScore {
          newScores.insert(
            Score(name: "", score: finalScore),
            at: index
          )
          break
        }
      }

      let isInsertedFinalScore = newScores.contains { newScore in
        newScore.name == ""
      }

      if !isInsertedFinalScore {
        newScores.append(Score(name: "", score: finalScore))
      }

      scores = Array(newScores.reversed().prefix(scoresMaxCount))
    } catch {
      print("Error fetching scores: \(error)")
    }
  }

  var body: some View {
    NavigationStack {
      VStack {
        Text("ScoreView \(finalScore)")

        ForEach(scores, id: \.self) { score in
          Text(score.name == "" ? "인풋자리" : score.name)
          Text(String(score.score))
        }
      }
      .onAppear() {
        Task {
          await handleFetchScores()
        }
      }
      .navigationBarBackButtonHidden(true)
    }
  }
}

struct ScoreView_Previews: PreviewProvider {
  static var previews: some View {
    ScoreView(finalScore: Binding.constant(0))
  }
}