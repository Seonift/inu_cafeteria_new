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
        socket?.removeAllHandlers()
    }
}
