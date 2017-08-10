//
//  Queue.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 8. 8..
//  Copyright © 2017년 appcenter. All rights reserved.
//

public struct Queue<T> {
    fileprivate var array = [T]()
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public var count: Int {
        return array.count
    }
    
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    public mutating func dequeue() -> T? {
        if isEmpty {
            return nil
        } else {
            return array.removeFirst()
        }
    }
    
    public var front: T? {
        return array.first
    }
}

//public struct Queue<T>: ExpressibleByArrayLiteral {
//    /// 내부 배열 저장소
//    public private(set) var elements: Array<T> = []
//    
//    /// 새로운 엘리먼트 추가. 소요 시간 = O(1)
//    public mutating func push(value: T) { elements.append(value) }
//    
//    /// 가장 앞에 있는 엘리먼트를 꺼내오기. 소요시간 = O(`count`)
//    public mutating func pop() -> T { return elements.removeFirst() }
//    
//    /// 큐가 비었는지 검사
//    public var isEmpty: Bool { return elements.isEmpty }
//    
//    /// 큐의 크기, 연산 프로퍼티
//    public var count: Int { return elements.count }
//    
//    /// ArrayLiteralConvertible 지원
//    public init(arrayLiteral elements: T...) { self.elements = elements }
//}
