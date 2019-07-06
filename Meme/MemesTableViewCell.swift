//
//  MemesTableViewCell.swift
//  Meme
//
//  Created by Ruhsane Sawut on 1/14/19.
//  Copyright © 2019 ruhsane. All rights reserved.
//

import UIKit
import ROGoogleTranslate


class MemesTableViewCell: UITableViewCell {

    @IBOutlet weak var detectedText: UITextView!
    @IBOutlet weak var downScroll: UIImageView!
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var translatedText: UITextView!
    @IBAction func translateButton(_ sender: Any) {
        self.translate(source: self.detectedText.text)
        
    }


    func setMeme(meme: Meme) {
        memeImage.image = meme.memeImage
        detectedText.text = meme.detectedText ?? "loading"
        translatedText.text = meme.translatedText ?? "loading"
    }
    
    
    func translate(source: String) {
        let translator = ROGoogleTranslate()
        translator.apiKey = "AIzaSyBrwV0kCyy5LcowEbdHePx2roWE1pPI1Wk" // Add your API Key here

        var params = ROGoogleTranslateParams()
        params.source = "en"
        //        params.target = toLanguage.text ?? "de"  //let user choose target language
        params.target = "zh"

        params.text = source

        translator.translate(params: params) { (result) in
            DispatchQueue.main.async {
                self.translatedText.text = "\(result)"
                print(result)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
