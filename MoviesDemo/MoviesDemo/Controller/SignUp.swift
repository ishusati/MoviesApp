


import UIKit
import CropViewController
import Alamofire
import Firebase

class SignUp: UIViewController {

    //MARK:- Outlet
    @IBOutlet var ProfilePic: UIImageView!
    @IBOutlet var txtUserName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPass: UITextField!
    @IBOutlet var btnRegister: UIButton!
    @IBOutlet var lblError: UILabel!
        
    //MARK:- Variable
    var picker = UIImagePickerController()
    private let imageView = UIImageView()
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    
    //MARK:- ViewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.applyGradient(locations:  [0.1, 1.1])
        self.SetUpVC()
        self.ProfilePic.image = UIImage(named: "Profile")
    }
    
    //MARK:- VIewWillAppear
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if (Reachability.isConnectedToNetwork() == true)
        {
            self.lblError.isHidden = true
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
    @IBAction func ProfilePic(_ sender: Any)
    {
        let Alert = UIAlertController(title: "", message: "Change Display Picture ", preferredStyle: .actionSheet)
        
        let ok = UIAlertAction(title: "Choose Picture", style: .default) { (UIAlertAction) in
            
            self.openGallary()
        }
        
        Alert.addAction(ok)
        
        let photo = UIAlertAction(title: "Take Photo", style: .default) { (UIAlertAction) in
            self.Camera()
            
        }
        
        Alert.addAction(photo)
        
        let photo1 = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
        }
        
        Alert.addAction(photo1)
        
        self.present(Alert, animated: true, completion: nil)
    }
    
    @IBAction func btnRegister(_ sender: Any)
    {
        guard let UserName = self.txtUserName.text, let Email = self.txtEmail.text, let Pass = self.txtPass.text else {return}

        if ProfilePic.image == UIImage(named: "Profile")!
        {
            self.lblError.isHidden = false
            self.lblError.text = "Select Profile Pic"
        }
        else if UserName.isEmpty
        {
            self.lblError.isHidden = false
            self.lblError.text = "Enter Username"
        }
        else if Email.isEmpty
        {
            self.lblError.isHidden = false
            self.lblError.text = "Enter Email Address"
        }
        else if !Email.isValidEmail()
        {
            self.lblError.isHidden = false
            self.lblError.text = "Enter Valid Email Address"
        }
        else if Pass.isEmpty
        {
            self.lblError.isHidden = false
            self.lblError.text = "Enter password"
        }
        else if Pass.count < 8
        {
            self.lblError.isHidden = false
            self.lblError.text = "password must be minimam charater 8"
        }
        else
        {
            if lblError.isHidden == true
            {
                let SignUpManager = FirebaseManager()
                
                SignUpManager.SignUp(email: Email, password: Pass) {[weak self] (success) in
                   
                    if(success)
                    {
                        self?.alert(message: "sucessfully SignUp", title: "Sucessfully")
                        
                        self!.UploadImage(image: (self?.ProfilePic.image)!) { (url) in

                            if url != nil
                            {
                                let StrUrl = url!.absoluteString
                                print("StrUrl :- \(StrUrl)")

                                let userData = ["username": UserName,"email":Email,"password": Pass,"profilepicurl":StrUrl]
                                let ref = Database.database().reference()
                                ref.child("users").childByAutoId().setValue(userData)
                                self?.navigationController?.popViewController(animated: true)
                            }
                            else
                            {
                              print("Image Are Not Upload Error")
                            }
                        }
                    }
                    else
                    {
                        self?.lblError.isHidden = false
                        self?.lblError.text = "Email Address is Allready Taken try Another Email Addresss"
                    }
                }
            }
            else
            {
                
            }
        }
    }
}

//MARK:- Function
extension SignUp
{
    func SetUpVC()
    {
       self.txtUserName.attributedPlaceholder = NSAttributedString(string: "Enter Username", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
      self.txtEmail.attributedPlaceholder = NSAttributedString(string: "Enter Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
      self.txtPass.attributedPlaceholder = NSAttributedString(string: "Enter Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
      
      self.txtEmail.keyboardType = .emailAddress
      
      self.txtEmail.delegate = self
      self.txtPass.delegate = self
      self.txtUserName.delegate = self
        
      self.btnRegister.layer.borderWidth = 1
      self.btnRegister.layer.borderColor = #colorLiteral(red: 1, green: 0.6666666667, blue: 0.1882352941, alpha: 1)
     
      self.btnRegister.backgroundColor = UIColor.orange
      
      self.txtEmail.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)
      self.txtPass.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)
      self.txtUserName.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)
        
      self.txtEmail.layer.cornerRadius = self.txtEmail.frame.height/2
      self.txtPass.layer.cornerRadius = self.txtPass.frame.height/2
      self.txtUserName.layer.cornerRadius = self.txtUserName.frame.height/2
      
      self.btnRegister.layer.cornerRadius = self.btnRegister.frame.height/2
      
      self.ProfilePic.layer.cornerRadius = self.ProfilePic.frame.height/2
      self.ProfilePic.clipsToBounds = true
    }
    
    func Camera()
    {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil
        {
          self.croppingStyle = .circular
          self.picker.delegate = self
          self.picker.allowsEditing = false
          self.picker.sourceType = .camera
          self.picker.cameraDevice = .rear
          self.picker.sourceType = UIImagePickerController.SourceType.camera
          self.picker.cameraCaptureMode = .photo
          self.present(picker, animated: true, completion: nil)
        }
        else
        {
            self.Nodevicecamera()
        }
    }
    
    func Nodevicecamera()
    {
        let Alert = UIAlertController(title: "No Camera", message: "Your Device Not Support in Camera", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            
        }
        
        Alert.addAction(ok)
        self.present(Alert, animated: true, completion: nil)
    }
    
    func openGallary()
    {
        self.croppingStyle = .circular
        self.picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.picker.delegate = self
        self.picker.allowsEditing = false
        self.present(picker, animated: true, completion: nil)
    }
}

//MARK:- UItextfield DeleGate Method
extension SignUp: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtUserName
        {
          self.lblError.isHidden = true
        }
        else if textField == txtEmail
        {
            self.lblError.isHidden = true
        }
        else if textField == txtPass
        {
           self.lblError.isHidden = true
        }
        
      return true
        
    }
}

//MARK:- ImagePickerView DeleGate And DataSource Method
extension SignUp : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let img = info[.editedImage] as? UIImage
        {
           
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute:
            {
                self.CropImageNew(image: img)
            })
            
             self.dismiss(animated: true, completion: nil)
        }
            
        else if let img = info[.originalImage] as? UIImage
        {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute:
            {
                self.CropImageNew(image: img)
            })
            
          self.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true,completion: nil)
    }
    
    func CropImageNew(image:UIImage)
    {
        
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.modalPresentationStyle = .fullScreen
        cropController.delegate = self
         
        cropController.resetButtonHidden = true
        self.present(cropController, animated: true, completion: nil)
    }
}

//MARK:- ImageCrop DeleGate Method
extension SignUp : CropViewControllerDelegate
{
     public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
          updateImageViewWithImage(image, fromCropViewController: cropViewController)
      }
 
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        ProfilePic.image = image
        layoutImageView()
        cropViewController.dismiss(animated: true, completion: nil)
        
    }
    
    public func layoutImageView() {
        guard imageView.image != nil else { return }
        
        let padding: CGFloat = 50.0
        
        var viewFrame = self.view.bounds
        viewFrame.size.width -= (padding * 2.0)
        viewFrame.size.height -= ((padding * 2.0))
        
        var imageFrame = CGRect.zero
        imageFrame.size = imageView.image!.size;
        
        if imageView.image!.size.width > viewFrame.size.width || imageView.image!.size.height > viewFrame.size.height {
            let scale = min(viewFrame.size.width / imageFrame.size.width, viewFrame.size.height / imageFrame.size.height)
            imageFrame.size.width *= scale
            imageFrame.size.height *= scale
            imageFrame.origin.x = (self.view.bounds.size.width - imageFrame.size.width) * 0.5
            imageFrame.origin.y = (self.view.bounds.size.height - imageFrame.size.height) * 0.5
            imageView.frame = imageFrame
        }
        else {
            self.imageView.frame = imageFrame;
            self.imageView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        }
    }
}

//MARK:- ImageUploadFirBase
extension SignUp
{
    func UploadImage(image :UIImage, completion: @escaping ((_ url: URL?) -> ())) {
        let storageRef = Storage.storage().reference().child("ProfileImage").child("\(txtUserName.text!)ProfileImage.png")
        let imgData = image.pngData()
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        storageRef.putData(imgData!, metadata: metaData) { (metadata, error) in
            if error == nil{
                storageRef.downloadURL(completion: { (url, error) in
                    completion(url)
                })
            }else{
                print("error in save image")
                completion(nil)
            }
        }
    }
}
