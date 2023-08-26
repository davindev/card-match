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

  @State private var name = ""
  @State private var isPassedNameValidation: Bool?
  @State private var isShakedValidationMessage = false

  private func handleFetchScores() {
    Task {
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
        
        print(scores)
      } catch {
        print("Error fetching scores: \(error)")
      }
    }
  }

  private func handleChangeName(value: String) {
    let newName = value
        .filter { !$0.isWhitespace }
        .replacingOccurrences(
          of: EmojiMatch.nameRegex,
          with: "",
          options: .regularExpression
        )
        .prefix(8)
    name = String(newName)
  }

  private func handleSubmitScore(name: String, score: Int) {
    isPassedNameValidation = name.count >= 2

    if isPassedNameValidation == true {
      let db = Firestore.firestore()
      
      db.collection("scores").addDocument(data: [
        "name": name,
        "score": score
      ]) { error in
        if let error = error {
          print("Error adding document: \(error)")
        } else {
          handleFetchScores()
        }
      }

      return
    }

    isShakedValidationMessage = true
    withAnimation(Animation.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
      isShakedValidationMessage = false
    }
  }

  var body: some View {
    NavigationStack {
      VStack {
        NavigationLink("메인으로 이동") { ContentView() }
        NavigationLink("재시작") { GameView() }

        ForEach(scores, id: \.self) { score in
          HStack {
            if score.name == "" {
              VStack {
                TextField("닉네임을 입력하세요", text: $name)
                  .onChange(
                    of: name,
                    perform: { handleChangeName(value: $0) }
                  )
                  .onSubmit { handleSubmitScore(name: name, score: finalScore) }
                VStack {
                  Text("한글, 영어, 숫자만 입력이 가능합니다")
                    .foregroundColor(isPassedNameValidation == false ? Color.red : Color.black)
                  Text("최소 2글자, 최대 8글자 입력이 가능합니다")
                    .foregroundColor(isPassedNameValidation == false ? Color.red : Color.black)
                }
                .offset(x: isShakedValidationMessage ? 10 : 0)
              }
              Button("저장") { handleSubmitScore(name: name, score: finalScore) }
            } else {
              Text(score.name)
            }
            Text(String(score.score))
          }
        }
      }
      .onAppear() { handleFetchScores() }
      .navigationBarBackButtonHidden(true)
    }
  }
}

struct ScoreView_Previews: PreviewProvider {
  static var previews: some View {
    ScoreView(finalScore: Binding.constant(0))
  }
}
