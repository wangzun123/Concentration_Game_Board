//
//  Card.swift
//  Concentration
//
//  Created by MA CHENMING on 2019/02/26.
//  Copyright © 2019 MA CHENMING. All rights reserved.
//

import Foundation

struct Card: Hashable
{
//    var hashValue: Int{
//        return identifier
//    }
    func hash(into hasher: inout Hasher){
        hasher.combine(identifier)
    }
    static func ==(lhs: Card, rhs: Card) -> Bool{
        return lhs.identifier == rhs.identifier
    }
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIndentifier() -> Int{
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIndentifier()
    }
}
