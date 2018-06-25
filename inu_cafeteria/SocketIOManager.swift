//
//  SocketIOManager.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 8. 8..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import SocketIO

class SocketIOManager {
    static let sharedInstance = SocketIOManager()
    
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    
    init() {
        if let url = URL(string: BASE_URL) {
            log.info("socket url : \(url)")
            manager = SocketManager(socketURL: url)
            socket = manager?.defaultSocket
        }
    }
    
    func establishConnection() {
        // 소켓 연결
        log.info("establishSocket")
        
        if socket?.status == .connected {
            log.info("socket connected")
        } else {
            log.info("socket disconnected")
            socket?.connect()
            if socket?.status == .connected {
                log.info("socket connected")
            } else {
                log.info("socket disconnected")
            }
        }
    }
    
//    func reconnectConnection() {
//        print("reconnectSocket")
//        socket?.reconnect()
//    }
    
    func closeConnection() {
        // 소켓 연결 해제
        log.info("closeSocket")
        socket?.disconnect()
        socket?.removeAllHandlers()
        if let status = self.socket?.status.description {
            log.info("socket status : \(status)")
        } else {
            log.info("socket status : nil")
        }
    }
    
    func connectToServer() {
        // 서버에 테스트 메시지 보내기
//        socket?.emit("connectUser", "name")
        print("emit socket")
//        socket?.emit("1", "1")
        socket?.emit("news", "hello world")
//        if userPreferences.object(forKey: "sno") != nil {
//            let sno = userPreferences.string(forKey: "sno")!
//            socket?.emit("connect_ios", sno)
//        } else {
//            socket?.emit("connect_ios", "")
//        }
    }
    
    func getNumber(code: String, completionHandler: @escaping (_ messageInfo: [Any]) -> Void) {
        // 특정 식당의 메시지 수신
        
//        SocketIOManager.sharedInstance.getNumber(code: "1", completionHandler: { item in
//            item =-> 수신된 데이터
//        })
        
        if socket?.status == .connected {
            log.info("socket connected")
        } else {
            log.info("socket disconnected")
        }
        
        socket?.on(code) { (dataArray, _) -> Void in
//            print(dataArray)
//            print(socketAck)
//            print("getnumber:\(code)")
            completionHandler(dataArray)
        }
    }
    
    func removeAll() {
        // 식당 메시지 수신 해제
        socket?.removeAllHandlers()
    }
}
