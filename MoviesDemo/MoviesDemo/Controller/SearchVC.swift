
import UIKit
import SDWebImage

class SearchVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var tblSearch: UITableView!
    @IBOutlet var SearchView: UIView!
    @IBOutlet var txtSearchText: UITextField!
    @IBOutlet var SearchIcon: UIImageView!
    
    //MARK:- VARIABLE
    var ArrSearchMoviesList = [AllmoviesResults]()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tblSearch.tableFooterView = UIView()
        self.tblSearch.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.view.applyGradient(locations:  [0.1, 1.1])
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        self.txtSearchText.text = ""
        self.SearchIcon.isHidden = false
        self.txtSearchText.delegate = self
        self.txtSearchText.returnKeyType = .done
        
        self.txtSearchText.attributedPlaceholder = NSAttributedString(string: "Search Movies", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
    
    @objc func hideKeyboard(){
          self.view.endEditing(true)
      }
    
    //MARK:- ViewWillAppear
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if (Reachability.isConnectedToNetwork() == true)
        {
            self.txtSearchText.text = ""
            self.SearchIcon.isHidden = false
            self.ArrSearchMoviesList.removeAll()
            self.tblSearch.reloadData()
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
extension SearchVC
{
    func SearchMoviesDataGet(SearchText: String)
    {
        let Baseurl = "\(BaseUrlSearch)\(ApiKey)&language=en-US&query=\(SearchText)&page=1&include_adult=false"
        let url = Baseurl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        ApiHelper.sharedInstance.GetMethodServiceCall(url:url!) { (response, error) in
            
            if response != nil
            {
                if ((response?.value(forKey: "errors")) != nil)
                {
                    print("Error**************************\(String(describing: response))******************************Error")
                    self.ArrSearchMoviesList.removeAll()
                    self.tblSearch.reloadData()
                }
                else
                {
                    print("Success**************************\(String(describing: response))******************************Success")
                    
                    DispatchQueue.main.async {
                        let Result = response!["results"] as! [[String:AnyObject]]
                        self.ArrSearchMoviesList = Result.map({return AllmoviesResults(dic: $0 as NSDictionary)})
                        self.tblSearch.reloadData()
                    }
                }
            }
            else
            {
               print("Something is wrong please try againt")
            }
        }
    }
}

//MARK:- UITableView DeleGate And DataSource Method
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ArrSearchMoviesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchMoviesCell", for: indexPath) as! SearchMoviesCell
        
        let Data = ArrSearchMoviesList[indexPath.row]
        
        cell.lblMoviesName.text = "Movie Name:\(Data.Title)"
        cell.lblDate.text = "Release Date:\(Data.Release_Date)"
        cell.lblVote.text = "Vote_Average:\(Data.Vote_Average)"
        cell.lblTotalView.text = "TotalView:\(Data.Popularity)"
        
        let image = HomePosterPath + Data.Poster_Path
        cell.ImgSearch.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.ImgSearch.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "soon"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        let MoviesDetailsVC = storyBoard.instantiateViewController(withIdentifier: "MoviesDetailsVC") as! MoviesDetailsVC

        let Data = ArrSearchMoviesList[indexPath.row]
        MoviesDetailsVC.Movies_ID = Data.Id
       
       self.navigationController?.pushViewController(MoviesDetailsVC, animated: false)
    }
}

//MARK:- UItextField DeleGate Methos
extension SearchVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtSearchText
        {
            if txtSearchText.text!.count > 0
            {
                self.SearchMoviesDataGet(SearchText: txtSearchText.text!)
                self.SearchIcon.isHidden = true
            }
            else
            {
               self.SearchIcon.isHidden = false
               self.ArrSearchMoviesList.removeAll()
               self.tblSearch.reloadData()
            }
        }
        return true
    }
}
