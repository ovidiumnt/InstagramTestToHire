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
    private let token = "IGQVJXSXdTS1pEN2FrYkphT2wwNlZAIamVFWmZARWUNNTUVFbF9hTWdfM2FycVFfT056MmNfeTl6QzNyWVlaZA3dJNmNsNEtJSUJwdzBmWEhiUkw4VjRGbHBaWjU4MmJYaHhpc2tSWGxYczJlN0xVWE5ZAUQZDZD"

    private init () {

    }
    
    // Citim MediaData pentru token-ul userului respectiv
    private func getMediaData(completion: @escaping (UserFeed) -> Void) {
        
        let urlString = "\(apiGetMediaData)?access_token=\(token)"
        print("API <apiGetMediaData>:\n\(urlString) \n\n")
        
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let response = response {
                //print(response)
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
    // Parcurgem fiecare media si o punem in CollectionViewController-ul din UI. => cum se face asta?
    func getMedia(completion: @escaping (UserMedia) -> Void) {
        getMediaData() { (mediaFeed) in
            for i in 0..<(mediaFeed.data.count - 1) {
                let urlString = "\(self.apiGetMedia)\(mediaFeed.data[i].id)?access_token=\(self.token)"
                print("API <apiGetMedia>:\n\(urlString) \n\n")
                
                let request = URLRequest(url: URL(string: urlString)!)
                let session = URLSession.shared
                
                let task = session.dataTask(with: request, completionHandler: { data, response, error in
                    if let response = response {
                        //print(response)
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
    
    // Nu inteleg foarte clar ce face functia asta
    func fetchImage(urlString: String, completion: @escaping (Data?) -> Void) {
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let response = response {
                //print(response)
            }
            completion(data)
          })
        task.resume()
    }
}


