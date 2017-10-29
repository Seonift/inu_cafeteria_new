# 인천대학교 학식 번호판 앱 INU Cafeteria for iOS

iOS 개발 : 김선일(인천대학교 정보통신공학과)
https://itunes.apple.com/kr/app/inu-카페테리아/id1272600111?mt=8

주요 기능

1. 교내 음식점 모바일 번호판 알림 (Socket.io, Google FCM)

앱이 online 상태인 경우, Socket.io를 이용하여 서버와 실시간 통신하며 번호판 알림.
앱이 background에 있을 때에는 FCM을 이용하여 서버로부터 푸시 메시지 수신.

2. 학생 인증용 바코드 발급

학생 인증을 거친 후, 유효한 사용자의 경우 학생 인증을 받을 수 있는 바코드 제공. 이느 교내에서 사용.
