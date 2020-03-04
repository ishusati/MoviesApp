

import UIKit
import Firebase
import SDWebImage

class ProfileVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet var lblTital: UILabel!
    @IBOutlet var ImgProfile: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblPassword: UILabel!
    @IBOutlet var lblFavoriteMoviesCount: UILabel!
    @IBOutlet var lblFavoriteActorsCount: UILabel!
    
    //MARK:- Variable
    var ArrFavoriteMoviesCount = [FavoriteMovies]()
    var ArrFavoriteActorsCount = [FavoriteActors]()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.applyGradient(locations:  [0.1, 1.1])
        
        self.ImgProfile.layer.cornerRadius = self.ImgProfile.frame.height/2
        self.ImgProfile.clipsToBounds = true
        self.ImgProfile.layer.borderWidth = 1.5
        self.ImgProfile.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    //MARK:- ViewWillAppear
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if (Reachability.isConnectedToNetwork() == true)
        {
            self.ArrFavoriteActorsCount.removeAll()
            self.ArrFavoriteMoviesCount.removeAll()
            
            let LoginID = NSUserDefaultClass.sharedInstance.getUserDetails()?.Id
            let ref = Database.database().reference().child("favoritemovies")
            ref.observe(.childAdded, with: { snapshot in
                let dict = snapshot.value as! [String: Any]
                let UserId = dict["UserId"] as? String ?? ""
                let MoviesId = dict["MoviesId"] as? String ?? ""
                let MoviesName = dict["MoviesName"] as? String ?? ""
                let MoviesPoster = dict["MoviesPoster"] as? String ?? ""
                
                if UserId == LoginID
                {
                    self.ArrFavoriteMoviesCount.insert(FavoriteMovies(UserId: UserId, MoviesId: MoviesId, MoviesName: MoviesName, MoviesPoster: MoviesPoster), at: 0)
                    self.lblFavoriteMoviesCount.text = "Favorite Movies Count :- \(String(self.ArrFavoriteMoviesCount.count))"
                }
            })
            
            
            let ref1 = Database.database().reference().child("favoriteactors")
            ref1.observe(.childAdded, with: { snapshot in
                let dict = snapshot.value as! [String: Any]
                let UserId = dict["UserId"] as? String ?? ""
                let CastId = dict["CastId"] as? String ?? ""
                let CastName = dict["CastName"] as? String ?? ""
                let CastProfileUrl = dict["CastProfileUrl"] as? String ?? ""
                
                if UserId == LoginID
                {
                    self.ArrFavoriteActorsCount.insert(FavoriteActors(UserId: UserId, CastId: CastId, CastName: CastName, CastProfileUrl: CastProfileUrl), at: 0)
                    self.lblFavoriteActorsCount.text = "Favorite Actors Count :- \(String(self.ArrFavoriteActorsCount.count))"
                }
            })
            
            let UserName = NSUserDefaultClass.sharedInstance.getUserDetails()?.Name
            self.lblUserName.text = "UserName:- \(UserName ?? "")"
            let Email = NSUserDefaultClass.sharedInstance.getUserDetails()?.Email
            self.lblEmail.text = "Email:- \(Email ?? "")"
            self.lblPassword.text = "********"
            let ProfileImage = NSUserDefaultClass.sharedInstance.getUserDetails()?.profile_pic
            self.ImgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.ImgProfile.sd_setImage(with: URL(string: ProfileImage!), placeholderImage: UIImage(named: ""))
            
        }
        else
        {
            let net = appDelegate.InternetConnectionErrorApp(view: self.view)
            net.isUserInteractionEnabled = true
            net.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeNetView)))
        }
    }
    
    @objc func removeNetView()
    {
        if(Reachability.isConnectedToNetwork() == true)
        {
            appDelegate.RemoveNetworkLostView()
        }
        else
        {
            print("*******************************-: Network Reachability Error :-*******************************")
        }
    }
    
    //MARK:- Action
    @IBAction func btnLogout(_ sender: Any)
    {
        let Alert = UIAlertController(title: "Are you sure you to logout..?", message: "", preferredStyle: .alert)
        
        let No = UIAlertAction(title: "No", style: .default) { (UIAlertAction) in
        }
        Alert.addAction(No)
        
        let Yes = UIAlertAction(title: "Yes", style: .cancel) { (UIAlertAction) in
            NSUserDefaultClass.sharedInstance.setIsLoggin(isLoggin: false)
            appDelegate.checkLoginStatus()
        }
        Alert.addAction(Yes)
        
        self.present(Alert, animated: true, completion: nil)
    }    
}
















































