//
//  FinalViewController.swift
//  crayonGame
//
//  Created by 양유진 on 2021/10/06.
//

import UIKit

class FinalViewController: UIViewController {

    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var bestScore: Int = 0
    var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = "Score: \(score)"
        bestScore = UserDefaults.standard.integer(forKey: "bestScore")
        updateScore()

    }
    
    @IBAction func pressedAgainButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedGameOver(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    func updateScore(){
        if bestScore > score {
            bestScoreLabel.text = String("Best: \(bestScore)")
            print("기록 못세웠음")
        }
        else{
            UserDefaults.standard.set(score, forKey: "bestScore")
            bestScoreLabel.text = "Best: \(String(describing: score))"
            print("기록 세웠음")
        }
    }
    
}
