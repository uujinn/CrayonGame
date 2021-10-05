//
//  ViewController.swift
//  tmpGame
//
//  Created by 양유진 on 2021/10/01.
//

import UIKit

class PlayViewController: UIViewController{

    @IBOutlet weak var scoreLabel: UILabel!
    var foods: [UIImageView] = []
    
    var foodTimer: Timer!
    var checkFoodTimer: Timer!
    
    var player: UIImageView!
    var positionX: CGFloat!
    var positionY: CGFloat!
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    // 음식 떨어지는 line
    var location = [5,100,185,270,355]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player = UIImageView(image: UIImage(named: "crayon_player"))
        player.frame = CGRect(x: 165, y: 500, width: 100, height: 100)
        self.view.addSubview(player)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player.frame = CGRect(x: 165, y: 500, width: 100, height: 100)
        print("viewwillAppear")
        score = 0
        positionX = self.player.frame.origin.x
        positionY = self.player.frame.origin.y
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let touchPoint = touch.location(in: self.view)
        
        print(touchPoint.x)
        
        DispatchQueue.main.async {
            self.player.center = CGPoint(x: (touchPoint.x), y: 550)
            self.positionX = self.player.frame.origin.x
            self.positionY = self.player.frame.origin.y
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
        // 음식 생성
        DispatchQueue.global(qos: .background).async {
            self.foodTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
                DispatchQueue.main.async {
                    self.createFood()
                }
            }
            RunLoop.current.run()
        }
       
        // 음식과 플레이어 충돌 타이머
        DispatchQueue.global().async {
            self.checkFoodTimer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { _ in
                DispatchQueue.main.async {
                    self.checkFoodCollision()
                }
            }
            RunLoop.current.run()
        }
    }
}


extension PlayViewController{
    
    // 음식 생성 함수
    func createFood() {
        let food = UIImageView(image: UIImage(named: "6.jpg"))
        food.contentMode = .scaleAspectFill
        foods.append(food)
        
        food.frame = CGRect(x: CGFloat(location.randomElement()!), y: -50, width: 50, height: 50)
        // 애니메이션
        UIView.animate(withDuration: 6.0, delay: 0.0, options: .allowUserInteraction, animations: {
            food.frame = CGRect(x: food.frame.origin.x, y: 1000, width: 50, height: 50)
        }, completion: { _ in
            if self.foods.contains(food) {
                let index = self.foods.firstIndex(of: food)
                self.foods.remove(at: index!)
                food.removeFromSuperview()
            }
        })
        self.view.addSubview(food)
    }
    
    
    // 먹이 & 플레이어 충돌 함수
    func checkFoodCollision() {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                if self.foods.count > 0 {
                    for food in self.foods {
                        if let foodValue = food.layer.presentation()?.frame {
                            if foodValue.intersects(self.player.frame) {
                                let index = self.foods.firstIndex(of: food)
                                self.foods.remove(at: index!)
                                food.removeFromSuperview()
                                self.score += 20
                                self.scoreLabel.text = String(self.score)
                            }
                        }
                    }
                }
            }
        }
    }
   
}
