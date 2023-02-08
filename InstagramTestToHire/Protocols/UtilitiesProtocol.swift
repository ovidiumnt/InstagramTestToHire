//
//  UtilitiesProtocol.swift
//  InstagramTestToHire
//
//  Created by Ovidiu Muntean on 08.02.2023.
//

import Foundation
import UIKit

protocol UtilitiesProtocol {
    func downloadImage(from url: URL, imageView: UIImageView)
    func getInstagramImagesFromAPI(completion: @escaping (String) -> Void)
    func getLayout() -> UICollectionViewLayout
}
