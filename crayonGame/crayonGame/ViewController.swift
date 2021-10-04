//
//  ViewController.swift
//  crayonGame
//
//  Created by 양유진 on 2021/10/04.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var howButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designButton(btn: startButton)
        designButton(btn: howButton)
    }

    func designButton(btn: UIButton){
        btn.layer.backgroundColor = UIColor.white.cgColor
        btn.layer.cornerRadius = 10
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 2
    }

    @IBAction func pressedStartBtn(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlayVC") as? PlayViewController else{
            return
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func pressedExplainBtn(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExplainVC") as? ExplainViewController else{
            return
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

