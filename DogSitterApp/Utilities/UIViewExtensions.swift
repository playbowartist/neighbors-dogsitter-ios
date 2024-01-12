//
//  UIViewExtensions.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 9/23/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import UIKit

extension UIView {
    func addBackground(image: UIImage) {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = image
        imageViewBackground.contentMode = UIView.ContentMode.left
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }
}
