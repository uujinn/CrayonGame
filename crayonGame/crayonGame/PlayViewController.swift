//
//  ViewController.swift
//  tmpGame
//
//  Created by 양유진 on 2021/10/01.
//

import UIKit

class PlayViewController: UIViewController{

    @IBOutlet weak var scoreLabel: UILabel!
    var preys: [UIImageView] = []
    
    var preyTimer: Timer!
    var checkPreyTimer: Timer!
    
    var player: UIImageView!
    var positionX: CGFloat!
    var positionY: CGFloat!
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var location = [15,110,185,270,355]
    override func viewDidLoad() {
        super.viewDidLoad()
        player = UIImageView(image: UIImage(named: "crayon_player"))
        player.frame = CGRect(x: 170, y: 500, width: 100, height: 100)
        self.view.addSubview(player)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player.frame = CGRect(x: 170, y: 500, width: 100, height: 100)
        print("viewwillAppear")
        score = 0
        positionX = self.player.frame.origin.x
        positionY = self.player.frame.origin.y
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let touchPoint = touch.location(in: self.view)
        
        print(touchPoint.x)
        
        DispatchQueue.global().async { [unowned self] in
            DispatchQueue.main.async {
                self.player.center = CGPoint(x: (touchPoint.x), y: 550)
                self.positionX = self.player.frame.origin.x
                self.positionY = self.player.frame.origin.y
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
        //먹이생성.
        DispatchQueue.global(qos: .background).async {
            self.preyTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
                DispatchQueue.main.sync {
                    self.createPrey()
                }
            }
            RunLoop.current.run()
        }
       
        // 먹이와 플레이어 충돌 타이머
        DispatchQueue.global().async {
            self.checkPreyTimer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { _ in
                DispatchQueue.main.sync {
                    self.checkPreyCollision()
                }
            }
            RunLoop.current.run()
        }
    }
}


extension PlayViewController{
    
    // 먹이 생성 함수
    func createPrey() {
        let prey = UIImageView(image: UIImage(named: "6.jpg"))
        prey.contentMode = .scaleAspectFill
        preys.append(prey)
        
        prey.frame = CGRect(x: CGFloat(location.randomElement()!), y: -50, width: 50, height: 50)
        // 애니메이션
        UIView.animate(withDuration: 7.0, delay: 2.0, options: .allowUserInteraction, animations: {
            prey.frame = CGRect(x: prey.frame.origin.x, y: 1000, width: 50, height: 50)
        }, completion: { _ in
            if self.preys.contains(prey) {
                let index = self.preys.firstIndex(of: prey)
                self.preys.remove(at: index!)
                prey.removeFromSuperview()
            }
        })
        self.view.addSubview(prey)
    }
    
    
    // 먹이 & 플레이어 충돌 함수
    func checkPreyCollision() {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                if self.preys.count > 0 {
                    for prey in self.preys {
                        if let preyVal = prey.layer.presentation()?.frame {
                            if preyVal.intersects(self.player.frame) {
                                let index = self.preys.firstIndex(of: prey)
                                self.preys.remove(at: index!)
                                prey.removeFromSuperview()
                                self.score += 10
                                self.scoreLabel.text = String(self.score)
                            }
                        }
                    }
                }
            }
        }
    }
   
}
