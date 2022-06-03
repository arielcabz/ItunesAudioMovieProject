//
//  HeartButton.swift
//  Appetiser Code Challenge
//
//  Created by Ariel Dominic Cabanag on 2/5/22.
//

import Foundation
import UIKit
class HeartButton: UIButton {
    var isLiked = false
    
    private let unlikedImage = UIImage(named: "empty_heart")
    private let likedImage = UIImage(named: "filled_heart")
    
    private let unlikedScale: CGFloat = 0.7
    private let likedScale: CGFloat = 1.3

    override public init(frame: CGRect) {
      super.init(frame: frame)
      setImage(unlikedImage, for: .normal)
    }
  
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    public func flipLikedState() {
        isLiked = !isLiked
        animate()
    }
    
    /// Sets image state
    /// - Parameter liked: Bool value like status
    public func setImageState(liked: Bool) {
        self.isLiked = liked
        let newImage = liked ? self.likedImage : self.unlikedImage
        self.setImage(newImage, for: .normal)
    }
    
    /// Animate image change
    private func animate() {
        UIView.animate(withDuration: 0.1, animations: {
          let newImage = self.isLiked ? self.likedImage : self.unlikedImage
          let newScale = self.isLiked ? self.likedScale : self.unlikedScale
          self.transform = self.transform.scaledBy(x: newScale, y: newScale)
          self.setImage(newImage, for: .normal)
        }, completion: { _ in
          UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform.identity
          })
        })
    }
}
