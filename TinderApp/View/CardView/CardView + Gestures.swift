//
//  CardView + Gestures.swift
//  TinderApp
//
//  Created by Timofey on 2/6/22.
//

import UIKit

extension CardView: UIGestureRecognizerDelegate {
  
  func animateToIdentity() {
    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .curveEaseInOut) {
      self.transform = .identity
      self.alpha = 1
      self.hiddenTopReactionView.alpha = 0
      self.center = self.startPoint
    }
  }
  
  func setupGestures() {
    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    gestureRecognizer.delegate = self
    addGestureRecognizer(gestureRecognizer)
  }
  
  @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
    let velocity = recognizer.velocity(in: self)
    switch recognizer.state {
    case .began:
      startPoint = center
    case .changed:
      onChange(recognizer)
    case .ended:
      gestureEnded(with: velocity.x)
    @unknown default:
      print("oknown")
    }
  }
  
  func onChange(_ recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translation(in: self)
    guard let gestureView = recognizer.view else { return }
    let xDelta = center.x - startPoint.x
    
    // moving view
    gestureView.center = CGPoint(x: gestureView.center.x + translation.x * 0.8,
                                 y: gestureView.center.y + translation.y * 0.3)
    // rotating view
    let angle: CGFloat = CardViewConstants.maxAngle * (CGFloat(xDelta) * 10 / 21)
    self.transform = CGAffineTransform(rotationAngle: angle * .pi/180)
    
    // hiding / showing hiddenReactionView
    if abs(xDelta) > CardViewConstants.maxDeltaForHiddenView {
      hiddenTopReactionView.toggleReaction(like: xDelta > 0)
      let alpha = (abs(xDelta) - CardViewConstants.maxDeltaForHiddenView) / 100
      hiddenTopReactionView.alpha = alpha
    }
    
    recognizer.setTranslation(.zero, in: self)
  }
  
  func gestureEnded(with velocity: CGFloat = 0) {
    let xDelta = center.x - startPoint.x
    if xDelta > CardViewConstants.maxDelta || velocity > CardViewConstants.maxVelocity {
      swipe(liked: true)
    } else if xDelta < -CardViewConstants.maxDelta || velocity < -CardViewConstants.maxVelocity {
      swipe(liked: false)
    } else {
      animateToIdentity()
    }
  }
  
}
