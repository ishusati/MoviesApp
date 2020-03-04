
import UIKit
import SOTabBar

class TapBarVC: SOTabBarController {

    //MARK:- ViewLoad
    override func loadView() {
        super.loadView()
        SOTabBarSetting.tabBarTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        SOTabBarSetting.tabBarCircleSize = CGSize(width: 65, height: 65)
        SOTabBarSetting.tabBarBackground = #colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1)
        SOTabBarSetting.tabBarSizeImage = CGFloat(40)
        SOTabBarSetting.tabBarSizeSelectedImage = CGFloat(35)
    }
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
       let HomeVCStoryboard = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
        let CateGoryVCStoryboard = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "CategoryVC")
        let SearchVCStoryboard = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "SearchVC")
        let PeopleVCStoryboard = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "PeopleVC")
        let FavoriteVCStoryboard = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "FavoriteVC")
        let  ProfileVCStoryboard = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC")
        
        HomeVCStoryboard.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(named: "Movies"), selectedImage: UIImage(named: "Movies_Tap"))
        CateGoryVCStoryboard.tabBarItem = UITabBarItem(title: "CateGory", image: UIImage(named: "Category"), selectedImage: UIImage(named: "Category_Tap"))
        SearchVCStoryboard.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "Search"), selectedImage: UIImage(named: "Search_Tap"))
        PeopleVCStoryboard.tabBarItem = UITabBarItem(title: "People", image: UIImage(named: "People"), selectedImage: UIImage(named: "People_Tap"))
        FavoriteVCStoryboard.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(named: "Favorite"), selectedImage: UIImage(named: "Favorite_Tap"))
         ProfileVCStoryboard.tabBarItem = UITabBarItem(title: "Me", image: UIImage(named: "Me"), selectedImage: UIImage(named: "Me_Tap"))
        
        viewControllers = [HomeVCStoryboard, CateGoryVCStoryboard,SearchVCStoryboard,PeopleVCStoryboard,FavoriteVCStoryboard,ProfileVCStoryboard]
    }
    
}

//MARK:- TapBarController DeleGate Method
extension TapBarVC: SOTabBarControllerDelegate {
    func tabBarController(_ tabBarController: SOTabBarController, didSelect viewController: UIViewController) {
        print(viewController.tabBarItem.title ?? "")
    }
}
