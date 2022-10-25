//
//  ImagesCollectionViewController.swift
//  InstagramTestToHire
//
//  Created by Ovidiu Muntean on 24.10.2022.
//

import UIKit

private let reuseIdentifier = "Cell"
private let instagramApi = InstagramApi.instagramApi

class ImagesCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        
        // But we are using a prototype cell, so we don't this default behaviour
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        fetchImage()
    }

    func fetchImage() {
        instagramApi.getMedia() { (media) in
            if media.media_type != UserMedia.MediaType.VIDEO {
                guard let media_url = media.media_url else {
                    print("Media URL is null. There are no pictures or videos on the account.")
                    return
                }
                
                instagramApi.fetchImage(urlString: media_url, completion: { (fetchedImage) in
                    if let imageData = fetchedImage {
                        DispatchQueue.main.async {
                            // Parcurgem fiecare media si o punem in CollectionViewController-ul din UI.
                            // => trebuie studiat cum se face asta
                        }
                    } else {
                        print("Didn’t fetched the data.")
                    }
                })
                print(media_url)
            } else {
                print("Fetched media is a video.")
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        //Aici trebuie studiat cum returnez numarul de item-uri din <media> de la linia 31
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dataCell", for: indexPath) as! ImagesCollectionViewCell
           
               
        //
        //
        //
           
        return cell
    }
}
