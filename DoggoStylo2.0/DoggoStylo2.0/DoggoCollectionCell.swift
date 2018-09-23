//
//  DoggoCollectionCell.swift
//  DoggoStylo2.0
//
//  Created by Jovan Radivojsa on 9/23/18.
//  Copyright © 2018 Jovan Radivojsa. All rights reserved.
//

import UIKit

class DoggoCollectionCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    func displayContent(image: UIImage) {
        imageView.image = image
    }
}
