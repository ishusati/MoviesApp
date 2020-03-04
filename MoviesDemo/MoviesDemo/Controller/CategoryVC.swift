

import UIKit

class CategoryVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet var lblTital: UILabel!
    @IBOutlet var ColleCategory: UICollectionView!
    
    //MARK:-Variable
    var ArrAllMovieCategoryList = [CateGoryList]()
    
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
            self.MoviesCateGoryGetApi()
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
extension CategoryVC
{
    func MoviesCateGoryGetApi()
    {
        appDelegate.ShowHUD()
        let url = BaseUrlCateGory + ApiKey + CateGoryMoviesGet
        
        ApiHelper.sharedInstance.GetMethodServiceCall(url:url) { (response, error) in
            
            appDelegate.HideHUD()
            if response != nil
            {
                print("response  response  response ************************** \(response) **********************************************")
                DispatchQueue.main.async {
                    let Genres = response!["genres"] as! [[String:AnyObject]]
                    self.ArrAllMovieCategoryList = Genres.map({return CateGoryList(Dict: $0 as NSDictionary)})
                    self.ColleCategory.reloadData()
                }
            }
            else
            {
                self.alert(message: "Something is wrong please try againt", title: "Error")
            }
        }
    }
    
    func getImage(_ genreName: MovieBanner, _ cell: CategoryCell){
        switch genreName {
        case .Action:
            let image = UIImage.init(named: genreName.rawValue)
            cell.ImgCategory.image = image
        case .Adventure:
            let image = UIImage.init(named: genreName.rawValue)
            cell.ImgCategory.image = image
        case .Animation:
            let image = UIImage.init(named: genreName.rawValue)
            cell.ImgCategory.image = image
        case .Comedy:
            let image = UIImage.init(named: genreName.rawValue)
            cell.ImgCategory.image = image
        case .Crime:
            let image = UIImage.init(named: genreName.rawValue)
            cell.ImgCategory.image = image
        case .Documentary:
            let image = UIImage.init(named: genreName.rawValue)
            cell.ImgCategory.image = image
        case .Drama:
            let image = UIImage.init(named: genreName.rawValue)
            cell.ImgCategory.image = image
        case .Family:
            let image = UIImage.init(named: genreName.rawValue)
            cell.ImgCategory.image = image
        case .Fantasy:
            let image = UIImage.init(named: genreName.rawValue)
            cell.ImgCategory.image = image
        case .History:
            let image = UIImage.init(named: genreName.rawValue)
            cell.ImgCategory.image = image
        case .Horror:
            let image = UIImage.init(named: genreName.rawValue)
            cell.ImgCategory.image = image
        case .Music:
            let image = UIImage.init(named: genreName.rawValue)
            cell.ImgCategory.image = image
        case .Mystery:
            let image = UIImage.init(named: genreName.rawValue)
            cell.ImgCategory.image = image
        case .Romance:
            let image = UIImage.init(named: genreName.rawValue)
            cell.ImgCategory.image = image
        case .ScienceFiction:
            let image = UIImage.init(named: genreName.rawValue)
            cell.ImgCategory.image = image
        case .Thriller:
            let image = UIImage.init(named: genreName.rawValue)
            cell.ImgCategory.image = image
        case .TVMovie:
            let image = UIImage.init(named: genreName.rawValue)
            cell.ImgCategory.image = image
        case .War:
            let image = UIImage.init(named: genreName.rawValue)
            cell.ImgCategory.image = image
        case .Western:
            let image = UIImage.init(named: genreName.rawValue)
            cell.ImgCategory.image = image
        case .Default:
            let image = UIImage.init(named: genreName.rawValue)
            cell.ImgCategory.image = image
        }
    }
}

//MARK:- UICollection View DeleGate And DataSource Method
extension CategoryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return ArrAllMovieCategoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = ColleCategory.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        cell.ImgCategory.layer.cornerRadius = 5
        cell.ImgCategory.clipsToBounds = true
        
        let Data = ArrAllMovieCategoryList[indexPath.row]
        cell.lblCategoryName.text = Data.Name
        self.getImage(MovieBanner(rawValue: Data.Name)!, cell)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Call Method didSelectRow")
        let navStoryboard = UIStoryboard.init(name: "Home", bundle: nil)
        let CategoryDetailsVC = navStoryboard.instantiateViewController(withIdentifier: "CategoryDetailsVC") as! CategoryDetailsVC
        
        let Data = ArrAllMovieCategoryList[indexPath.row]
        
        CategoryDetailsVC.CateGoryID = Data.Id
        CategoryDetailsVC.CateGoryName = Data.Name
        
        self.navigationController?.pushViewController(CategoryDetailsVC, animated: false)
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
extension CategoryVC: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = (self.ColleCategory.frame.width - 15)
        return CGSize(width: width, height: width - 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }

}


enum MovieBanner: String {
       case Action
       case Adventure
       case Animation
       case Comedy
       case Crime
       case Documentary
       case Drama
       case Family
       case Fantasy
       case History
       case Horror
       case Music
       case Mystery
       case Romance
       case ScienceFiction
       case Thriller
       case TVMovie
       case War
       case Western
       case Default
   }
