//
//  DoggoStyloCollectionControllerCollectionViewController.swift
//  DoggoStylo2.0
//
//  Created by Jovan Radivojsa on 9/23/18.
//  Copyright © 2018 Jovan Radivojsa. All rights reserved.
//

import UIKit
import GSImageViewerController
import DBDebugToolkit

private let reuseIdentifier = "DoggoCollectionCell"

class DoggoStyloCollectionController: UICollectionViewController {
    // MARK:- Properties
    var displayArray: [UIImage]?
    
    
    // MARK:- Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dispArray = displayArray {
            let imageNumber = DBDebugToolkit.customVariable(withName: "imageCount")
            let num = (imageNumber?.value as? Int) ?? dispArray.count
            return num
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let doggoCell = cell as? DoggoCollectionCell {
            doggoCell.displayContent(image: displayArray![indexPath.row])
        }
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DoggoCollectionCell, let image = cell.imageView.image {
            let imageInfo = GSImageInfo(image: image, imageMode: .aspectFit)
            let imageViewer = GSImageViewerController(imageInfo: imageInfo)
            navigationController?.pushViewController(imageViewer, animated: true)
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
