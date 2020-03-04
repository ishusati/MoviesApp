
import UIKit
import SDWebImage
import Firebase

class FavoriteVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet var SegmentView: UIView!
    @IBOutlet var ColleFavorite: UICollectionView!
    @IBOutlet var SegmentController: UISegmentedControl!
    
    //MARK:- Variable
    var ArrFavoriteMovies = [FavoriteMovies]()
    var ArrFavoriteActors = [FavoriteActors]()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.applyGradient(locations:  [0.1, 1.1])
        self.SetUpSegmentController()
    }
    
    //MARK:- ViewWillAppear
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if (Reachability.isConnectedToNetwork() == true)
        {
            self.ArrFavoriteActors.removeAll()
            self.ArrFavoriteMovies.removeAll()
            
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
                  self.ArrFavoriteMovies.insert(FavoriteMovies(UserId: UserId, MoviesId: MoviesId, MoviesName: MoviesName, MoviesPoster: MoviesPoster), at: 0)
                    self.ColleFavorite.reloadData()
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
                    self.ArrFavoriteActors.insert(FavoriteActors(UserId: UserId, CastId: CastId, CastName: CastName, CastProfileUrl: CastProfileUrl), at: 0)
                     self.ColleFavorite.reloadData()
                }
            })
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
    @IBAction func SegmentController(_ sender: UISegmentedControl)
    {
        print("Selected Index \(SegmentController.selectedSegmentIndex)")
        self.ColleFavorite.reloadData()
    }
    
    func SetUpSegmentController()
    {
        let IndexOne = [NSAttributedString.Key.font: UIFont(name: "Quicksand-Bold", size: 22)!,
                        NSAttributedString.Key.foregroundColor: UIColor.white]
        let IndexTwo = [NSAttributedString.Key.font: UIFont(name: "Quicksand-Bold", size: 17)!,
                        NSAttributedString.Key.foregroundColor: UIColor.black]
        
        SegmentController.setTitleTextAttributes(IndexOne, for:.selected)
        SegmentController.setTitleTextAttributes(IndexTwo, for:.normal)
    }
}


//MARK:- UICollection View DeleGate And DataSource Method
extension FavoriteVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if SegmentController.selectedSegmentIndex == 0
        {
            return ArrFavoriteMovies.count
        }
        else
        {
            return ArrFavoriteActors.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = ColleFavorite.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell

        if SegmentController.selectedSegmentIndex == 0
        {
            let Data = ArrFavoriteMovies[indexPath.row]
            
            cell.ImgLikeImage.image = UIImage(named: "Favorite_Fill")
            cell.lblFavoriteName.text = Data.MoviesName
            cell.ImgFavoriteImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.ImgFavoriteImage.sd_setImage(with: URL(string: Data.MoviesPoster!), placeholderImage: UIImage(named: ""))
        }
        else
        {
            let Data = ArrFavoriteActors[indexPath.row]
            
            cell.ImgLikeImage.image = UIImage(named: "Favorite_Fill")
            cell.lblFavoriteName.text = Data.CastName
            cell.ImgFavoriteImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.ImgFavoriteImage.sd_setImage(with: URL(string: Data.CastProfileUrl), placeholderImage: UIImage(named: ""))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("Call Method didSelectRow")
        if SegmentController.selectedSegmentIndex == 0
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
            let MoviesDetailsVC = storyBoard.instantiateViewController(withIdentifier: "MoviesDetailsVC") as! MoviesDetailsVC
             let Data = ArrFavoriteMovies[indexPath.row]
             let MoviesId = Int(Data.MoviesId)
            MoviesDetailsVC.Movies_ID = MoviesId!
             self.navigationController?.pushViewController(MoviesDetailsVC, animated: true)
        }
        else
         {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
            let CastDetailsVC = storyBoard.instantiateViewController(withIdentifier: "CastDetailsVC") as! CastDetailsVC

            let Data = ArrFavoriteActors[indexPath.row]
            let CastID = Int(Data.CastId!)
            CastDetailsVC.CastOwrnerID = CastID!
            self.navigationController?.pushViewController(CastDetailsVC, animated: true)
            print("DidSelect Method Call")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.transform = CGAffineTransform(scaleX: 2.10, y: 2.10)
        UIView.animate(withDuration: 0.40) {
            cell.alpha = 1
            cell.transform = .identity
        }
    }
}

//MARK:- UICollection View FlowLayout Method
extension FavoriteVC: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = (self.ColleFavorite.frame.width - 25)
        return CGSize(width: width, height: width - 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }

}
