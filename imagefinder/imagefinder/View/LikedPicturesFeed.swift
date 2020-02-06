//
//  LikedPicturesFeed.swift
//  imagefinder
//
//  Created by Lukas Holmberg on 2020-02-06.
//  Copyright © 2020 Stefan Holmberg. All rights reserved.
//

import UIKit

class LikedPicturesFeed : UIViewController, UITableViewDataSource, UITableViewDelegate {
    let myarray = UserDefaults.standard.stringArray(forKey: "likedPictures") ?? [String]()
    @IBOutlet weak var tableView: UITableView!
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! TTableViewCell
        let url = URL(string: self.myarray[indexPath .row])!
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                cell.img.image = UIImage(data: data)
                
            }
        }
        return cell
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myarray.count
    }

    
    @IBAction func Dismiss(_ sender: Any) {
        let parentVC = (self.parent)! as! Home
        self.view.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
}
