//
//  Utilities.swift
//  InstagramTestToHire
//
//  Created by Ovidiu Muntean on 08.02.2023.
//

import Foundation
import UIKit

class Utilities: UtilitiesProtocol {
    
    private var instagramApi: InstagramApiProtocol
    
    init(_ instagramApi: InstagramApiProtocol) {
        self.instagramApi = instagramApi
    }
    
    func downloadImage(from url: URL, imageView: UIImageView) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            
            DispatchQueue.main.async() {
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    func getInstagramImagesFromAPI(completion: @escaping (String) -> Void) {
        instagramApi.getMedia { (userMedia: UserMedia) in
            if userMedia.media_type != UserMedia.MediaType.VIDEO {
                guard let mediaUrl = userMedia.media_url else {
                    print("Media URL is null. There are no pictures or videos on the account.")
                    return
                }

                completion(mediaUrl)
            }
        }
    }
    
    func getLayout() -> UICollectionViewLayout {
        let layout:UICollectionViewFlowLayout =  UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 320, height: 320)
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        return layout as UICollectionViewLayout
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
