

import Foundation

class LoginClass: NSObject,NSCoding {
    
    var Id: String
    var Name : String
    var Email : String
    var Password: String
    var profile_pic : String
    
    init(Id:String,Name: String,Email: String,Password:String,profile_pic: String) {
        
        self.Id = Id
        self.Name = Name
        self.Email = Email
        self.Password = Password
        self.profile_pic = profile_pic
    }
    
    required init(coder aDecoder: NSCoder) {
        self.Id = aDecoder.decodeObject(forKey: "id") as! String
        self.Name = aDecoder.decodeObject(forKey: "name") as! String
        self.Email = aDecoder.decodeObject(forKey: "email") as! String
        self.Password = aDecoder.decodeObject(forKey: "password") as! String
        self.profile_pic = aDecoder.decodeObject(forKey: "profilepic") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(Id, forKey: "id")
        aCoder.encode(Name, forKey: "name")
        aCoder.encode(Email, forKey: "email")
        aCoder.encode(Password, forKey: "password")
        aCoder.encode(profile_pic, forKey: "profilepic")
    }
}

