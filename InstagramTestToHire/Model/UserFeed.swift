//
//  UserFeed.swift
//  InstagramTestToHire
//
//  Created by Ovidiu Muntean on 21.10.2022.
//

import UIKit

class UserFeed: Codable {
    var data: [MediaData]
    var paging: PagingData
    
    struct MediaData: Codable {
        var id: String
    }
    
    struct PagingData: Codable {
        var cursors: CursorData
    }
    
    struct CursorData: Codable {
        var before: String
        var after: String
    }
}
