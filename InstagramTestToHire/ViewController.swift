//
//  ViewController.swift
//  InstagramTestToHire
//
//  Created by Ovidiu Muntean on 21.10.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var instagramApi = InstagramApi.instagramApi
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchImageToBackground()
    }
    
    func fetchImageToBackground() {
        self.instagramApi.getMedia() { (media) in
            if media.media_type != UserMedia.MediaType.VIDEO {
                guard let media_url = media.media_url else {
                    print("Media URL is null. There are no pictures or videos on the account.")
                    return
                }
                
                self.instagramApi.fetchImage(urlString: media_url, completion: { (fetchedImage) in
                    if let imageData = fetchedImage {
                        DispatchQueue.main.async {
                            self.backgroundImageView.image = UIImage(data: imageData)
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
}

