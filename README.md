# Emoji Match

![](https://velog.velcdn.com/images/davin/post/fdef9d7b-07c4-4e5e-b030-c5bb9ed5bcdb/image.png)

Emoji Match는 30장의 카드를 뒤집어 짝을 맞추는 게임 어플리케이션 입니다. 카드의 짝을 맞출 경우 점수를 획득할 수 있으며, 자신의 점수가 TOP 20 안에 들어갈 경우 점수를 기록할 수 있습니다.

더 자세한 내용은 [프론트엔드 개발자의 iOS 앱 개발 후기](https://velog.io/@davin/%ED%94%84%EB%A1%A0%ED%8A%B8%EC%97%94%EB%93%9C-%EA%B0%9C%EB%B0%9C%EC%9E%90%EC%9D%98-iOS-%EC%95%B1-%EA%B0%9C%EB%B0%9C-%ED%9B%84%EA%B8%B0) 아티클을 참고해 주세요.

## Features
- 메인 페이지에서 이모지를 랜덤한 위치에 노출시킵니다.
- 게임 페이지에서 카드 짝 맞추기 게임을 진행합니다.
  - 제한 시간 1분 동안 카드의 짝을 맞출 수 있습니다.
  - 카드의 짝을 연속으로 맞출 경우 콤보 보너스를 획득할 수 있습니다.
  - 최종 점수는 `짝을 맞춘 카드 점수` + `남은 시간 점수` + `콤보 점수`를 합산합니다.
- 랭킹 페이지에서 자신의 점수가 TOP 20 안에 들어갈 경우 점수를 기록할 수 있습니다.

## Skills
- Swift (SwiftUI)
- Firebase Firestore
