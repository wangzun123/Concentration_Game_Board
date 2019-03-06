//
//  Concentration.swift
//  Concentration
//
//  Created by MA CHENMING on 2019/02/26.
//  Copyright © 2019 MA CHENMING. All rights reserved.
//

import Foundation

struct Concentration{
    
    private(set) var cards = [Card]()
    private var indexOfOneAndOnlyFaceUpCard: Int?{
        get{
//            let faceUpCardIndices = cards.indices.filter { cards[$0].isFaceUp }
//            return (faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil)
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
            
            
//            var foundIndex: Int?
//            for index in cards.indices{
//                if cards[index].isFaceUp{
//                    if foundIndex == nil{
//                        foundIndex = index
//                    }else{
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        set{
            for index in cards.indices{
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func reset(){
        for index in cards.indices{
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
    }

    // It is not a good implementation for shuffling. I am not sure about the logic here.
    // But it seems maybe you can just call the shuffle method in Swift standard library?
    // If you just want to randomize the index (order) of every card, maybe do `cards.shuffle()`.
    mutating func shuffle(){
        var temp = Card()
        var index = 0
        for point in cards.indices{
            let randomCase = Int(arc4random_uniform(UInt32(cards.count - point - 1)))
            index = randomCase + point
            if index != point{
                temp = cards[point]
                cards[point] = cards[index]
                cards[index] = temp
            }
        }
    }
    
    
    mutating func chooseCard(at index:Int){
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        //if cards[index].isFaceUp{
            //cards[index].isFaceUp = false
        //}else{
            //cards[index].isFaceUp = true
        //}
        if !cards[index].isMatched{
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index{
                //check if cards match
                if cards[matchIndex] == cards[index]{
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
                //indexOfOneAndOnlyFaceUpCard = nil
            }else{
                //either no cards or 2 cards are faceup
                
//                for flipDownIndex in cards.indices{
//                    cards[flipDownIndex].isFaceUp = false
//                }
//                cards[index].isFaceUp = true
                
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards{
            let card = Card()
            //let matchingCard = card
            //cards.append(card)
            //cards.append(card)
            cards += [card, card]
        }
        
        // Please DRY, maybe juse call `shuffle()`?
        // TODO: Shuffle the cards
        var temp = Card()
        var index = 0
        for point in cards.indices{
            let randomCase = Int(arc4random_uniform(UInt32(cards.count - point - 1)))
            index = randomCase + point
            if index != point{
                temp = cards[point]
                cards[point] = cards[index]
                cards[index] = temp
            }
        }
    }
}

extension Collection{
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
