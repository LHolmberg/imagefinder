import UIKit

class LikedPicturesFeed : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let likedPictures = UserDefaults.standard.stringArray(forKey: "likedPictures") ?? [String]()
    @IBOutlet weak var tableView: UITableView!
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! TTableViewCell
        let url = URL(string: self.likedPictures[indexPath .row])!
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                cell.img.image = UIImage(data: data)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedPictures.count
    }

    
    @IBAction func Dismiss(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
}
