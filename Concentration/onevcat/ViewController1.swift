//
//  ViewController1.swift
//  Concentration
//
//  Created by Wang Wei on 2019/03/06.
//  Copyright © 2019 MA CHENMING. All rights reserved.
//

import UIKit

class ViewController1: UIViewController {

    var game: FlipGame!

    @IBOutlet private weak var flipCountLabel: UILabel!

    @IBOutlet private var cardButtons: [UIButton]!

    @IBAction func onePass(_ sender: UIButton) {
        game.win()
    }

    @IBAction func resetCard(_ sender: UIButton) {
        setupGame()
    }

    @IBAction func shuffleCard(_ sender: UIButton) {
        setupGame()
    }

    @IBAction private func touchCard(_ sender: UIButton) {
        guard let index = cardButtons.firstIndex(of: sender) else {
            assertionFailure("Button is not found in cardButtons array. Check whether @IBOutlet is correctly connected.")
            return
        }
        game.chooseCard(at: index)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // ViewController will live for the whole app life cycle, so just keep the notification observer forever.
        NotificationCenter.default.addObserver(forName: .gameUpdated, object: nil, queue: .main) { noti in
            guard let currentGame = noti.object as? FlipGame else {
                assertionFailure("Unexpected notification object. Requires current game, but \(noti.object ?? "<nil>")")
                return
            }
            self.updateUI(for: currentGame)
        }
        setupGame()
    }

    func setupGame() {
        game = FlipGame(cardNumber: cardButtons.count)
    }

    func updateUI(for game: FlipGame) {
        for (i, button) in cardButtons.enumerated() {
            if game.faceUp.0 == i || game.faceUp.1 == i {
                button.backgroundColor = .clear
                button.setTitle(game.cards[i].text, for: .normal)
            } else if game.matched.contains(i) {
                button.backgroundColor = .clear
                button.setTitle("", for: .normal)
            } else {
                button.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
                button.setTitle("", for: .normal)
            }
        }
        updateFlipCountLabel(count: game.flipCount)
        if game.isWinning {
            popUpWin()
        }
    }

    private func updateFlipCountLabel(count: Int){
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(count)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }

    private func popUpWin() {
        let alert = UIAlertController(title: "Win", message: "Tap to start a new game", preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: { _ in
            self.setupGame()
        }))
        present(alert, animated: true)
    }
}
