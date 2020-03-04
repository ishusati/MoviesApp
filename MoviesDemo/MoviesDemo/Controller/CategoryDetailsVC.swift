
import UIKit
import SDWebImage

class CategoryDetailsVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet var lblTital: UILabel!
    @IBOutlet var ColleCategoryDetails: UICollectionView!

    
    //MARK:- Variable
    var CateGoryID = Int()
    var CateGoryName = String()
    var arrCateGoryTypeAllMoviesData = [AllmoviesResults]()
    var MoviesPage = Int()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.applyGradient(locations:  [0.1, 1.1])
        self.lblTital.text = self.CateGoryName
    }
    
    //MARK:- ViewWillAppear
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if (Reachability.isConnectedToNetwork() == true)
        {
            self.CateGoryDetailsGetApiCall()
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
    @IBAction func btnBAck(_ sender: Any)
    {
      self.navigationController?.popViewController(animated: false)
    }
}

//MARK:- Api Call Function
extension CategoryDetailsVC
{
    func CateGoryDetailsGetApiCall()
    {
        appDelegate.ShowHUD()
        let url = "\(BaseUrlHome)\(ApiKey)\(CateGoryDetailsGet)\(self.CateGoryID)" 
        ApiHelper.sharedInstance.GetMethodServiceCall(url: url) { (response, error) in
            appDelegate.HideHUD()
            if response != nil
            {
                print("response  response  response ************************** \(response) **********************************************")
                DispatchQueue.main.async {
                    self.MoviesPage = response!["page"] as! Int
                    let Result = response!["results"] as! [[String:AnyObject]]
                    self.arrCateGoryTypeAllMoviesData = Result.map({return AllmoviesResults(dic: $0 as NSDictionary)})
                    self.ColleCategoryDetails.reloadData()
                }
            }
            else
            {
               self.alert(message: "Something is wrong please try againt", title: "Error")
            }
        }
    }
    
    func CateGoryMoviesDataLoadMore()
    {
        let page = self.MoviesPage
        let url = "\(BaseUrlHome)\(ApiKey)\(CateGoryDetailsGet)\(page+1)&with_genres=\(self.CateGoryID)"
        
        ApiHelper.sharedInstance.GetMethodServiceCall(url:url) { (response, error) in

            if response != nil
            {
                print("response  response  response ************************** \(response) **********************************************")
                DispatchQueue.main.async {
                    self.MoviesPage = response!["page"] as! Int
                    let Result = response!["results"] as! [[String:AnyObject]]
                    self.arrCateGoryTypeAllMoviesData.append(contentsOf: Result.map({return AllmoviesResults(dic: $0 as NSDictionary)}))
                    self.ColleCategoryDetails.reloadData()
                }
            }
            else
            {
                self.alert(message: "Something is wrong please try againt", title: "Error")
            }
        }
        
    }
}

//MARK:- UIColleView Delegate And DataSource Method
extension CategoryDetailsVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrCateGoryTypeAllMoviesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryDetailsCell", for: indexPath) as! CategoryDetailsCell
        
        let Data = arrCateGoryTypeAllMoviesData[indexPath.row]
        
        cell.ImgCategoryDetails.layer.cornerRadius = 5
        cell.ImgCategoryDetails.clipsToBounds = true
        
        cell.lblName.text = Data.Title
        let PosterUrl = HomePosterPath + Data.Poster_Path
        cell.ImgCategoryDetails.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.ImgCategoryDetails.sd_setImage(with: URL(string: PosterUrl), placeholderImage: UIImage(named: ""))
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        let MoviesDetailsVC = storyBoard.instantiateViewController(withIdentifier: "MoviesDetailsVC") as! MoviesDetailsVC

         let Data = arrCateGoryTypeAllMoviesData[indexPath.row]
        
        MoviesDetailsVC.Movies_ID = Data.Id
        
       self.navigationController?.pushViewController(MoviesDetailsVC, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cell.alpha = 0
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.30) {
          cell.alpha = 1
          cell.transform = .identity
        }
        
        if indexPath.row == (arrCateGoryTypeAllMoviesData.count) - 4 {
            self.CateGoryMoviesDataLoadMore()
        }
    }
}

//MARK:- UIColleView FlowLayout Method
extension CategoryDetailsVC: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = (self.ColleCategoryDetails.frame.width - 10) / 2
        return CGSize(width: width, height: width + 35)
    }

}


