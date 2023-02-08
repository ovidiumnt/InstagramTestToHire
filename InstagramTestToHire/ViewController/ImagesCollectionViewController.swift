//
//  ImagesCollectionViewController.swift
//  InstagramTestToHire
//
//  Created by Ovidiu Muntean on 24.10.2022.
//

import UIKit

// MARK: - Properties
private let reuseIdentifier = "dataCell"
private let apiGetMediaData = "https://graph.instagram.com/me/media"
private let apiGetMedia = "https://graph.instagram.com/"

// Get an instance of InstagramApi class (that implements / conforms to the InstagramApiProtocol)
private var instagramApi: InstagramApiProtocol = InstagramApi(apiGetMediaData: apiGetMediaData, apiGetMedia: apiGetMedia)

// Get an instance of Utilities class
// Using DI to pass the instance of InstagramApi class to the Utilities constructor
private let utilities: UtilitiesProtocol = Utilities(instagramApi)

// MARK: - Text Field Delegate
// Extension for the editText delegate from the toolbar where we can set the token
extension ImagesCollectionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard
            let text = textField.text,
            !text.isEmpty
        else { return true }
        
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        
        // Set the token and get the Instagram media
        instagramApi.token = text
        mediaArray = NSMutableArray()
        
        getInstagramImages()
        
        textField.text = nil
        textField.resignFirstResponder()
        
        return true
    }
}

class ImagesCollectionViewController: UICollectionViewController {
    
    var mediaArray: NSMutableArray?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Since we are using a prototype cell we don't need this default behaviour
        // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView!.collectionViewLayout = utilities.getLayout()

        mediaArray = NSMutableArray()
        getInstagramImages()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        return mediaArray!.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImagesCollectionViewCell
        
        cell.layer.cornerRadius = 0.0
        cell.clipsToBounds = true
        
        let url = URL(string: mediaArray![indexPath.row] as! String)
        utilities.downloadImage(from: url!, imageView: cell.instagramImageView)
    
        return cell
    }
    
    func getInstagramImages() {
        // Trailing closure syntax
        utilities.getInstagramImagesFromAPI { (mediaUrl: String) in
            self.mediaArray!.add(mediaUrl)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}
