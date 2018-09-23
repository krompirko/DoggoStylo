//
//  DoggoStyloNavigationController.swift
//  DoggoStylo2.0
//
//  Created by Jovan Radivojsa on 9/23/18.
//  Copyright © 2018 Jovan Radivojsa. All rights reserved.
//

import UIKit

class DoggoStyloNavigationController: UINavigationController {
    
    // MARK:- Constants.
    struct SegueIdentifiers {
        static var BreedsToSubBreeds = "ShowSubBreeds"
        static var BreedsToImageGrid = "ShowBreedImages"
        static var SubBreedsToImageGrid = "ShowSubBreedImages"
    }
    
    struct SceneTitles {
        static var BreedsTitle = "Breeds"
        static var SubBreedsTitle = "Subspecies"
        static var ImageGridTitle = "Images"
    }

    // MARK:- Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        DoggoFetcher.Initialize(callWhenCompleted: doggoFetcherInitialized)
        DoggoFetcher.completedImageLoading = imagesLoaded
    }
    
    func doggoFetcherInitialized() {
        displayContentState = .DisplayBreeds
        if let tableViewController = viewControllers[0] as? DoggoStyloTableController {
            initBreedTableViewController(breedTableController: tableViewController)
        }
    }
    
    func imagesForBreedFetched() {
        DoggoFetcher.fetchRandomImagesFromURLArray(count: 10)
    }
    
    func imagesLoaded() {

        if let collectionViewController = viewControllers[viewControllers.count - 1] as? DoggoStyloCollectionController {
            initGridImageCollectionView(imageGridCollectionController: collectionViewController)
            collectionViewController.collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK:- Breed Table
    func initBreedTableViewController(breedTableController: DoggoStyloTableController) {
            breedTableController.displayArray = DoggoFetcher.breedList
            breedTableController.selectedCallback = breedSelectedCallback
            breedTableController.navigationControllerSegueHandler = localPrepareForSegue
            breedTableController.title = SceneTitles.BreedsTitle
            breedTableController.tableView.reloadData()
    }
    
    func breedSelectedCallback(breed: String) {
        DoggoFetcher.selectedBreed = breed
        if let tableViewController = viewControllers[0] as? DoggoStyloTableController {
            if let subBreedArray = DoggoFetcher.subBreedList, subBreedArray.count > 1 {
                // Go to display subBreeds
                displayContentState = .DisplaySubBreeds
                tableViewController.performSegue(withIdentifier: SegueIdentifiers.BreedsToSubBreeds , sender: tableViewController)
                
            } else  {
                // Go to display image grid.
                DoggoFetcher.selectedSubBreed = nil
                tableViewController.performSegue(withIdentifier: SegueIdentifiers.BreedsToImageGrid, sender: tableViewController)
                DoggoFetcher.fetchImageURLArray(fetchCompletedCallback: imagesForBreedFetched)
                displayContentState = .DisplayImageGrid
            }
        }
    }
    
    // MARK: SubBreed Table View
    func initSubBreedTableViewController(subBreedTableController: DoggoStyloTableController) {
        subBreedTableController.displayArray = DoggoFetcher.subBreedList
        subBreedTableController.selectedCallback = subBreedSelectedCallback
        subBreedTableController.navigationControllerSegueHandler = localPrepareForSegue
        subBreedTableController.title = SceneTitles.SubBreedsTitle
    }
    
    func subBreedSelectedCallback(subBreed: String) {
         DoggoFetcher.selectedSubBreed = subBreed
        if let tableViewController = viewControllers[1] as? DoggoStyloTableController {
            // Go to display image grid - subBreeds.
            DoggoFetcher.fetchImageURLArray(fetchCompletedCallback: imagesForBreedFetched)
            displayContentState = .DisplayImageGrid
            tableViewController.performSegue(withIdentifier: SegueIdentifiers.SubBreedsToImageGrid, sender: tableViewController)

        }
    }
    
    // Grid collection view.
    func initGridImageCollectionView(imageGridCollectionController: DoggoStyloCollectionController) {
        imageGridCollectionController.displayArray = DoggoFetcher.imageArray
        imageGridCollectionController.title = SceneTitles.ImageGridTitle
    }
    
    // MARK:- States
    enum DisplayContentState {
        case None
        case DisplayBreeds
        case DisplaySubBreeds
        case DisplayImageGrid
        case DisplayImage
    }
    var displayContentState = DisplayContentState.None
    
    
    // MARK:- Segues
    func localPrepareForSegue(for segue: UIStoryboardSegue) {
        switch displayContentState {
        case .DisplaySubBreeds:
            if let destinationController = segue.destination as? DoggoStyloTableController {
                initSubBreedTableViewController(subBreedTableController: destinationController)
            }
        case .DisplayImageGrid:
            if let destinationController = segue.destination as? DoggoStyloCollectionController {
                initGridImageCollectionView(imageGridCollectionController: destinationController)
            }
        default:
            break
        }
    }

}
