//
//  BurnItDownView.swift
//  FireEmitter
//
//  Created by Duncan Champney on 6/14/21.
//

import UIKit

class BurnItDownView: UIView {

    let duration = 2.0
    public var fireEmitter = CAEmitterLayer()
    public var emitterCell = CAEmitterCell()
    let gradientLayer = CAGradientLayer()

    func animateEmitterLayer() {
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = fireEmitter.frame.origin.y
        animation.toValue = fireEmitter.frame.origin.y + frame.height
        CATransaction.setDisableActions(true) //       <-- *
        fireEmitter.frame.origin.y += frame.height
        animation.duration = duration
        fireEmitter.add(animation, forKey: nil)
    }
    func configureGradientLayer() {
        gradientLayer.frame = bounds
        let colors: [UIColor] = [.clear, .white, .white]
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = [-0.2, 0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.mask = gradientLayer
    }

    func animateGradientMask() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-0.2, 0, 1]
        animation.toValue = [1.0, 1.0, 1.0]
        CATransaction.setDisableActions(true)
        gradientLayer.locations = [1.0, 1.0, 1.0]
        animation.delegate = self
        animation.duration = duration
        gradientLayer.add(animation, forKey: nil)
    }


    func configureFireCell() {
        emitterCell.alphaSpeed = -0.3
        emitterCell.birthRate = 300
        emitterCell.lifetime = 30.0
        emitterCell.lifetimeRange = 0.5
        emitterCell.color = UIColor(red: 0.8, green: 0.4, blue: 0.2, alpha: 0.6).cgColor
        emitterCell.contents = UIImage(named: "fireSmall")?.cgImage
        emitterCell.emissionLongitude = CGFloat.pi
        emitterCell.velocity = 80
        emitterCell.velocityRange = 10
        emitterCell.emissionRange = CGFloat.pi/8
        emitterCell.yAcceleration = -200
        emitterCell.scaleSpeed = 0.3
    }

    public func burnItDown() {
        guard let superview = superview else { return }
        configureGradientLayer()
        configureFireCell()
        let layerFrame = frame
        print("viewToBurn.layerFrame = \(layerFrame)")
        let position = CGPoint(x: superview.bounds.width / 2, y:  frame.origin.y - 40)
        print("Emitter position = \(position)")
        fireEmitter.emitterPosition = position
        fireEmitter.emitterSize = CGSize(width: frame.width, height: 10)
        fireEmitter.renderMode = .additive
        fireEmitter.emitterShape = .line
        fireEmitter.emitterCells = [emitterCell]
        fireEmitter.opacity = 0.5
        superview.layer.addSublayer(fireEmitter)

        animateEmitterLayer()
        animateGradientMask()
    }
    func reduceBirthRate() {
        fireEmitter.birthRate -= 20
        print(fireEmitter.birthRate)
        if fireEmitter.birthRate > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.reduceBirthRate()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.gradientLayer.locations = [-0.5, 0, 1]
                self.fireEmitter.removeFromSuperlayer()
                self.fireEmitter = CAEmitterLayer()
                self.emitterCell = CAEmitterCell()
            }
        }
    }
}

extension BurnItDownView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation,
                          finished flag: Bool) {
        reduceBirthRate()
    }

}
