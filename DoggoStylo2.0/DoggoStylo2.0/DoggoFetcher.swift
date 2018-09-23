//
//  DoggoFetcher.swift
//  DoggoStylo2.0
//
//  Created by Jovan Radivojsa on 9/23/18.
//  Copyright © 2018 Jovan Radivojsa. All rights reserved.
//

import Foundation
import Alamofire

class DoggoFetcher {
    // MARK:- Properties
    private(set) static var breedList: [String]? = nil
    private(set) static var breedtoSubBreedDictionary: [String: [String]]? = nil {
        didSet {
            breedList = breedtoSubBreedDictionary != nil ? Array(breedtoSubBreedDictionary!.keys) : nil
        }
    }
    private(set) static var fetchedImageURLs: [String]? = nil
    private(set) static var selectedImage: UIImage? = nil
    static var subBreedList: [String]? {
        if let sb = selectedBreed, let btsbd = breedtoSubBreedDictionary {
            return btsbd[sb]
        }
        return nil
    }
    static var selectedBreed: String? = nil
    

    // MARK:- Constants
    struct DogAPIConstants
    {
        static let testHoudImage = "https://images.dog.ceo/breeds/hound-basset/n02088238_10473.jpg"
        static let allBreedsListURL = "https://dog.ceo/api/breeds/list/all"
        static let allBreedsMessage = "message"
        
        // Example full - (h)ttps://dog.ceo/api/breed/ + <breed-subBreed> + /images
        static let breedImageListPrefix = "https://dog.ceo/api/breed/"
        static let breadImageListTrail = "/images"
    }
    
    // MARK:- Initialization.
    static func Initialize(callWhenCompleted initCompleteCallback: @escaping () -> ()) {
        fetchBreedsAndSubBreedsDictionary(fetchCompletedCallback: initCompleteCallback)
    }
    
    // MARK:- Fetch Methods
    static func fetchBreedsAndSubBreedsDictionary(fetchCompletedCallback: @escaping () -> Void ) {
        let dataRequest = Alamofire.request(DogAPIConstants.allBreedsListURL)
        dataRequest.responseJSON { response in
            if
                let dogListJSON = response.result.value,
                let responseDictionary = dogListJSON as? Dictionary<String, Any>,
                1 == 1,
                "a" < "b" {
                DoggoFetcher.breedtoSubBreedDictionary = responseDictionary[DogAPIConstants.allBreedsMessage] as? Dictionary<String, Array<String>>
                fetchCompletedCallback()
            }
        }
    }
    
    static func fetchImmageArrayForBreed(breed: String, fetchCompletedCallback: @escaping () -> Void )
    {
        let imageListURL = DogAPIConstants.breedImageListPrefix + breed + DogAPIConstants.breadImageListTrail
        let dataRequest = Alamofire.request(imageListURL)
        dataRequest.responseJSON { response in
            if let dogListJSON = response.result.value {
                if let responseDictionary = dogListJSON as? Dictionary<String, Any> {
                    DoggoFetcher.fetchedImageURLs = responseDictionary[DogAPIConstants.allBreedsMessage] as? Array<String>
                    fetchCompletedCallback()
                }
            }
        }
    }
    
    static func fetchImageFromCurrentArray(index: Int, fetchCompletedCallback: @escaping () -> Void ) {
        if let urlArray = DoggoFetcher.fetchedImageURLs {
            let imageURL = urlArray[index]
            let dataRequest = Alamofire.request(imageURL)
            dataRequest.responseData { response in
                if response.error == nil {
                    print(response.result)
                    
                    // Set the fetched image.
                    if let data = response.data {
                        selectedImage = UIImage(data: data)
                        fetchCompletedCallback()
                    }
                }
            }
        }
        
    }
}
