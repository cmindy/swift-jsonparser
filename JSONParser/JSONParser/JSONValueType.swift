//
//  JSONValueType.swift
//  JSONParser
//
//  Created by CHOMINJI on 19/05/2019.
//  Copyright © 2019 JK. All rights reserved.
//

import Foundation

protocol JSONValueType {
   static var typeDescription: String { get }
}

extension String: JSONValueType {
    static var typeDescription: String {
        return "문자열"
    }
}

typealias Number = Int
extension Number: JSONValueType {
    static var typeDescription: String {
        return "숫자"
    }
}

extension Bool: JSONValueType {
    static var typeDescription: String {
        return "부울"
    }
}
