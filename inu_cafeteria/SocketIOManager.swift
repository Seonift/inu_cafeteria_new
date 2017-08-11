//
//  SocketIOManager.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 8. 8..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    
    let socket = SocketIOClient(socketURL: URL(string: socketURL)!)
    
    override init() {
        super.init()
    }
    
    func establishConnection(){
        print("establishSocket")
        
//        if socket.status == .disconnected {
//            print("socket reconnect")
//            socket.reconnect()
//        } else {
//            print("socket connect")
            socket.connect()
//        }
        print("socket status:\(socket.status.rawValue)")
//        print(socket)
//        print("Hello")
//        print("socket status:\(socket.status.hashValue)")
    }
    
//    func reconnectConnection(){
//        print("reconnectSocket")
//        socket.reconnect()
//    }
    
    func closeConnection(){
//        print("closeSocket")
        print("disconnect current socket!!!!")
        socket.disconnect()
        socket.removeAllHandlers()
        print("socket status:\(socket.status.rawValue)")
//        print("socket status:\(socket.status.hashValue)")
    }
    
    func connectToServer(){
//        socket.emit("connectUser", "name")
        print("emit socket")
//        socket.emit("1", "1")
        socket.emit("news", "hello world")
//        if userPreferences.object(forKey: "sno") != nil {
//            let sno = userPreferences.string(forKey: "sno")!
//            socket.emit("connect_ios", sno)
//        } else {
//            socket.emit("connect_ios", "")
//        }
    }
    
    func getNumber(code: String, completionHandler: @escaping (_ messageInfo: [Any]) -> Void) {
        socket.on(code) { (dataArray, socketAck) -> Void in
//            print(dataArray)
//            print(socketAck)
//            print("getnumber:\(code)")
            completionHandler(dataArray)
        }
    }
    
    func removeAll(){
        socket.removeAllHandlers()
    }
}
