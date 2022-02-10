# CrayonGame
 
### 게임 설명
    - 주어진 시간 안에 목표 점수를 채워야하는 게임
    - 이빨에 좋은 음식(🍎 , 🥬 ), 이빨에 안좋은 음식 (🥤,🍦, 🍫)
    - 이빨에 좋지 않은 음식이 이빨에 닿기 전에 짱구(Player)가 막는 게임
    
    
### 게임 규칙
    - Start 버튼을 누르면 타이머 (40초) 시작
    - 메인 로직: 이빨에 안좋은 음식이 떨어지면서 Player와 충돌하면 막은 것으로 처리하여 점수를 획득, Player와 충돌하지 않고 그대로 이빨과 충돌하면 이빨이 썩는다. (🦷  = 생명)
    - Tap Recognizer를 이용하여 Player가 Tap한 x좌표로 짱구가 이동할 수 있다.
    - 랜덤 음식이 랜덤 자리에 떨어진다.
    - Player가 음식을 막지 못하면 (이빨에 닿으면) 음식은 사라진다.
    - 목표 점수에 도달하면 Game Clear
    - 이빨 3개가 썩으면 Game Over
    - BGM
      - AVFoundation 사용 
      - Turn on/off 가능
    
### 시작 화면
<img src = "https://user-images.githubusercontent.com/70887135/153410072-160d5302-ac35-4fb9-b570-e54d28be6e45.png" width="25%" height="25%">

- `게임 시작`
- `How To Play`

### Play 화면
<img src = "https://user-images.githubusercontent.com/70887135/153411507-087aaf54-508c-4b1a-a0dd-94c3a4d33eac.gif" width="25%" height="25%">


- `Thread` , `GCD`, `동기`, `비동기`
    - 전체 타이머 가동
    - 음식 생성, 반복
    - 음식와 플레이어의 충돌 판단: `intersects` 사용


### 게임 종료
<img src = "https://user-images.githubusercontent.com/70887135/153410762-138fea55-53c6-4c65-b361-3ff7f5bc0ae5.png" width="25%" height="25%">

- 최고기록 달성 시 `UserDefaults`를 이용해 갱신
- `Replay` / `EXIT` 가능


