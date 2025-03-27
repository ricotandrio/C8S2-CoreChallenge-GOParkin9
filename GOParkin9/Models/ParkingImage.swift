//
//  Image.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 26/03/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class ParkingImage {
    @Attribute(.externalStorage) var image: Data
     
    init(image: UIImage) {
        self.image = image.jpegData(compressionQuality: 0.8) ?? Data()
    }
    
    func getImage() -> UIImage {
        return UIImage(data: image) ?? UIImage()
    }
    
}
