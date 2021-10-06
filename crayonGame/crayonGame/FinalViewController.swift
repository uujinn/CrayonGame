//
//  FinalViewController.swift
//  crayonGame
//
//  Created by 양유진 on 2021/10/06.
//

import UIKit

class FinalViewController: UIViewController {

    @IBOutlet weak var stateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func pressedAgainButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
