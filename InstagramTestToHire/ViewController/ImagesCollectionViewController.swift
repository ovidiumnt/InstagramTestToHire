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

// We get an instance of InstagramApiFactory class (that implements / conform to the InstagramApiProtocol) using the injected factory
private let instagramApi = InstagramApiFactory.instagramApiInstance()

// MARK: - CollectionView Layout
// Extension cu customize the layout of
extension ImagesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 15 - 15, height: 240)
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
}

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
        
        // Set the token and get the Instagram media!
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        
        // But we are using a prototype cell, so we don't this default behaviour
        // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView!.collectionViewLayout = self.getLayout()
        
        instagramApi.apiGetMediaData = apiGetMediaData
        instagramApi.apiGetMedia = apiGetMedia

        mediaArray = NSMutableArray()
        getInstagramImages()
    }
    
    func getInstagramImages() {
        instagramApi.getMedia { (userMedia: UserMedia) in
            if userMedia.media_type != UserMedia.MediaType.VIDEO {
                guard let mediaUrl = userMedia.media_url else {
                    print("Media URL is null. There are no pictures or videos on the account.")
                    return
                }

                self.mediaArray!.add(mediaUrl)
                //print("Am gasit: \(self.mediaArray?.count) item-uri")
            
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
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
        cell.layer.cornerRadius = 12.0
        
        let url = URL(string: mediaArray![indexPath.row] as! String)
        downloadImage(from: url!, imageView: cell.instagramImageView)
        
        /*let url = URL(string: "https://scontent.cdninstagram.com/v/t51.2885-15/19933412_490344898024250_6550875001090736128_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=8ae9d6&_nc_ohc=q-k5VngxTmMAX82eXL3&_nc_ht=scontent.cdninstagram.com&edm=ANQ71j8EAAAA&oh=00_AfBd3WayyMRN4S7ujqFwBRRwHNk9Sz64pjAl-BoPH9jzig&oe=63834452")
         
         downloadImage(from: url!, imageView: cell.instagramImageView)*/
    
        return cell
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
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
    
    func getLayout() -> UICollectionViewLayout
        {
            let layout:UICollectionViewFlowLayout =  UICollectionViewFlowLayout()

            layout.itemSize = CGSize(width: 150, height: 150)
            layout.sectionInset = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)

            return layout as UICollectionViewLayout

        }
}
