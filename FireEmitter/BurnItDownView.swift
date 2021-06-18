//
//  BurnItDownView.swift
//  FireEmitter
//
//  Created by Duncan Champney on 6/14/21.
//

import UIKit

class BurnItDownView: UIView {

    public var duration = 2.0

    var completion: (()->Void)? = nil
    private var fireEmitter = CAEmitterLayer()
    private var emitterCell = CAEmitterCell()
    private var emitterCell2 = CAEmitterCell()
    private var emitterCell3 = CAEmitterCell()
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
        let colors: [UIColor] = [.clear, .clear, .white, .white]
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = [-0.4, -0.2, 0.0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.mask = gradientLayer
    }

    func animateGradientMask() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-0.4, -0.2, 0.0, 1.0]
        animation.toValue = [0.0, 1.0, 1.2, 1.4]
        CATransaction.setDisableActions(true)
        gradientLayer.locations = [0.0, 1.0, 1.2, 1.2]
        animation.delegate = self
        animation.duration = duration * 1.2
        gradientLayer.add(animation, forKey: nil)
    }


    func configureFireCell(_ fireCell: CAEmitterCell,
                           imageName: String,
                           birthRate: Float  = 100){
        fireCell.alphaSpeed = -0.3
        fireCell.birthRate = birthRate
        fireCell.lifetime = 30.0
        fireCell.lifetimeRange = 0.5
        fireCell.color = UIColor(red: 0.8, green: 0.4, blue: 0.2, alpha: 0.6).cgColor
        if let image = UIImage(named: imageName)?.cgImage {
            print("Loaded image named '\(imageName)'")
            fireCell.contents = image
        } else {
            print("Unable to load image named '\(imageName)'")
        }
        fireCell.emissionLongitude = CGFloat.pi
        fireCell.velocity = 80
        fireCell.velocityRange = 10
        fireCell.emissionRange = CGFloat.pi/8
        fireCell.yAcceleration = -200
        fireCell.scaleSpeed = 0.3
    }

    public func burnItDown(completion: (()->Void)? = nil) {
        guard let superview = superview else { return }
        configureGradientLayer()
        configureFireCell(emitterCell, imageName: "fireSmall", birthRate: 75)
        configureFireCell(emitterCell2, imageName: "fire2-small", birthRate: 75)
        configureFireCell(emitterCell3, imageName: "fire_emoji_small", birthRate: 150)
        let position = CGPoint(x: superview.bounds.width / 2, y:  frame.origin.y - 40)
        fireEmitter.emitterPosition = position
        fireEmitter.emitterSize = CGSize(width: frame.width, height: 10)
        fireEmitter.renderMode = .additive
        fireEmitter.emitterShape = .line
        fireEmitter.emitterCells = [emitterCell, emitterCell2, emitterCell3]
        fireEmitter.opacity = 0.5
        superview.layer.addSublayer(fireEmitter)

        self.completion = completion

//        fireEmitter.speed = 0.2
        animateEmitterLayer()
        animateGradientMask()
    }
    func reduceBirthRate() {
        fireEmitter.birthRate -= 20
        if fireEmitter.birthRate > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.reduceBirthRate()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.gradientLayer.locations = [-0.4, -0.2, 0.0, 1.0]
                self.fireEmitter.removeFromSuperlayer()
                self.fireEmitter = CAEmitterLayer()
                self.completion?()
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
