//
//  UserMedia.swift
//  InstagramTestToHire
//
//  Created by Ovidiu Muntean on 21.10.2022.
//

import UIKit

class UserMedia: Codable {
    var id: String
    var media_type: MediaType?
    var media_url: String?
    var username: String?
    var timestamp: String?
    
    enum MediaType: String,Codable {
      case IMAGE
      case VIDEO
      case CAROUSEL_ALBUM
    }
}
