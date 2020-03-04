

import Foundation

class NSUserDefaultClass: NSObject {
    
    // MARK: - Shared Instance
    // MARK: -
    
    static let sharedInstance: NSUserDefaultClass = {
        let instance = NSUserDefaultClass()
        // setup code
        return instance
    }()
    
    // MARK: - Initialization Method
    // MARK: -
    
    override init() {
        super.init()
    }
    
    //Login
    public func setIsLoggin(isLoggin: Bool){
        
        let defaults = UserDefaults.standard
        defaults.set(isLoggin, forKey: "isLoggin")
        defaults.synchronize()
    }
    
    public func getIsLoggin()->Bool{
        return  self.isKeyPresentInUserDefaults(key: "isLoggin")
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        
        if  (UserDefaults.standard.object(forKey: key) == nil) {
            return false
        }
        let defaults = UserDefaults.standard
        return defaults.object(forKey: "isLoggin")as! Bool
    }
    
  
 //   Set-Get UserData
  public func setUserDetails(logindata:LoginClass){

    let defaults = UserDefaults.standard
    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: logindata)
    defaults.set(encodedData, forKey: "USERDATA")

     defaults.synchronize()
   }

   public func getUserDetails()-> LoginClass?{

     let defaults = UserDefaults.standard
     let decoded  = defaults.object(forKey: "USERDATA") as? Data
     if decoded != nil
     {
         let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded!)

         return decodedTeams as? LoginClass
     }
        return nil
    }

   public func removeUserDetails()->Void{
     let defaults = UserDefaults.standard
     defaults.set(nil, forKey: "USERDATA")
     defaults.synchronize()
   }
 }

