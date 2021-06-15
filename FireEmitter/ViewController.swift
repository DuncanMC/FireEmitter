//
//  ViewController.swift
//  FireEmitter
//
//  Created by Duncan Champney on 6/14/21.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

    @IBOutlet weak var viewToBurn: BurnItDownView!

    @IBAction func handleBurnItDownButton(_ button: UIButton) {
        button.isEnabled = false
        viewToBurn.burnItDown() {
            button.isEnabled = true
        }
    }

}

