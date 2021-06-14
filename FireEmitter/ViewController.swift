//
//  ViewController.swift
//  FireEmitter
//
//  Created by Duncan Champney on 6/14/21.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

    @IBOutlet weak var viewToBurn: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func createFire() {
        let fireEmitter = CAEmitterLayer()
        print("view bounds = \(view.bounds)")
        let layerFrame = viewToBurn.frame
        print("viewToBurn.layerFrame = \(layerFrame)")
        let position = CGPoint(x: (view.bounds.width) / 2, y: layerFrame.minY - 40)
        print("Emitter position = \(position)")
        fireEmitter.emitterPosition = position
        fireEmitter.emitterSize = CGSize(width: viewToBurn.frame.width, height: 10)
        fireEmitter.renderMode = .additive
        fireEmitter.emitterShape = .line
        fireEmitter.emitterCells = [createFireCell()]
        fireEmitter.opacity = 0.5
        self.view.layer.addSublayer(fireEmitter)
    }

    func createFireCell() -> CAEmitterCell {
        let fire = CAEmitterCell()
        fire.alphaSpeed = -0.3
        fire.birthRate = 300
        fire.lifetime = 30.0
        fire.lifetimeRange = 0.5
        fire.color = UIColor(red: 0.8, green: 0.4, blue: 0.2, alpha: 0.6).cgColor
        fire.contents = UIImage(named: "fireSmall")?.cgImage
        fire.emissionLongitude = CGFloat.pi
        fire.velocity = 80
        fire.velocityRange = 10
        fire.emissionRange = CGFloat.pi/8
        fire.yAcceleration = -200
        fire.scaleSpeed = 0.3
        return fire
    }

    @IBAction func handleBurnItDownButton(_ sender: Any) {
        let layerFrame = viewToBurn.layer.frame
        print("viewToBurn.layerFrame = \(layerFrame)")
        createFire()
    }

}

