//
//  Game.swift
//  Concentration
//
//  Created by Wang Wei on 2019/03/06.
//  Copyright © 2019 MA CHENMING. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    static let gameUpdated = Notification.Name("gameUpdatedNotification")
}

class FlipGame {

    private static var cardTextChoice = ["👻","🎃","😈","💀","🤡","🤖","🦇","👽"]

    struct Card: Equatable {
        let text: String
    }

    let cards: [Card]

    var flipCount = 0

    // Indexes of current face up card pair. `nil` means not selected.
    var faceUp: (Int?, Int?) = (nil, nil)

    var matched: Set<Int> = []

    init(cardNumber: Int) {
        assert(cardNumber > 0 && cardNumber <= 16 && cardNumber % 2 == 0,
               "Cannot create a game. Check card number: \(cardNumber)")
        cards = (FlipGame.cardTextChoice + FlipGame.cardTextChoice).map { Card(text: $0) }.shuffled()
        notifyGameUpdated()
    }

    func notifyGameUpdated() {
        NotificationCenter.default.post(name: .gameUpdated, object: self)
    }

    func canChoose(at index: Int) -> Bool {
        let alreadyMatched = matched.contains(index)
        let isCurrentFaceUp = faceUp.0 == index
        return !alreadyMatched && !isCurrentFaceUp
    }

    func chooseCard(at index: Int) {

        guard canChoose(at: index) else { return }

        switch faceUp {
        case (nil, nil): // game starting
            faceUp = (index, nil)
        case (let upIndex?, nil): // Already chose one. Now is choosing the second card
            faceUp = (upIndex, index)
            if compareCardsAt(index: upIndex, to: index) {
                matched.insert(upIndex)
                matched.insert(index)
            }
        case (_?, _?):
            faceUp = (index, nil)
        default:
            fatalError("There should be no case for (nil, index)")
        }
        flipCount += 1
        notifyGameUpdated()
    }

    var isWinning: Bool { return matched.count == cards.count }

    func win() {
        matched = Set(0..<cards.count)
        flipCount = 16
        notifyGameUpdated()
    }

    func compareCardsAt(index anIndex: Int, to anotherIndex: Int) -> Bool {
        return cards[anIndex] == cards[anotherIndex]
    }
}
