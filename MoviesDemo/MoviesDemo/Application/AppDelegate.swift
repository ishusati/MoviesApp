

import UIKit
import NVActivityIndicatorView
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
   var window: UIWindow?
   var DotsView : NVActivityIndicatorView!
    static let shareDelegate = AppDelegate()
   let Main = UIView()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        FirebaseApp.configure()
        self.checkLoginStatus()
                
        return true
    }
    
    //MARK:- App Delegate Shared
    class func shareAppDelegate() -> AppDelegate {
          return UIApplication.shared.delegate as! AppDelegate
      }
    
    //MARK:- Loader DotsView
    
    func ShowHUD()
    {
        DispatchQueue.main.async
            {
                for view in (self.window?.subviews)!
                {
                    if view .isKind(of: NVActivityIndicatorView.self)
                    {
                        view.removeFromSuperview()
                    }
                }
                self.DotsView = NVActivityIndicatorView(frame: UIScreen.main.bounds, type: .ballPulseSync, color: UIColor.init(white: 1, alpha: 0.9), padding: 130.0)
                
                self.DotsView.backgroundColor = UIColor.init(white: 0.5, alpha: 0.7)
                self.DotsView.center = (self.window?.rootViewController?.view.center)!
                self.window?.addSubview(self.DotsView)
                
                self.DotsView.startAnimating()
                
        }
    }
    
    func HideHUD()
    {
        DispatchQueue.main.async
            {
                self.DotsView.stopAnimating()
                self.DotsView.removeFromSuperview()
        }
    }
    
    //MARK:- InternetConnection
    
    func InternetConnectionErrorApp(view : UIView) -> UIView
    {
        let Image = UIImageView()
        let BaseView = UIView()
        let lblTital = UILabel()
        let lblMessage = UILabel()
        let LineView = UIView()
        let lblButton = UILabel()
        
        Main.frame = CGRect(x: 0, y: 0, width: view.frame.size.width , height: view.frame.size.height)
        Main.addSubview(BaseView)
        
        BaseView.backgroundColor = #colorLiteral(red: 0.8038491607, green: 0.7332120538, blue: 0.9881315827, alpha: 1)
        BaseView.layer.borderWidth = 1
        BaseView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        BaseView.layer.cornerRadius = 10
        
        BaseView.translatesAutoresizingMaskIntoConstraints = false
        
        BaseView.centerYAnchor.constraint(equalTo: self.Main.centerYAnchor, constant: 0).isActive = true
        BaseView.centerXAnchor.constraint(equalTo: self.Main.centerXAnchor, constant: 0).isActive = true
        BaseView.widthAnchor.constraint(equalToConstant: 283).isActive = true
        BaseView.heightAnchor.constraint(equalToConstant: 283).isActive = true
        
        BaseView.layoutIfNeeded()
        
        BaseView.addSubview(lblTital)
        lblTital.text = "Please make sure you are connected to the internet."
        lblTital.textColor = UIColor.black
        lblTital.font = UIFont(name: "futura", size: 19.0)
        lblTital.lineBreakMode = .byWordWrapping
        lblTital.numberOfLines = 0
        lblTital.sizeToFit()
        
        lblTital.translatesAutoresizingMaskIntoConstraints = false
        
        lblTital.topAnchor.constraint(equalTo: BaseView.topAnchor, constant: 10).isActive = true
        lblTital.leadingAnchor.constraint(equalTo: BaseView.leadingAnchor, constant: 40).isActive = true
        lblTital.trailingAnchor.constraint(equalTo: BaseView.trailingAnchor, constant: 40).isActive = true
        
        BaseView.addSubview(Image)
        Image.image = UIImage(named: "Round")
        Image.contentMode = .scaleAspectFill
        Image.clipsToBounds = true
        
        Image.translatesAutoresizingMaskIntoConstraints = false
        Image.topAnchor.constraint(equalTo: lblTital.bottomAnchor, constant: 0).isActive = true
        Image.centerXAnchor.constraint(equalTo: BaseView.centerXAnchor, constant: 0).isActive = true
        Image.widthAnchor.constraint(equalToConstant: 140).isActive = true
        Image.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = .pi * 2.0 * 2 * 60.0
        rotationAnimation.duration = 300.0
        rotationAnimation.isCumulative = false
        rotationAnimation.repeatCount = Float.infinity
        Image.layer.add(rotationAnimation, forKey: "rotationAnimation")
        
        
        BaseView.addSubview(lblMessage)
        lblMessage.text = "We could not detect an internet connection."
        lblMessage.textColor = UIColor.black
        lblMessage.font = UIFont(name: "futura", size: 16.0)
        lblMessage.lineBreakMode = .byWordWrapping
        lblMessage.numberOfLines = 2
        lblMessage.textAlignment = .center
        lblMessage.sizeToFit()
        
        lblMessage.translatesAutoresizingMaskIntoConstraints = false
        
        lblMessage.topAnchor.constraint(equalTo: Image.bottomAnchor, constant: 0).isActive = true
        lblMessage.heightAnchor.constraint(equalToConstant: 45).isActive = true
        lblMessage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        lblMessage.centerXAnchor.constraint(equalTo: BaseView.centerXAnchor, constant: 0).isActive = true
        
        BaseView.addSubview(LineView)
        
        LineView.backgroundColor = UIColor.black
        
        LineView.translatesAutoresizingMaskIntoConstraints = false
        
        LineView.topAnchor.constraint(equalTo: lblMessage.bottomAnchor, constant: 3).isActive = true
        LineView.leadingAnchor.constraint(equalTo: BaseView.leadingAnchor, constant: 0).isActive = true
        LineView.trailingAnchor.constraint(equalTo: BaseView.trailingAnchor, constant: 0).isActive = true
        LineView.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        
        BaseView.addSubview(lblButton)
        lblButton.text = "ok"
        lblButton.textColor = UIColor.blue
        lblButton.font = UIFont(name: "futura", size: 20.0)
        lblButton.lineBreakMode = .byWordWrapping
        lblButton.numberOfLines = 1
        lblButton.textAlignment = .center
        lblButton.sizeToFit()
        
        lblButton.translatesAutoresizingMaskIntoConstraints = false
        
        lblButton.topAnchor.constraint(equalTo: LineView.bottomAnchor, constant: 0).isActive = true
        lblButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        lblButton.centerXAnchor.constraint(equalTo: BaseView.centerXAnchor, constant: 0).isActive = true
        lblButton.bottomAnchor.constraint(equalTo: BaseView.bottomAnchor, constant: 0).isActive = true
        
        view.addSubview(Main)
        return Main
    }
    
    func RemoveNetworkLostView()
    {
        Main.removeFromSuperview()
    }
    
    //MARK:- Check Login
    
    func checkLoginStatus ()
    {
        print(NSUserDefaultClass.sharedInstance.getIsLoggin())
        let LoginStatus = NSUserDefaultClass.sharedInstance.getIsLoggin()
        
        if LoginStatus == true
        {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            guard let HomeVC = storyboard.instantiateViewController(withIdentifier: "TapBarVC") as? TapBarVC else { return }
            self.window?.makeKeyAndVisible()
            let navigationVC = UINavigationController(rootViewController: HomeVC)
            navigationVC.isNavigationBarHidden = true
            self.window?.rootViewController = navigationVC
        }
        else
        {
            NSUserDefaultClass.sharedInstance.removeUserDetails()
            let storyboard = UIStoryboard(name: "SignUpIn", bundle: nil)
            guard let SignIn = storyboard.instantiateViewController(withIdentifier: "SignIn") as? SignIn else { return }
            self.window?.makeKeyAndVisible()
            let navigationVC = UINavigationController(rootViewController: SignIn)
            navigationVC.isNavigationBarHidden = true
            self.window?.rootViewController = navigationVC
        }
    }
}

