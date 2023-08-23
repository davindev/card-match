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

  private func handleFetchScores() async {
    do {
      let db = try await Firestore
        .firestore()
        .collection("score")
        .order(by: "score", descending: true)
        .limit(to: 10)
        .getDocuments()

      scores = db.documents.compactMap { document in
        let data = document.data()

        if let name = data["name"] as? String,
           let score = data["score"] as? Int
        {
          return Score(name: name, score: score)
        }

        return nil
      }
    } catch {
      print("Error fetching scores: \(error)")
    }
  }

  var body: some View {
    NavigationStack {
      VStack {
        Text("ScoreView \(finalScore)")

        ForEach(scores, id: \.self) { score in
          Text(score.name)
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
