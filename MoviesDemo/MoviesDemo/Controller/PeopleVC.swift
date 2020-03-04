

import UIKit
import SDWebImage

class PeopleVC: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet var lblTital: UILabel!
    @IBOutlet var tblPeople: UITableView!
    
    //MARK:- Variable
    var PageCount = Int()
    var arrAllPeopleList = [PeopleData]()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()

       self.view.applyGradient(locations:  [0.1, 1.1])
       self.tblPeople.tableFooterView = UIView()
       self.tblPeople.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    //MARK:- ViewWillAppear
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if (Reachability.isConnectedToNetwork() == true)
        {
            self.GetPeopleApiCAll(Page: 1)
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
extension PeopleVC
{
    func GetPeopleApiCAll(Page:Int)
    {
        appDelegate.ShowHUD()
        let url = "\(BaseUrlPeople)\(ApiKey)\(PeopleGet)\(Page)"
        ApiHelper.sharedInstance.GetMethodServiceCall(url:url) { (response, error) in
            
            appDelegate.HideHUD()
            if response != nil
            {
                print("response  response  response ************************** \(response) **********************************************")
                DispatchQueue.main.async {
                    self.PageCount = response!["page"] as! Int
                    let Result = response!["results"] as! [[String:AnyObject]]
                    self.arrAllPeopleList = Result.map({return PeopleData(Dict: $0 as NSDictionary)})
                    self.tblPeople.reloadData()
                }
            }
            else
            {
                self.alert(message: "Something is wrong please try againt", title: "Error")
            }
        }
    }
    
    func LodMoreGetPeopleApiCAll(Page:Int)
    {
        appDelegate.ShowHUD()
        let url = "\(BaseUrlPeople)\(ApiKey)\(PeopleGet)\(Page)"
        ApiHelper.sharedInstance.GetMethodServiceCall(url:url) { (response, error) in
            
            appDelegate.HideHUD()
            if response != nil
            {
                print("response  response  response ************************** \(response) **********************************************")
                DispatchQueue.main.async {
                    self.PageCount = response!["page"] as! Int
                    let Result = response!["results"] as! [[String:AnyObject]]
                    self.arrAllPeopleList.append(contentsOf: Result.map({return PeopleData(Dict: $0 as NSDictionary)}))
                    self.tblPeople.reloadData()
                }
            }
            else
            {
                self.alert(message: "Something is wrong please try againt", title: "Error")
            }
        }
    }
}

//MARK:- UITableView DeleGate And DataSource Method 
extension PeopleVC: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrAllPeopleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath) as! PeopleCell
        
        let Data = arrAllPeopleList[indexPath.row]

        cell.ImgPeople.layer.cornerRadius = cell.ImgPeople.frame.height/2
        cell.ImgPeople.clipsToBounds = true
        cell.ImgPeople.layer.borderWidth = 1
        cell.ImgPeople.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        cell.lblPeopleName.text = "Name: " + Data.Name
        let image = HomePosterPath + Data.ProfilePath
        cell.ImgPeople.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.ImgPeople.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: ""))

        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let lastElement = arrAllPeopleList.count - 1
        if indexPath.row == lastElement {
            let page = self.PageCount + 1
            self.LodMoreGetPeopleApiCAll(Page: page)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       let person = arrAllPeopleList[indexPath.row]
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        let CastDetailsVC = storyBoard.instantiateViewController(withIdentifier: "CastDetailsVC") as! CastDetailsVC
        CastDetailsVC.CastOwrnerID = person.Id
        CastDetailsVC.Navigation = "People"
        self.navigationController?.pushViewController(CastDetailsVC, animated: false)
        print("DidSelect Method Call")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 135
    }
}
