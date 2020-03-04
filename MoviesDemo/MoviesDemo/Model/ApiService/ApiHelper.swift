

import UIKit
import Alamofire

class ApiHelper: NSObject {

    static let sharedInstance = ApiHelper()
    
    
    func GetMethodServiceCall(url : String, completion: @escaping (NSDictionary?,String?) -> ()) {

        print("Url :- " + url)
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                print(response)

                switch response.result {
                case .success:
                    if response.result.value != nil
                    {
                        let Res = response.result.value! as! NSDictionary
                        print("{----------------------------------**** GET ****----------------------------------")
                        print("GET : URL : \(url)")
                        print("Response : \(Res)")
                    print("-----------------------------------------------------------------------------------}")
                        
                        completion(Res,nil)

                    }
                    else
                    {
                        completion(nil,"Something went wrong!!!")
                    }

                case .failure(let error):
                    print(error)
                    let err = String(decoding: response.data!, as: UTF8.self)
                    print("{----------------------------------**** ECHO ****----------------------------------")
                    print("GET : URL : \(url)")
                    print("Echo : \(err)")
                print("-----------------------------------------------------------------------------------}")
                    
                    completion(nil,error.localizedDescription)
                }
        }
    }
}


