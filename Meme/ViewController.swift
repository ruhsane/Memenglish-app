//
//  ViewController.swift
//  Meme
//
//  Created by Ruhsane Sawut on 1/9/19.
//  Copyright © 2019 ruhsane. All rights reserved.
//

import UIKit
import Dispatch
import FirebaseMLVision
import ROGoogleTranslate

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    //    @IBOutlet weak var tableViewCell: UITableViewCell!
    
    //    @IBOutlet weak var detectedText: UITextView!
    //    @IBOutlet weak var translatedText: UITextView!
    @IBAction func translateButton(_ sender: Any) {
        //        self.translate(source: self.detectedText.text)
        
    }
    
    var memes: [Meme] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        DispatchQueue.global(qos: .background).async {
            self.fetchMemes { [weak self] (fetchedMemes) in
                self?.memes = fetchedMemes
                self?.translateMemes()
       
                DispatchQueue.main.async {
                    //reload the table view with the images from each meme
                    self?.tableView.reloadData()
                    
                }
            }
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    func fetchMemes(completion: ([Meme]) -> Void) {
        var tempMemes: [Meme] = []
        
        for i in 1..<11 {
            let name: String = "meme" + i.description
            //            var memeText = ""
            //            textDetect(image: UIImage(named: name)!) { (textString) in
            //                print(textString)
            //                memeText = textString
            //            }
            //
            //            var transtxt = ""
            //            translate(source: memeText) { (trans) in
            //                transtxt = trans
            //            }
            
            let meme = Meme(memeImage: UIImage(named: name)!, detectedText: nil, translatedText: nil)
            //            print(UIImage(named: name)!)
            //            print(meme)
            tempMemes.append(meme)
            
        }
        //        print(tempMemes)
        completion(tempMemes)
    }
    
    //    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    //        let memeIndexesToPrefetch = indexPaths.map { $0.row }
    //
    //        for aMemeIndex in memeIndexesToPrefetch {
    //            let meme = self.memes[aMemeIndex]
    //
    //            // fetch the text from the image
    //            textDetect(image: meme.memeImage) { [weak self] (detectedText) in
    //                guard let unwrappedSelf = self else { return }
    //
    //                // check if text from image is not empty or nil
    //                if let detectedText = meme.detectedText, detectedText.isEmpty == false {
    //                    meme.detectedText = detectedText
    //
    //                    // fetch the translation from the detected text
    //                    unwrappedSelf.translate(source: detectedText) { (translatedText) in
    //                        meme.translatedText = translatedText
    //                    }
    //                } else {
    //
    //                    // no text detected, default to this
    //                    meme.detectedText = "there's no text"
    //                    meme.translatedText = "there's no text"
    //                }
    //            }
    //        }
    //    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        let meme = memes[indexPath.row]
//        print(meme.memeImage)
//        print(memes)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MemesTableViewCell
        
        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        cell.memeImage.addGestureRecognizer(pictureTap)

        
        cell.setMeme(meme: meme)
//        let ratio = meme.memeImage.size.width / meme.memeImage.size.height
//        let newHeight = view.frame.width / ratio
//        cell.memeImage.frame.size = CGSize(width: view.frame.width, height: newHeight)
        return cell
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenSize = view.frame
        let screenHeight = screenSize.height
        print(screenHeight)
        return screenHeight
    }

    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func translateMemes() {
        
        for (index, meme) in self.memes.enumerated() {
            
            // fetch the text from the image
            textDetect(image: meme.memeImage) { [weak self] (detectedText) in
                guard let unwrappedSelf = self else { return }
                
                // check if text from image is not empty or nil
                if detectedText.isEmpty == false {
                    meme.detectedText = detectedText
                    
                    // fetch the translation from the detected text
                    unwrappedSelf.translate(source: detectedText) { (translatedText) in
                        meme.translatedText = translatedText
                        unwrappedSelf.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                    }
                } else {
                    
                    // no text detected, default to this
                    meme.detectedText = "there's no text"
                    meme.translatedText = "there's no text"
                    unwrappedSelf.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
            }
        }
    }
    
    func textDetect(image: UIImage, completionHandler: @escaping (String) -> Void ) {
        
        print(image.description)
        
        let vision = Vision.vision()
        let textRecognizer = vision.onDeviceTextRecognizer()
        let image = VisionImage(image: image)
        
        textRecognizer.process(image) { result, error in
            guard error == nil, let result = result else {
                // ...
                print("not recognized")
                return
            }
            
            let resultText = result.text
            print("recognized text", resultText)
            completionHandler(resultText)
        }
    }
    
    
    func translate(source: String, completion: @escaping (String) -> Void ) {
        let translator = ROGoogleTranslate()
        translator.apiKey = "AIzaSyBrwV0kCyy5LcowEbdHePx2roWE1pPI1Wk" // Add your API Key here
        
        var params = ROGoogleTranslateParams()
        params.source = "en"
        //        params.target = toLanguage.text ?? "de"  //let user choose target language
        params.target = "zh"
        
        params.text = source
        
        translator.translate(params: params) { (result) in
            DispatchQueue.main.async {
                //                self.translatedText.text = "\(result)"
                print(result)
                completion(result)
            }
        }
    }
    
}

