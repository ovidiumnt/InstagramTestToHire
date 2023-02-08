//
//  InstagramApi.swift
//  InstagramTestToHire
//
//  Created by Ovidiu Muntean on 24.11.2022.
//

import Foundation

protocol InstagramApiProtocol {
    
    // An protocol (interface) for Instagram API's
    var apiGetMediaData: String { get }
    var apiGetMedia: String { get }
    var token: String { get set }
    
    func getMediaData(completion: @escaping (UserFeed) -> Void)
    func getMedia(completion: @escaping (UserMedia) -> Void)
}
