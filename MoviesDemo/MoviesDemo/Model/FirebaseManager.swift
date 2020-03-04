
import FirebaseAuth
import UIKit


class FirebaseManager {
    
    func SignUp(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                print(user)
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }
    
    func SignIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
    Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
        if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
            completionBlock(false)
        } else {
            completionBlock(true)
        }
    }
  }

}
