//
//  ExplainViewController.swift
//  crayonGame
//
//  Created by 양유진 on 2021/10/04.
//

import UIKit
import AVFoundation


class ExplainViewController: UIViewController {

    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "explainSound", ofType: "mp3")!))
            audioPlayer.play()
        }
        catch{
            print(error)
        }
    }
    
    @IBAction func pressBackBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
        
}
