//
//  InstagramAPI.swift
//  InstagramTestToHire
//
//  Created by Ovidiu Muntean on 21.10.2022.
//

import Foundation

class InstagramApi {
    static let instagramApi = InstagramApi()
    
    private let apiGetMediaData = "https://graph.instagram.com/me/media"
    private let apiGetMedia = "https://graph.instagram.com/"
    private let token = "IGQVJVdjJlMlNNamZAZAYnAydXNlNEczaFlBTXVDZA2p6ckxUV1J5aUttanJhNWNRdzMxbVk4dG1FdzFMNVNqazB2T1FXcU15d2VIUjE2SlNvdHFLdDJRNGVuN25sYUU0Y0phSG15RjgzZA3lkdHBjSS1uNQZDZD"

    private init () {

    }
    
    // Citim datele din API pentru token-ul userului respectiv
    // UserFeed este clasa model pentru deserializarea JSON-ului returnat de API
    private func getMediaData(completion: @escaping (UserFeed) -> Void) {
        
        let urlString = "\(apiGetMediaData)?access_token=\(token)"
        print("API <apiGetMediaData>:\n\(urlString) \n\n")
        
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let response = response {
                print(response)
            }
            do {
                let jsonData = try JSONDecoder().decode(UserFeed.self, from: data!)
                print(jsonData)
                completion(jsonData)
            } catch let error as NSError {
                print(error)
            }
        })
        task.resume()
    }
    
    // Pentru fiecare media data din array-ul returnat de JSON din functia de mai sus
    // Citim JSON-ul care ar trebui sa returneze media (poze / clipuri)
    func getMedia(completion: @escaping (UserMedia) -> Void) {
        getMediaData() { (mediaFeed) in
            for i in 0..<(mediaFeed.data.count - 1) {
                let urlString = "\(self.apiGetMedia)\(mediaFeed.data[i].id)?access_token=\(self.token)"
                print("API <apiGetMedia>:\n\(urlString) \n\n")
                
                let request = URLRequest(url: URL(string: urlString)!)
                let session = URLSession.shared
                
                let task = session.dataTask(with: request, completionHandler: { data, response, error in
                    if let response = response {
                        print(response)
                    }
                    do {
                        let jsonData = try JSONDecoder().decode(UserMedia.self, from: data!)
                        print(jsonData)
                        completion(jsonData)
                    } catch let error as NSError {
                        print(error)
                      }
                })
                task.resume()
            }
        }
    }
    
    // Preluam imaginile efectiv si returnam un binar in Data
    func fetchImage(urlString: String, completion: @escaping (Data?) -> Void) {
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let response = response {
                print(response)
            }
            completion(data)
          })
        task.resume()
    }
}


