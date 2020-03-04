

import UIKit
import SDWebImage
import Firebase

class MoviesDetailsVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet var ScrollBaseView: UIView!
    @IBOutlet var ImgMoviesImage: UIImageView!
    @IBOutlet var lblMoviesName: UILabel!
    @IBOutlet var lblMoviesTime: UILabel!
    @IBOutlet var lblMovisOverView: UILabel!
    @IBOutlet var ImgMoviesPosterImage: UIImageView!
    @IBOutlet var lblMoviesDirectorName: UILabel!
    @IBOutlet var lblMoviesType: UILabel!
    @IBOutlet var lblMoviesReting: UILabel!
    @IBOutlet var lblMoviesReleaseDate: UILabel!
    @IBOutlet var ScrollViewMain: UIView!
    @IBOutlet var CollectCast: UICollectionView!
    @IBOutlet var ImgFavoriteImage: UIImageView!
    
    //MARK:- Variable
    var Movies_ID = Int()
    var i = Int()
    var arrimage = [[String:AnyObject]]()
    var MovieType = [String]()
    var ArrCast: NSArray = NSArray()
    var PosterUrl = String()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.applyGradient(locations:  [0.1, 1.1])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        self.ImgMoviesImage.isUserInteractionEnabled = true
        self.ImgMoviesImage.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap1.numberOfTapsRequired = 1
        self.ImgFavoriteImage.isUserInteractionEnabled = true
        self.ImgFavoriteImage.addGestureRecognizer(tap1)
        
    }
    
    //MARK:- ViewWillAppear
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if (Reachability.isConnectedToNetwork() == true)
        {
            self.MoviesDetailsGetApiCall()
            self.MoviesPictureGetApiCall()
            self.ImgFavoriteImage.image = UIImage(named: "Favorite_De")
            let LoginID = NSUserDefaultClass.sharedInstance.getUserDetails()?.Id
            let ref = Database.database().reference().child("favoritemovies")
            ref.observe(.childAdded, with: { snapshot in
                let dict = snapshot.value as! [String: Any]
                let UserId = dict["UserId"] as? String ?? ""
                let MoviesId = dict["MoviesId"] as? String ?? ""
            
                if UserId == LoginID && MoviesId == String(self.Movies_ID)
                {
                 self.ImgFavoriteImage.image = UIImage(named: "Favorite_Fill")
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
    @IBAction func btnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func doubleTapped() {
        
        if ImgFavoriteImage.image == UIImage(named: "Favorite_De")!
        {
            let UserId = NSUserDefaultClass.sharedInstance.getUserDetails()?.Id
            let MoviesData = ["UserId": UserId,"MoviesId": String(self.Movies_ID),"MoviesPoster":self.PosterUrl,"MoviesName":lblMoviesName.text!]
            let ref = Database.database().reference()
            ref.child("favoritemovies").childByAutoId().setValue(MoviesData)
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.ImgFavoriteImage.transform = CGAffineTransform(scaleX: 3,y: 3)
                self.ImgFavoriteImage.alpha = 0
            }) { (completed) -> Void in
                self.ImgFavoriteImage.transform = CGAffineTransform(scaleX: 1,y: 1)
                self.ImgFavoriteImage.image = UIImage(named: "Favorite_Fill")
                self.ImgFavoriteImage.alpha = 1
            }
        }
        else
        {
            let LoginID = NSUserDefaultClass.sharedInstance.getUserDetails()?.Id
            let ref = Database.database().reference().child("favoritemovies")
            ref.observe(.childAdded, with: { snapshot in
                let dict = snapshot.value as! [String: Any]
                let UserId = dict["UserId"] as? String ?? ""
                let MoviesId = dict["MoviesId"] as? String ?? ""
                let DeleteID = snapshot.key
                if UserId == LoginID && MoviesId == String(self.Movies_ID)
                {
                    FirebaseDatabase.Database.database().reference(withPath: "favoritemovies").child(DeleteID).setValue(nil)
                }
            })
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.ImgFavoriteImage.transform = CGAffineTransform(scaleX: 3,y: 3)
                self.ImgFavoriteImage.alpha = 0
            }) { (completed) -> Void in
                self.ImgFavoriteImage.transform = CGAffineTransform(scaleX: 1,y: 1)
                self.ImgFavoriteImage.image = UIImage(named: "Favorite_De")
                self.ImgFavoriteImage.alpha = 1
            }
        }
    }
}

//MARK:- Api Call Function
extension MoviesDetailsVC
{
   func MoviesDetailsGetApiCall()
   {
     appDelegate.ShowHUD()
     let url = "\(BaseUrlMoviesDetails)\(self.Movies_ID)?api_key=\(ApiKey)\(MoviesDetailsGet)"
    
    ApiHelper.sharedInstance.GetMethodServiceCall(url:url) { (response, error) in
        
        appDelegate.HideHUD()
        if response != nil
        {
            print("response  response  response ************************** \(response) **********************************************")
            DispatchQueue.main.async
            {
                let RunTime = response!["runtime"] as! Int
                let Hours = RunTime / 60
                let Minutes = RunTime % 60
                if Hours > 0 && Minutes > 0 {
                    self.lblMoviesTime.text = String(describing: Hours) + " H " + String(describing: Minutes) + " Min"
                } else if Minutes > 0 {
                    self.lblMoviesTime.text = String(describing: Minutes) + " Min"
                } else {
                    self.lblMoviesTime.text = "0 Min"
                }
                
                self.lblMovisOverView.text = response!["overview"] as? String ?? ""
                self.lblMoviesName.text = response!["title"] as? String ?? ""
                
                let posterurl = "\(MoviesDetailsPosterPath)\(response!["poster_path"] as? String ?? "")"
                self.PosterUrl = posterurl
                self.ImgMoviesPosterImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.ImgMoviesPosterImage.sd_setImage(with: URL(string: posterurl), placeholderImage: UIImage(named: ""))
                
               self.lblMoviesReting.text = "RELEASE DATE: \(response!["release_date"] as? String ?? "")"
               let Vote = response!["vote_average"]
               self.lblMoviesReleaseDate.text = "RATING: \(Vote ?? "")/10"
                
                let MoviesType12 = response!["genres"] as! NSArray
                
                for i in 0..<MoviesType12.count
                {
                    let Dict = MoviesType12[i] as! NSDictionary
                    let Type = Dict["name"] as? String
                    self.MovieType.append(Type!)
                    print("Type:- \(Type ?? "")")
                }
                
                 let Comma = self.MovieType.joined(separator: ",")
                 self.lblMoviesType.text = "GENRES: \(Comma)"
                
                let credits = response!["credits"] as! NSDictionary
                let crew = credits["crew"] as! NSArray
                self.ArrCast = credits["cast"] as! NSArray
                self.CollectCast.reloadData()
                
                for i in 0..<crew.count
                {
                    let Dict = crew[i] as! NSDictionary
                    let Type = Dict["job"] as? String
                    
                    if Type == "Director"
                    {
                        self.lblMoviesDirectorName.text =  "DIRECTOR: \(Dict["name"] as? String ?? "")"
                    }
                    else
                    {
                        
                    }
                }
            }
        }
        else
        {
            self.alert(message: "Something is wrong please try againt", title: "Error")
        }
    }
   }
    
    func MoviesPictureGetApiCall()
    {
        appDelegate.ShowHUD()
        let url = "\(BaseUrlMoviesDetails)\(self.Movies_ID)/images?api_key=\(ApiKey)\(MoviePictureGet)"
        
       
        ApiHelper.sharedInstance.GetMethodServiceCall(url: url) { (response, error) in
            
             appDelegate.HideHUD()
            if response != nil
            {
             print("response  response  response ************************** \(response) **********************************************")
                
                self.arrimage = response!["backdrops"] as! [[String : AnyObject]]
                
                DispatchQueue.main.async {
                    
                    Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.Image), userInfo: nil , repeats: true)
                }
            }
            else
            {
               self.alert(message: "Something is wrong please try againt", title: "Error")
            }
        }
    }
    
    @objc func Image()
    {
        let dict = arrimage[i]
        let url11 = dict["file_path"] as! String
        let imageUrl = "https://image.tmdb.org/t/p/h632\(url11)"
        print(imageUrl)
        self.ImgMoviesImage.sd_setImage(with: URL(string: "\(imageUrl)"), placeholderImage: UIImage(named: ""))
        
        if i<arrimage.count-1
        {
            i+=1
        }
        else
        {
            i=0
        }
    }
}

//MARK:- UIColletionView DeleGate And DataSource Method
extension MoviesDetailsVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.ArrCast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesDetailsCell", for: indexPath) as! MoviesDetailsCell
        
        let data = ArrCast[indexPath.row] as! NSDictionary
        
        cell.ImgCastImage.layer.cornerRadius = cell.ImgCastImage.frame.height/2
        cell.ImgCastImage.clipsToBounds = true
        cell.ImgCastImage.layer.borderWidth = 2
        cell.ImgCastImage.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.ImgCastImage.image = UIImage(named: "Crime")
        
        let Image1 = data["profile_path"] as? String ?? ""
        let image = "https://image.tmdb.org/t/p/h632\(Image1)"
        cell.ImgCastImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.ImgCastImage.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: ""))
        
        cell.lblCastName.text = data["name"] as? String ?? ""

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let Data = self.ArrCast[indexPath.row] as! NSDictionary
        
        let CastID = Data["id"] as! Int
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        let CastDetailsVC = storyBoard.instantiateViewController(withIdentifier: "CastDetailsVC") as! CastDetailsVC
        CastDetailsVC.CastOwrnerID = CastID
       self.navigationController?.pushViewController(CastDetailsVC, animated: true)
        print("DidSelect Method Call")
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cell.alpha = 0
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.30) {
          cell.alpha = 1
          cell.transform = .identity
        }
    }
}

//MARK:- UIColletionView FlowLayout Method
extension MoviesDetailsVC: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
      return CGSize(width: 130, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
       {
         return 0
       }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat
       {
        return 0
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 5)
    }
}
