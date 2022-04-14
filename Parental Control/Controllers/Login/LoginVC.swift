//
//  LoginVC.swift
//  Parental Control
//
//  Created by Ashish Shiroya on 26/07/2021.
//

import UIKit
import FacebookLogin
import FacebookCore
import GoogleSignIn
import AuthenticationServices

class LoginVC: UIViewController {

    var id = String()
    var img_url = String()
    var name = String()
    var email = String()
    var type = String()
    @IBOutlet weak var appSignInStackView: UIStackView!
    var mobileNo = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpSignInAppleButton()
    }
    
    func setUpSignInAppleButton() {
        if #available(iOS 13.0, *) {
            let authorizationButton = ASAuthorizationAppleIDButton()
            authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
            authorizationButton.layer.cornerRadius = 10
            //Add button on some view or stack
            self.appSignInStackView.addArrangedSubview(authorizationButton)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    @available(iOS 13.0, *)
    @objc func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func navigateNext(id: String, img_url:String, name : String, email:String,type:String)
    {
        self.id = id
        self.img_url = img_url
        self.name = name
        self.email = email
        self.type = type
        self.logInWebService()
    }
    
    //MARK:- signUp web Service
    func logInWebService()
    {
        view.endEditing(true)
        AppData.sharedInstance.showLoader()
        
        let url = BASE_URL + LOGIN
        
        let params = ["name": name,
                      "email": email,
                      "provider": self.type] as NSDictionary
        
//        "app_device_id": AppData.sharedInstance.fcm_token,
        
        print("PARAM :=> \(params)")
        
        APIUtilities.sharedInstance.POSTLoginAPICallWith(url: url, param: params) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            
            print(response ?? "")
            if(error == nil)
            {
                guard let res = response as? NSDictionary, let user = res.value(forKey: "data") as? NSDictionary else{
                    return
                }
                if let token = user.value(forKey: "token") as? String
                {
                    UserDefaults.standard.setValue(token, forKey: "token")
                    AppData.sharedInstance.token = token
                    let AddChildVC = self.storyboard?.instantiateViewController(withIdentifier: "AddChildVC") as! AddChildVC
                    AddChildVC.isFrom = false
                    self.navigationController?.push(viewController: AddChildVC)
                }
                else{
                    AppData.sharedInstance.showAlert(title: "", message: res.value(forKey: "message") as! String, viewController: self)
                }
            }
        }
    }
    
    //MARK:- get Facebook Info
    func getUserProfile () {
        let connection = GraphRequestConnection()
        
        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, first_name, last_name, picture.type(large),birthday, location{location{country, country_code}}"])) { (httpResponse, result, error) in
            print("result == ", result)
            print("httpResponse == ", httpResponse)
            let resposne = result as! NSDictionary
            if error == nil
            {
                var img_url = String()
                if let picture = resposne.value(forKey: "picture") as? NSDictionary
                {
                    if let data = picture.value(forKey: "data") as? NSDictionary
                    {
                        if let url = data.value(forKey: "url") as? String
                        {
                            img_url = url
                        }
                    }
                }
                let id = resposne.value(forKey: "id") as? String
                let email = resposne.value(forKey: "email") as? String
                let first_name = resposne.value(forKey: "first_name") as? String
                let last_name = resposne.value(forKey: "last_name") as? String
                self.navigateNext(id: id!, img_url: img_url, name: first_name! + last_name!, email: email!, type: "facebook")
            }
            else{
                print("Graph Request Failed: \(error)")
            }
        }
        
        connection.start()
    }
    
    //MARK:- btn actions
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.pop()
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        
    }
    
    @IBAction func btnGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // Automatically sign in the user.
        //GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func btnApple(_ sender: Any) {
    
    }
    
    @IBAction func btnFB(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, let accessToken):
                let token = accessToken
                print("Logged in!", token)
                self.getUserProfile()
            }
        }
    }
}
@available(iOS 13.0, *)
extension LoginVC : ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            // Create an account in your system.
            // For the purpose of this demo app, store the these details in the keychain.
            KeychainItem.currentUserIdentifier = appleIDCredential.user
            KeychainItem.currentUserFirstName = appleIDCredential.fullName?.givenName
            KeychainItem.currentUserLastName = appleIDCredential.fullName?.familyName
            KeychainItem.currentUserEmail = appleIDCredential.email
            
            self.navigateNext(id: KeychainItem.currentUserIdentifier ?? "", img_url: "", name: KeychainItem.currentUserFirstName ?? "", email: KeychainItem.currentUserEmail ?? "", type: "apple")
            
            print("User Id - \(appleIDCredential.user)")
            print("User Name - \(appleIDCredential.fullName?.description ?? "N/A")")
            print("User Email - \(appleIDCredential.email ?? "N/A")")
            print("Real User Status - \(appleIDCredential.realUserStatus.rawValue)")
            
            if let identityTokenData = appleIDCredential.identityToken,
                let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
                print("Identity Token \(identityTokenString)")
            }
            
            //Show Home View Controller
            
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            self.navigateNext(id: "", img_url: "", name: username, email: "", type: "apple")
            
            // For the purpose of this demo app, show the password credential as an alert.
            /*DispatchQueue.main.async {
                let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
                let alertController = UIAlertController(title: "Keychain Credential Received",
                                                        message: message,
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }*/
        }
    }
}

//MARK:- Google SignIn Delegates
extension LoginVC : GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            //            let OTPVC = self.storyboard?.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
            //            self.navigationController?.pushViewController(OTPVC, animated: false)
            //
            print("Gmail login success")
            print(user)
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let name = user.profile.name
            let email = user.profile.email
            let userImageURL = user.profile.imageURL(withDimension: 200)
            // ...
            print(userImageURL)
            print(userId)
            print(idToken)
            print(name)
            print(email)
            
            self.navigateNext(id: userId!, img_url: userImageURL!.absoluteString, name: name!, email: email!, type: "google")
        }
        else{
            AppData.sharedInstance.showAlert(title: "", message: error.localizedDescription ?? "", viewController: self)
            print(error.localizedDescription)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        AppData.sharedInstance.showAlert(title: "", message: error.localizedDescription ?? "", viewController: self)
    }
}
