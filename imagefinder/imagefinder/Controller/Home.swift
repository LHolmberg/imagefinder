import UIKit
import DropDown

class Home : UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var currentCategoryTxt: UILabel!
    
    var likedPictures : [String] = [String]()
    var didLike : String = ""
    let dropDown = DropDown()
    
    var selectedCategory: String = "Computer"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Dropdown setup
        dropDown.anchorView = view
        dropDown.dataSource = ["Computer", "Flower", "Animal", "Coffee", "Book", "Science"]
        GetImage(liked: false)
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedCategory = item == "" ? "Animal" : item
            self.currentCategoryTxt.text = "Current category: " + self.selectedCategory
        }
        
        dropDown.width = self.view.frame.width / 2
        dropDown.bottomOffset = CGPoint(x: 0, y: 100)
        
        dropDown.separatorColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        dropDown.backgroundColor = #colorLiteral(red: 0.2348112315, green: 0.2348112315, blue: 0.2348112315, alpha: 1)
        dropDown.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        dropDown.selectionBackgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        dropDown.dismissMode = .onTap
        
        dropDown.selectRow(0)
        self.currentCategoryTxt.text = "Current category: " + self.selectedCategory
    }
    
    @IBAction func ChangeCategoryBtn(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func ShowLikedFeed(_ sender: Any) {
        let popover = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpID") as! LikedPicturesFeed
        self.addChild(popover)
        popover.view.frame = self.view.frame
        self.view.addSubview(popover.view)
        popover.didMove(toParent: self)
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
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                self.image.image = UIImage(data: data)
            }
        }
    }

    func GetImage(liked : Bool) {
        if(liked == true) {
            self.likedPictures.append(self.didLike)
            UserDefaults.standard.set(self.likedPictures, forKey: "likedPictures")
        }
        
        let url = URL(string: "https://pixabay.com/api/?key=15164472-d0633fdf469be822e5495bdfa&q=" + self.selectedCategory + "&image_type=photo&pretty=true")!
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
                    let image: String! = (chosenHit["largeImageURL"] as! String)
                    
                    self.didLike = image // Previous image
                    
                    self.downloadImage(from: URL(string: image)!)
                }
            }
        }
        task.resume()
    }
    
    @IBAction func DislikeImage(_ sender: Any) {
        GetImage(liked: false)
    }
    
    @IBAction func LikeImage(_ sender: Any) {
        GetImage(liked: true)
    }
}
