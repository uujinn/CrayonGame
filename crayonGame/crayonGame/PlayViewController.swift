//
//  ViewController.swift
//  tmpGame
//
//  Created by 양유진 on 2021/10/01.
//

import UIKit
import AVFoundation

class PlayViewController: UIViewController{

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var teethLabel: UILabel!
    @IBOutlet weak var toothView: UIView!
    @IBOutlet weak var soundBtn: UIButton!
    var foods: [UIImageView] = []
    var items: [UIImageView] = []
    
    var foodTimer: Timer!
    var checkFoodTimer: Timer!
    var itemTimer: Timer!
    var checkitemTimer: Timer!
    
    var player: UIImageView!
    var positionX: CGFloat!
    var positionY: CGFloat!
    
    var mainTimer:Timer = Timer()
    var mainCount:Int = 20
    var mainTimerCounting:Bool = false
    
    var soundOn: Bool = true
    var i = 0
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var teeth: Int = 3{
        didSet {
            teethLabel.text = "🦷 : \(teeth)"
        }
    }
    
    var audioPlayer = AVAudioPlayer()
    
    // 음식 떨어지는 line
    var location = [5,100,185,270,355]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "crayon_sound", ofType: "mp3")!))
            audioPlayer.play()
        }
        catch{
            print(error)
        }
        
        player = UIImageView(image: UIImage(named: "crayon_player"))
        player.frame = CGRect(x: 165, y: 500, width: 100, height: 100)
        self.view.addSubview(player)
        mainCount = 20

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player.frame = CGRect(x: 165, y: 500, width: 100, height: 100)
        score = 0
        teeth = 3
        positionX = self.player.frame.origin.x
        positionY = self.player.frame.origin.y
        teethLabel.text = "🦷 : \(teeth)"
        timerLabel.text = "⏳ : " + String(60-mainCount) + "s"

        mainCount = 20

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let touchPoint = touch.location(in: self.view)
        
//        print(touchPoint.y)
        
        DispatchQueue.main.async {
            self.player.center = CGPoint(x: (touchPoint.x), y: 550)
            self.positionX = self.player.frame.origin.x
            self.positionY = self.player.frame.origin.y
        }

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        audioPlayer.stop()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 타이머 가동
        DispatchQueue.global(qos: .background).async{
            self.mainLoop()
        }
        
        // 음식 생성
        DispatchQueue.global().async {
            let isrunning = true
            // 타이머 가동
            self.foodTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
                DispatchQueue.main.async {
                    self.createFood()
                }
            }
            self.i += 1
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
        
        
        // 음식 생성
        DispatchQueue.global().async {
            // 타이머 가동
            self.itemTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                DispatchQueue.main.async {
                    self.createItem()
                }
            }
            RunLoop.current.run()
        }
       
        // 음식과 플레이어 충돌 타이머
        DispatchQueue.global().async {
            self.checkitemTimer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { _ in
                DispatchQueue.main.async {
                    self.checkItemCollision()
                }
            }
            RunLoop.current.run()
        }
        
        // 음식 & 이빨 충돌 타이머
        DispatchQueue.global().async {
            self.checkitemTimer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { _ in
                DispatchQueue.main.async {
                    self.checkfoodToothCollision()
                }
            }
            RunLoop.current.run()
        }
        
        // 좋은 음식 & 이빨 충돌 타이머
        DispatchQueue.global().async {
            self.checkitemTimer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { _ in
                DispatchQueue.main.async {
                    self.checkToothCollision()
                }
            }
            RunLoop.current.run()
        }
    }
    
    //메인 루프
    func mainLoop(){
        mainTimerCounting = true
        let runLoop = RunLoop.current
        mainTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(mainTimerCounter), userInfo: nil, repeats: true)
        
        while mainTimerCounting{
            runLoop.run(until: Date().addingTimeInterval(0.1))
        }
    }
    
    //메인 타이머 카운터
    @objc func mainTimerCounter() -> Void
        {
            mainCount = mainCount + 1
            
            if(mainCount<60){
                print("⏳ : " + String(60-mainCount) + "s")
                DispatchQueue.main.async {
                    self.timerLabel.text = "⏳ : " + String(60-self.mainCount) + "s"
                }
            }
            else{
                mainTimer.invalidate()
                mainTimerCounting = false
                print("게임 종료")
                DispatchQueue.main.async {
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "FinalVC") as? FinalViewController else { return }
                    vc.score = self.score
                    vc.modalPresentationStyle = .fullScreen
                    // 화면을 전환하다.
                    self.present(vc, animated: true)
                }

            }
    }
    @IBAction func manageSound(_ sender: Any) {
        if soundOn{
            audioPlayer.stop()
            soundOn = false
            soundBtn.imageView?.image = UIImage(named:"speaker.slash")
        }else{
            audioPlayer.play()
            soundOn = true
            soundBtn.imageView?.image = UIImage(named:"speaker.wave.1")
        }

    }
}


extension PlayViewController{
    
    // 음식 생성 함수
    func createFood() {
        print("i= \(i)")
        let food = UIImageView(image: UIImage(named: "bad_\(Int.random(in: 1...4))"))
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
    
    // 좋은 음식 생성 함수
    func createItem() {
        let food = UIImageView(image: UIImage(named: "good_\(Int.random(in: 1...3))"))
        food.contentMode = .scaleAspectFill
        items.append(food)
        
        food.frame = CGRect(x: CGFloat(location.randomElement()!), y: -50, width: 50, height: 50)
        // 애니메이션
        UIView.animate(withDuration: 6.0, delay: 0.0, options: .allowUserInteraction, animations: {
            food.frame = CGRect(x: food.frame.origin.x, y: 1000, width: 50, height: 50)
        }, completion: { _ in
            if self.items.contains(food) {
                let index = self.items.firstIndex(of: food)
                self.items.remove(at: index!)
                food.removeFromSuperview()
            }
        })
        self.view.addSubview(food)
    }
    
    
    // 음식 & 플레이어 충돌 함수
    func checkFoodCollision() {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                if self.foods.count > 0 {
                    for food in self.foods {
                        if let foodValue = food.layer.presentation()?.frame {
                            if foodValue.intersects(self.player.frame) {
                                let index = self.foods.firstIndex(of: food)
                                self.foods.remove(at: index!)
                                food.removeFromSuperview()
                                self.score += 20
                                self.scoreLabel.text = String("Score: \(self.score)")
                            }
                        }
                    }
                }
            }
        }
    }
    
    // 좋은 음식 & 플레이어 충돌 함수
    func checkItemCollision() {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                if self.items.count > 0 {
                    for food in self.items {
                        if let foodValue = food.layer.presentation()?.frame {
                            if foodValue.intersects(self.player.frame) {
                                let index = self.items.firstIndex(of: food)
                                self.items.remove(at: index!)
                                food.removeFromSuperview()
                                self.scoreLabel.text = String("Score: \(self.score)")
                            }
                        }
                    }
                }
            }
        }
    }
    
    // 음식 & 이빨 충돌 함수
    func checkfoodToothCollision() {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                if self.foods.count > 0 {
                    for food in self.foods {
                        if let foodValue = food.layer.presentation()?.frame {
                            if (foodValue.intersects(self.toothView.frame)) {
                                let index = self.foods.firstIndex(of: food)
                                self.foods.remove(at: index!)
                                food.removeFromSuperview()
                                self.teeth -= 1
                                self.scoreLabel.text = String("Score: \(self.score)")
                                self.teethLabel.text = String("🦷 : \(self.teeth)")
                                if (self.teeth < 1){
                                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "FinalVC") as? FinalViewController else { return }
                                    vc.score = self.score
                                    vc.modalPresentationStyle = .fullScreen
                                    // 화면을 전환하다.
                                    self.present(vc, animated: true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // 음식 & 이빨 충돌 함수
    func checkToothCollision() {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                if self.items.count > 0 {
                    for food in self.items {
                        if let foodValue = food.layer.presentation()?.frame {
                            if (foodValue.intersects(self.toothView.frame)) {
                                let index = self.items.firstIndex(of: food)
                                self.items.remove(at: index!)
                                food.removeFromSuperview()
                                self.score += 20
                                self.scoreLabel.text = String("Score: \(self.score)")
                            }
                        }
                    }
                }
            }
        }
    }
   
}
