

import UIKit
import SDWebImage
import Firebase

class CastDetailsVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet var ScrollView: UIScrollView!
    @IBOutlet var ImgCast: UIImageView!
    @IBOutlet var lblCastName: UILabel!
    @IBOutlet var lblCastCount: UILabel!
    @IBOutlet var tblCast: UITableView!
    @IBOutlet var tblHeight: NSLayoutConstraint!
    @IBOutlet var lblBOD: UILabel!
    @IBOutlet var ImgFavoriteCastImage: UIImageView!
    
    //MARK:- Variable
    var CastOwrnerID = Int()
    var Navigation = String()
    var CastImageUrl = String()
    var arrAllCastMoviesData = [AllmoviesResults]()
    
    //MARK:- VIewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.applyGradient(locations:  [0.1, 1.1])
        self.tblCast.tableFooterView = UIView()
        self.tblCast.separatorStyle = UITableViewCell.SeparatorStyle.none
        ScrollView.bounces = false
        tblCast.bounces = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        self.ImgCast.isUserInteractionEnabled = true
        self.ImgCast.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap1.numberOfTapsRequired = 1
        self.ImgFavoriteCastImage.isUserInteractionEnabled = true
        self.ImgFavoriteCastImage.addGestureRecognizer(tap1)
    }
    
    //MARK:- ViewWillAppear
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if (Reachability.isConnectedToNetwork() == true)
        {
            self.CastDataGetApiCall()
            self.ImgFavoriteCastImage.image = UIImage(named: "Favorite_De")
            let LoginID = NSUserDefaultClass.sharedInstance.getUserDetails()?.Id
            let ref = Database.database().reference().child("favoriteactors")
            ref.observe(.childAdded, with: { snapshot in
                let dict = snapshot.value as! [String: Any]
                let UserId = dict["UserId"] as? String ?? ""
                let CastId = dict["CastId"] as? String ?? ""
                
                if UserId == LoginID && CastId == String(self.CastOwrnerID)
                {
                    self.ImgFavoriteCastImage.image = UIImage(named: "Favorite_Fill")
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
        if Navigation == "People"
        {
            self.navigationController?.popViewController(animated: false)
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func doubleTapped()
    {
        if ImgFavoriteCastImage.image == UIImage(named: "Favorite_De")!
        {
            let UserId = NSUserDefaultClass.sharedInstance.getUserDetails()?.Id
            let MoviesData = ["UserId": UserId,"CastId": String(self.CastOwrnerID),"CastProfileUrl": self.CastImageUrl,"CastName":lblCastName.text!]
            let ref = Database.database().reference()
            ref.child("favoriteactors").childByAutoId().setValue(MoviesData)
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.ImgFavoriteCastImage.transform = CGAffineTransform(scaleX: 3,y: 3)
                self.ImgFavoriteCastImage.alpha = 0
            }) { (completed) -> Void in
                self.ImgFavoriteCastImage.transform = CGAffineTransform(scaleX: 1,y: 1)
                self.ImgFavoriteCastImage.image = UIImage(named: "Favorite_Fill")
                self.ImgFavoriteCastImage.alpha = 1
            }
        }
        else
        {
           let LoginID = NSUserDefaultClass.sharedInstance.getUserDetails()?.Id
           let ref = Database.database().reference().child("favoriteactors")
           ref.observe(.childAdded, with: { snapshot in
               let dict = snapshot.value as! [String: Any]
               let UserId = dict["UserId"] as? String ?? ""
               let CastId = dict["CastId"] as? String ?? ""
               let DeleteID = snapshot.key
               if UserId == LoginID && CastId == String(self.CastOwrnerID)
               {
                   FirebaseDatabase.Database.database().reference(withPath: "favoriteactors").child(DeleteID).setValue(nil)
               }
           })
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.ImgFavoriteCastImage.transform = CGAffineTransform(scaleX: 3,y: 3)
                self.ImgFavoriteCastImage.alpha = 0
            }) { (completed) -> Void in
                self.ImgFavoriteCastImage.transform = CGAffineTransform(scaleX: 1,y: 1)
                self.ImgFavoriteCastImage.image = UIImage(named: "Favorite_De")
                self.ImgFavoriteCastImage.alpha = 1
            }
        }
    }
}

//MARK:- Api Call Function
extension CastDetailsVC
{
   func CastDataGetApiCall()
   {
    appDelegate.HideHUD()
    let url = "\(BaseUrlCastDetails)\(self.CastOwrnerID)\(CastDetailsGet)\(ApiKey)"
    ApiHelper.sharedInstance.GetMethodServiceCall(url: url) { (response, error) in
        
        if response != nil
        {
          print("response  response  response ************************** \(response) **********************************************")
            
            DispatchQueue.main.async
            {
                self.lblCastName.text = response!["name"] as? String ?? ""
                self.lblBOD.text = "BOD: \(response!["birthday"] as? String ?? "")"
                
                let ProfilePic = "\(HomePosterPath)\(response!["profile_path"] as? String ?? "")"
                self.CastImageUrl = ProfilePic
                 self.ImgCast.sd_imageIndicator = SDWebImageActivityIndicator.gray
                 self.ImgCast.sd_setImage(with: URL(string: ProfilePic), placeholderImage: UIImage(named: ""))
                
                 let MovieCredits = response!["movie_credits"] as! NSDictionary
                 print("MovieCredits\(MovieCredits)")
                 let Cast = MovieCredits["cast"] as! [[String:AnyObject]]
                self.lblCastCount.text = "Total Movies: \(String(Cast.count))"
                let Height = (Cast.count) * 170
                self.tblHeight.constant = CGFloat(Height)
                self.arrAllCastMoviesData = Cast.map({return AllmoviesResults(dic: $0 as NSDictionary)})
                self.tblCast.reloadData()
            }
        }
        else
        {
           self.alert(message: "Something is wrong please try againt", title: "Error")
        }
    }
   }
}

//MARK:- UItableView Delegate And DataSource
extension CastDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrAllCastMoviesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CastCell", for: indexPath) as! CastCell
        
        let Data = arrAllCastMoviesData[indexPath.row]
        
        cell.lblName.text = "Movies Name: \(Data.Title)"
        cell.lblReleaseDate.text = "Release Date: \(Data.Release_Date)"
        
        let PostUrl = HomePosterPath + Data.Poster_Path
        cell.ImgMovies.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.ImgMovies.sd_setImage(with: URL(string: PostUrl), placeholderImage: UIImage(named: ""))
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        let MoviesDetailsVC = storyBoard.instantiateViewController(withIdentifier: "MoviesDetailsVC") as! MoviesDetailsVC
        
         let Data = arrAllCastMoviesData[indexPath.row]
         MoviesDetailsVC.Movies_ID = Data.Id
        
        self.navigationController?.pushViewController(MoviesDetailsVC, animated: false)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 170
    }
}

extension CastDetailsVC: UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
      //tblHeight.constant = tblCast.contentSize.height

    }
    
    func setScrollPosition(position: CGFloat)
    {
      self.tblCast.contentOffset = CGPoint(x: self.tblCast.contentOffset.x, y: position)
    }
}
