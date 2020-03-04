

import UIKit
import SDWebImage

class HomeVC: UIViewController {
 
    //MARK:- Outlet
    @IBOutlet var lblTital: UILabel!
    @IBOutlet var ColleHome: UICollectionView!
    
    //MARK:-Variable
    var ArrAllMovieDataResults = [AllmoviesResults]()
    var MoviesPage = Int()
   
    //MARK:- ViewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.applyGradient(locations:  [0.1, 1.1])
    }
    
    //MARK:- ViewWillAppear
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if (Reachability.isConnectedToNetwork() == true)
        {
            self.AllMoviesDataApi()
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
}

//MARK:- Api Call Function
extension HomeVC
{
    func AllMoviesDataApi()
    {
        appDelegate.ShowHUD()
        let url = BaseUrlHome + ApiKey + HomeAllMoviesGet + "1"
        ApiHelper.sharedInstance.GetMethodServiceCall(url:url) { (response, error) in
            
            appDelegate.HideHUD()
            if response != nil
            {
                print("response  response  response ************************** \(response) **********************************************")
                DispatchQueue.main.async {
                    self.MoviesPage = response!["page"] as! Int
                    let Result = response!["results"] as! [[String:AnyObject]]
                    self.ArrAllMovieDataResults = Result.map({return AllmoviesResults(dic: $0 as NSDictionary)})
                    self.ColleHome.reloadData()
                }
            }
            else
            {
                self.alert(message: "Something is wrong please try againt", title: "Error")
            }
        }
    }
    
   func MoviesDataLoadMore()
   {
    
    let page = self.MoviesPage
    let url = "\(BaseUrlHome)\(ApiKey)\(HomeAllMoviesGet)\(page+1)"
    
    ApiHelper.sharedInstance.GetMethodServiceCall(url:url) { (response, error) in
        
        if response != nil
        {
            print("response  response  response ************************** \(response) **********************************************")
            DispatchQueue.main.async {
                self.MoviesPage = response!["page"] as! Int
                let Result = response!["results"] as! [[String:AnyObject]]
                self.ArrAllMovieDataResults.append(contentsOf: Result.map({return AllmoviesResults(dic: $0 as NSDictionary)}))//Result.map({return AllmoviesResults(dic: $0 as NSDictionary)})
                self.ColleHome.reloadData()
            }
        }
        else
        {
            self.alert(message: "Something is wrong please try againt", title: "Error")
        }
    }
    
   }
}

//MARK:- CollectionView DeleGate And DataSource Method
extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return ArrAllMovieDataResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        
        cell.ImgMovies.layer.cornerRadius = 5
        cell.ImgMovies.clipsToBounds = true
        
        let Data = ArrAllMovieDataResults[indexPath.row]
        
        cell.lblMoviesName.text = Data.Title
        
        let PosterPath = HomePosterPath + Data.Poster_Path
        
        cell.ImgMovies.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.ImgMovies.sd_setImage(with: URL(string: PosterPath), placeholderImage: UIImage(named: ""))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        let MoviesDetailsVC = storyBoard.instantiateViewController(withIdentifier: "MoviesDetailsVC") as! MoviesDetailsVC
        
       let Data = ArrAllMovieDataResults[indexPath.row]
       MoviesDetailsVC.Movies_ID = Data.Id
       self.navigationController?.pushViewController(MoviesDetailsVC, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cell.alpha = 0
        cell.transform = CGAffineTransform(scaleX: 0.12, y: 0.12)
        UIView.animate(withDuration: 0.30) {
          cell.alpha = 1
          cell.transform = .identity
        }

        if indexPath.row == (ArrAllMovieDataResults.count) - 4 {
            self.MoviesDataLoadMore()
        }
    }
}

//MARK:- CollectionView FlowLayout Method
extension HomeVC: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = (self.ColleHome.frame.width - 10) / 2
        return CGSize(width: width, height: width + 35)
    }
}

