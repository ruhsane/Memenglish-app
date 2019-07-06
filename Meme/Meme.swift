//
//  Meme.swift
//  Meme
//
//  Created by Ruhsane Sawut on 1/14/19.
//  Copyright © 2019 ruhsane. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    var memeImage: UIImage
    var detectedText: String?
    var translatedText: String?
    
    init(memeImage: UIImage, detectedText: String?, translatedText: String?) {
        self.memeImage = memeImage
        self.detectedText = detectedText
        self.translatedText = translatedText
    }
}
