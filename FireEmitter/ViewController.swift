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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func handleBurnItDownButton(_ sender: Any) {
        let layerFrame = viewToBurn.layer.frame
        print("viewToBurn.layerFrame = \(layerFrame)")
        viewToBurn.burnItDown()
    }

}

