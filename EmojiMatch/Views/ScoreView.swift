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
  @State private var shouldInsertFinalScore = true

  private let rankingColor = [EmojiMatch.yellow03, EmojiMatch.yellow02, EmojiMatch.yellow01]

  @State private var name = ""
  @State private var isShownAlert = false

  private func handleFetchScores() {
    Task {
      do {
        let db = try await Firestore
          .firestore()
          .collection("scores")
          .order(by: "score", descending: true)
          .order(by: "timestamp")
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

        if shouldInsertFinalScore {
          for (index, newScore) in newScores.enumerated() {
            if newScore.score < finalScore {
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

          shouldInsertFinalScore = false
        }

        scores = Array(newScores.prefix(scoresMaxCount))
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
    isShownAlert = name.count < 2

    if !isShownAlert {
      let db = Firestore.firestore()

      db.collection("scores").addDocument(data: ["name": name, "score": score, "timestamp": Timestamp() ]) { error in
        if let error = error {
          print("Error adding document: \(error)")
        } else {
          handleFetchScores()
        }
      }
    }
  }

  var body: some View {
    NavigationStack {
      ZStack {
        RandomEmojiView(emojis: ["🏆"])

        VStack {
          TextBorderView(
            text: Text("Ranking")
              .font(.custom("LOTTERIACHAB", size: 60))
              .foregroundColor(EmojiMatch.yellow03),
            borderColor: EmojiMatch.yellow05,
            borderWidth: 0.6
          )
          .padding(.bottom, 10)

          ScrollView {
            VStack {
              ForEach(Array(scores.enumerated()), id: \.offset) { index, score in
                HStack {
                  VStack {
                    if index <= 2 {
                      TextBorderView(
                        text: Text("\(index + 1)등")
                          .font(.custom("LOTTERIACHAB", size: 20))
                          .foregroundColor(rankingColor[index]),
                        borderColor: EmojiMatch.yellow05,
                        borderWidth: 0.2
                      )
                    } else {
                      Text("\(index + 1)등")
                    }
                  }
                  .frame(width: 40)

                  VStack {
                    if score.name == "" {
                      HStack {
                        VStack {
                          TextField("닉네임", text: $name)
                            .onChange(
                              of: name,
                              perform: { handleChangeName(value: $0) }
                            )
                            .padding(.top, 2)
                            .padding(.bottom, -7)

                          Divider()
                            .frame(height: 2)
                            .background(EmojiMatch.gray)
                        }
                        Button("저장") { handleSubmitScore(name: name, score: finalScore) }
                          .alert("닉네임을 확인해주세요.", isPresented: $isShownAlert) {}
                          .frame(width: 40, height: 26)
                          .background(EmojiMatch.yellow04)
                          .cornerRadius(8)
                          .foregroundColor(EmojiMatch.yellow01)
                      }
                    } else {
                      Text(score.name)
                    }
                  }
                  .frame(width: 150)

                  Text(String(score.score))
                    .frame(width: 60)
                }
                .frame(height: 26)
              }
              .padding(1)
            }
          }

          HStack {
            NavigationLink(destination: ContentView()) {
              Image(systemName: "house.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(EmojiMatch.yellow03)
            }
            NavigationLink(destination: GameView()) {
              Image(systemName: "arrow.counterclockwise.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(EmojiMatch.green)
            }
          }
          .padding(.top, 30)
        }
        .padding(20)
        .background(Color.white.opacity(0.95))
        .cornerRadius(20)
      }
      .onAppear { handleFetchScores() }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(EmojiMatch.yellow01)
      .navigationBarBackButtonHidden(true)
    }
  }
}

struct ScoreView_Previews: PreviewProvider {
  static var previews: some View {
    ScoreView(finalScore: Binding.constant(0))
  }
}
