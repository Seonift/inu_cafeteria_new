//
//  Strings.swift
//  class_pick
//
//  Created by SeonIl Kim on 2017. 7. 11..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

class Strings {
    class func noServer() -> String {
        return "서버에 접속할 수 없습니다."
    }
    
    class func logout() -> String {
        return "정말 로그아웃 하시겠습니까?"
    }
    
    class func cancel_num() -> String {
        return "주문번호를 초기화하면 알림이 오지 않습니다. 초기화 하시겠습니까?"
    }
    
    class func stuinfo_fail() -> String {
        return "학생 정보를 불러올 수 없습니다. 다시 로그인 해주세요."
    }
    
    class func complete_num() -> String {
        return "주문하신 메뉴가 완료되었습니다. 카운터에서 받아가세요"
    }
}

class CGFloats {
    class func drawer_width() -> CGFloat {
        return 240.0
    }
}
