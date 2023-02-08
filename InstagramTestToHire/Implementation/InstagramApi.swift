//
//  InstagramApi.swift
//  InstagramTestToHire
//
//  Created by Ovidiu Muntean on 24.11.2022.
//

import Foundation

class InstagramApi : InstagramApiProtocol {
    
    // Implementation class of the InstagramApiProtocol protocol (interface) 
    var apiGetMediaData: String = ""
    var apiGetMedia: String = ""

    init(apiGetMediaData: String, apiGetMedia: String) {
        self.apiGetMediaData = apiGetMediaData
        self.apiGetMedia = apiGetMedia
    }
    
    var token: String = ""
    
    func getMediaData(completion: @escaping (UserFeed) -> Void) {
        // Call the API that will retutn the jSON with the array of ID's
        let urlString = "\(apiGetMediaData)?fields=id,caption&access_token=\(token)"
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if response != nil {
                print(response!)
            }
            do {
                guard let data = data else {
                    return
                }
                
                let jsonData = try JSONDecoder().decode(UserFeed.self, from: data)
                print("JSON:\n\(jsonData.data)")

                // We have the JSON
                // And we call the closure with the jsonData (returned from API) as a parameter
                // This closure will iterate through the array of ID's returned by the deserialized JSON
                // And for each ID we call the API that returns the media_url
                completion(jsonData)
            } catch let error as NSError {
                print(error)
            }
        })
        task.resume()
    }
    
    func getMedia(completion: @escaping (UserMedia) -> Void) {
        getMediaData { (userFeed: UserFeed) in
            
            // Iterate through ID's and call the API that will return the media for each ID
            for i in 0..<userFeed.data.count {
                let urlString = "\(self.apiGetMedia)\(userFeed.data[i].id)?fields=id,media_type,media_url,username,timestamp&access_token=\(self.token)"
                let request = URLRequest(url: URL(string: urlString)!)
                let session = URLSession.shared
                
                let task = session.dataTask(with: request, completionHandler: { data, response, error in
                    if response != nil {
                        print(response!)
                    }
                    do {
                        guard let data = data else {
                            return
                        }
                        
                        let jsonData = try JSONDecoder().decode(UserMedia.self, from: data)
                        
                        // We have the json
                        // So we call the closure with it as a parameter
                        // The closure itself will create an array of media_url's
                        completion(jsonData)
                        
                    } catch let error as NSError {
                        print(error)
                      }
                })
                task.resume()
            }
        }
    }
}
