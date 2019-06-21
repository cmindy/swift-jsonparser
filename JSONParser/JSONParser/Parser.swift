//
//  Parser.swift
//  JSONParser
//
//  Created by CHOMINJI on 19/05/2019.
//  Copyright © 2019 JK. All rights reserved.
//

import Foundation

class Parser {
    private var converter: JSONConvertible = Converter()
    private var scanner: TokenScannable
    private var tokens: [String]
    
    init(tokens: [String], scanner: TokenScannable) {
        self.tokens = tokens
        self.scanner = scanner
    }
    
    let parseTable = [JSONKeyword.leftSquareBracket: parseArray,
                      JSONKeyword.leftCurlyBracket: parseObject]
    
    func parse() -> JSONContainerType? {
        while let token = scanner.nextToken(),
            let parseMethod = parseTable[token] {
                return parseMethod(self)()
        }
        return nil
    }
    
    private func parseArray() -> JSONContainerType {
        var arrayData: [JSONValueType] = []
        
        while let token = scanner.nextToken() {
            guard token != JSONKeyword.rightSquareBracket else {
                return arrayData
            }
            
            if let parseMethod = parseTable[token] {
                arrayData.append(parseMethod(self)())
            } else if let value = makeJSONType(by: token) {
                arrayData.append(value)
            }
        }
        return arrayData
    }
    
    private func parseObject() -> JSONContainerType {
        var objectData: [String: JSONValueType] = [:]
        
        while let token = scanner.nextToken() {
            guard token != JSONKeyword.rightCurlyBracket else {
                return objectData
            }
            
            guard scanner.nextToken() == JSONKeyword.colon,
                let rawValue = scanner.nextToken() else {
                    continue
            }
            let key = token
            
            if let parseMethod = parseTable[rawValue] {
                objectData[key] = parseMethod(self)()
            } else if let value = makeJSONType(by: rawValue) {
                objectData[key] = value
            }
        }
        return objectData
    }
    
    private func makeJSONType(by token: String) -> JSONValueType? {
        guard let value = converter.convert(token: token) else {
            return nil
        }
        return value
    }
}
