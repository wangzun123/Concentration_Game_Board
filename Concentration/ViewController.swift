//
//  ViewController.swift
//  Concentration
//
//  Created by MA CHENMING on 2019/02/26.
//  Copyright © 2019 MA CHENMING. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        // Use assert to make sure your initial state meets the assumption.
        // This avoids your program from going to a wrong and unexpected state.
        // Also check `precondition` and `fatalError` to see what's the differences between them.
        assert(cardButtons.count % 2 == 0, "Card number should be even.")
        return cardButtons.count / 2
    }

    // Please keep an space before the opening brace.
    // It is very rare to have no space there in almost all coding style.
    private(set) var flipCount = 0 {
        didSet{
            //flipCountLabel.text = "Flips: \(flipCount)"
            updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel(){
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!{
        didSet{
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction func onePass(_ sender: UIButton) {
        flipAllCards(at: 2)
        popWindows()
    }
    
    @IBAction func resetCard(_ sender: UIButton) {
        flipAllCards(at: 1)
        game.reset()
        
    }
    
    @IBAction func shuffleCard(_ sender: UIButton) {
        flipAllCards(at: 1)
        game.reset()
        game.shuffle()
    }
    
    private func flipAllCards(at state:Int){
        if state == 1{ // Do not use number as the state. Please declare an enum for it and do a switch over the enum.
            for index in cardButtons.indices{ // I suggest to just use `for button in cardButtons` instead. Loop an index is very rare in Swift.
                let button = cardButtons[index]
                //var card = game.cards[index]
                //card.isMatched = false
                button.isEnabled = true
                button.setTitle("", for: UIControl.State.normal) // You can just use `.normal` since Swift knows the type here.
                button.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
                //card.isFaceUp = false
            }
            flipCount = 0
        }else{
            for index in cardButtons.indices{
                let button = cardButtons[index]
                button.isEnabled = false
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0)
            }
            flipCount = 16 // Maybe you need `cardButtons` for counting instead of hard coded.
        }
    }
    
    private func popWindows(){
        let alertController = UIAlertController(title: "Geat Job!", message: "", preferredStyle: .alert)
        let action_ok = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            print("You've pressed OK");
        }
        alertController.addAction(action_ok)
        self.present(alertController, animated: true, completion: nil)
    }
    

    
    @IBAction private func touchCard(_ sender: UIButton) {
        //print("ghost!" )
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender){
            //print("cardNumber = \(cardNumber)")
            //flipCard(withEmoji: emojiChoices[cardNumber], on: sender)
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }else{
            print("It was not chosen")
        }
        //flipCard(withEmoji: "👻", on: sender)
    }
    
    private func updateViewFromModel(){
        var count = 0
        for index in cardButtons.indices{
            let button = cardButtons[index]
            let card = game.cards[index]
            if button.backgroundColor == #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0){
                count += 1 // It is not clear what the `count` is. Please find a better name to describe your purpose.
                print("Count: \(count)")
            }
            if card.isFaceUp{
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }else{
                button.setTitle("", for: UIControl.State.normal)
                //button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
                if card.isMatched{
                    button.isEnabled = false
                    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                }else{
                    button.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
                }
            }
            if count == 14{ // If you use `numberOfPairsOfCards` to determine card game size, this would fail if the buttons count changes.
                flipAllCards(at: 2) // This will set the `flipCount` to 16, which makes the labe show Flips: 16, regardless how many times I flipped.
                popWindows()
            }
        }
    }

    // I think the emoji on the card should be a part of the Card model. And it would be much more clear if determined
    // when you generate/reset the game.
//    private var emojiChoices = ["👻","🎃","😈","💀","🤡","🤖","🦇","👽"]
    private var emojiChoices = "👻🎃😈💀🤡🤖🦇👽"
    var emoji = [Card:String]()
    
    private func emoji(for card: Card) -> String{
        if emoji[card] == nil, emojiChoices.count > 0{
                //let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }

        if emoji[card] != nil{
            return emoji[card]!
        }else{
            return "?"
        }
        //return emoji[card.identifier] ?? "?"
    }
}

extension Int{
    var arc4random: Int{
        if self > 0{
            return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0{
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }else{
            return 0
        }
    }
    
}
