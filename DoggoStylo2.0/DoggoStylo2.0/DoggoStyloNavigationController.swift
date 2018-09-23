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
    }
    
    struct SceneTitles {
        static var BreedsTitle = "Breeds"
        static var SubBreedsTitle = "Subspecies"
        static var ImageGridTitme = "Images"
    }

    // MARK:- Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        DoggoFetcher.Initialize(callWhenCompleted: doggoFetcherInitialized)
    }
    
    func doggoFetcherInitialized() {
        displayContentState = .DisplayBreeds
        if let tableViewController = viewControllers[0] as? DoggoStyloTableController {
            initBreedTableViewController(breedTableController: tableViewController)
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
                tableViewController.performSegue(withIdentifier: SegueIdentifiers.BreedsToImageGrid, sender: tableViewController)
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
//        case .DisplayImageGrid:
        default:
            break
        }
    }

}
