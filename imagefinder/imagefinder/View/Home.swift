//
//  ViewController.swift
//  researchpapers
//
//  Created by Lukas Holmberg on 2020-02-05.
//  Copyright © 2020 Stefan Holmberg. All rights reserved.
//

import UIKit

class Home : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var categories: UIPickerView!
    
    var pickerData: [String] = [String]()
    var likedPictures : [String] = [String]()
    var didLike : String = ""
    
    @IBAction func ShowLikedFeed(_ sender: Any) {
        let popover = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpID") as! LikedPicturesFeed
        self.addChild(popover)
        popover.view.frame = self.view.frame
        self.view.addSubview(popover.view)
        popover.didMove(toParent: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categories.delegate = self
        self.categories.dataSource = self
        
        pickerData = ["Computer", "Flower", "Animal", "Coffee", "Book", "Science"]
        GetImage(liked: false)
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.image.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func GetImage(liked : Bool) {
        if(liked == true) {
            self.likedPictures.append(self.didLike)
            UserDefaults.standard.set(self.likedPictures, forKey: "likedPictures")
        }
        var selectedValue = pickerData[categories.selectedRow(inComponent: 0)]
        let url = URL(string: "https://pixabay.com/api/?key=15164472-d0633fdf469be822e5495bdfa&q="+selectedValue+"&image_type=photo&pretty=true")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                }
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    let dict = self.convertToDictionary(text: dataString)
                    let hits = dict!["hits"] as! NSArray
                    let chosenHit = hits[Int.random(in: 0 ..< hits.count)] as! Dictionary<String,Any>
                    var image : String! = chosenHit["largeImageURL"] as! String
                    self.didLike = image
                    self.downloadImage(from: URL(string: image)!)
                    
                }
            }
        }
        task.resume()
    }
    
    @IBAction func DislikeImage(_ sender: Any) {
        GetImage(liked: false)
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    @IBAction func DoCalculate(_ sender: Any) {
        GetImage(liked: true)
    }
}
