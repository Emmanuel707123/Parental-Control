import UIKit
import Alamofire
import SVProgressHUD
import ReachabilitySwift

class APIUtilities: NSObject {
    
    class var sharedInstance : APIUtilities {
        struct Static {
            static let instance : APIUtilities = APIUtilities()
        }
        return Static.instance
    }
    
    //MARK:- Alamofire methods
    
    //MARK:- GET
    func GetAPICallWith(url:String, completionHandler:@escaping (AnyObject?, NSError?)->()) ->()
    {
        
        print("--------------------------------------------------------------------")
        print("URL : ",url)
        print("--------------------------------------------------------------------")
        
        if(self.checkNetworkConnectivity() == "NoAccess"){
            self.callNetworkAlert()
            SVProgressHUD.dismiss()
            return;
        }
        
        var token = ""
        
        if url.contains("get-child-detail")
        {
            token = ""
        }
        else{
            token = (AppData.sharedInstance.token == "") ? AppData.sharedInstance.kid_token : AppData.sharedInstance.token
        }
        
        let headers : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded",
                                     "Authorization":token]
        
        AF.request(url, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            //            .responseString(completionHandler: { (responsestr) in
            //                print(responsestr)
            //            })
            .responseJSON { response in
                
                if let JSON = response.value {
                    completionHandler(JSON as AnyObject?, nil)
                }
                else {
                    print(response.error ?? "")
                    completionHandler(nil, response.error! as NSError)
                }
        }
    }
    
    //MARK:- POST
    func POSTAPICallWithURLSession(url:String, param:String, completionHandler:@escaping (AnyObject?, NSError?)->()) ->()
    {
        print("--------------------------------------------------------------------")
        print("URL : ",url)
        print("Request Parameters : ",param)
        print("--------------------------------------------------------------------")
        
        if(self.checkNetworkConnectivity() == "NoAccess"){
            self.callNetworkAlert()
            SVProgressHUD.dismiss()
            return;
        }
        
        //let headers = ["Accept":"application/json","Authorization":AppData.sharedInstance.token]
        
        //let paramStr = jsonToString(json: param)
        let postData = param.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completionHandler(nil, String(describing: error) as? NSError)
                //print(String(describing: error))
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                completionHandler(json as AnyObject, nil)
            } catch let myJSONError {
                print(myJSONError)
            }
            
        }
        task.resume()
        
    }
    
    func jsonToString(json: AnyObject)->String{
        do {
            let data1 = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let convertedString =  String(data: data1, encoding: .utf8)
            return convertedString ?? ""
            
        } catch let myJSONError {
            print(myJSONError)
        }
        return ""
    }
    
    //MARK:- POST
    func POSTAPICallWith(url:String, param:AnyObject, completionHandler:@escaping (AnyObject?, NSError?)->()) ->()
    {
        print("--------------------------------------------------------------------")
        print("URL : ",url)
        print("Request Parameters : ",param)
        print("--------------------------------------------------------------------")
        
        if(self.checkNetworkConnectivity() == "NoAccess") {
            self.callNetworkAlert()
            SVProgressHUD.dismiss()
            return;
        }
        
        let headers : HTTPHeaders = ["Content-Type":"application/json",
                                     "Authorization":AppData.sharedInstance.token]
        
        AF.request(url, method: HTTPMethod.post, parameters: param as? Parameters, encoding: URLEncoding.default, headers: headers)
            .responseJSON { response in
                
                if let JSON = response.value {
                    completionHandler(JSON as AnyObject?, nil)
                }
                else {
                    print(response.error ?? "")
                    completionHandler(nil, response.error! as NSError)
                }
        }
    }
    
    //MARK:- POST
    func POSTLoginAPICallWith(url:String, param:AnyObject, completionHandler:@escaping (AnyObject?, NSError?)->()) ->()
    {
        print("--------------------------------------------------------------------")
        print("URL : ",url)
        print("Request Parameters : ",param)
        print("--------------------------------------------------------------------")
        
        if(self.checkNetworkConnectivity() == "NoAccess") {
            self.callNetworkAlert()
            SVProgressHUD.dismiss()
            return;
        }
        
        AF.request(url, method: HTTPMethod.post, parameters: param as? Parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
                if let JSON = response.value {
                    completionHandler(JSON as AnyObject?, nil)
                }
                else {
                    print(response.error ?? "")
                    completionHandler(nil, response.error! as NSError)
                }
        }
    }
    
    //MARK:- POST
    func POSTAPICallWith1(url:String, param:AnyObject, completionHandler:@escaping (AnyObject?, NSError?)->()) ->()
    {
        print("--------------------------------------------------------------------")
        print("URL : ",url)
        print("Request Parameters : ",param)
        print("--------------------------------------------------------------------")
        
        if(self.checkNetworkConnectivity() == "NoAccess") {
            self.callNetworkAlert()
            SVProgressHUD.dismiss()
            return;
        }
        
        AF.request(url, method: HTTPMethod.post, parameters: param as? Parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
                if let JSON = response.value {
                    completionHandler(JSON as AnyObject?, nil)
                }
                else {
                    print(response.error ?? "")
                    completionHandler(nil, response.error! as NSError)
                }
        }
    }
    
    //MARK:- Image Uploading
    func uploadImage(image:UIImage, url:String, param:NSDictionary, completionHandler:@escaping (AnyObject?, NSError?)->()) ->() {
        
        print("--------------------------------------------------------------------")
        print("URL : ",url)
        print("--------------------------------------------------------------------")
        
        if(self.checkNetworkConnectivity() == "NoAccess"){
            self.callNetworkAlert()
            SVProgressHUD.dismiss()
            return;
        }

        let headers : HTTPHeaders = ["Content-Type":"application/json","Authorization":AppData.sharedInstance.token]
        
        AF.upload(multipartFormData: { multipartFormData in
            let data = image.jpegData(compressionQuality: 0.5)//UIImageJPEGRepresentation(image, 0.5)
            
            multipartFormData.append(data!, withName: "profileImage", fileName: "profile_Placeholder.png", mimeType: "image/jpeg")
            //multipartFormData.append(data!, withName: "profile_image", mimeType: "image/png")
            
            for (key, value) in param {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }
        },
                         to: url,
                         method:.post,
                         headers:headers)
        .responseJSON(completionHandler: { (response) in
                
                print(response)
                
                if let err = response.error{
                    completionHandler(nil,err as NSError)
                    return
                }
                print("Succesfully uploaded")
                
            if let JSON = response.value {
                completionHandler(JSON as AnyObject?, nil)
            }
            })
    }
   
    //MARK: Network Check
    func checkNetworkConnectivity()->String
    {
        let network:Reachability = Reachability()!;
        var networkValue:String = "" as String
        
        switch network.currentReachabilityStatus {
        case .notReachable:
            networkValue = "NoAccess";
            debugPrint("Network became unreachable")
            
        case .reachableViaWiFi:
            networkValue = "wifi";
            debugPrint("Network reachable through WiFi")
            
        case .reachableViaWWAN:
            networkValue = "Cellular Data";
            debugPrint("Network reachable through Cellular Data")
        }
        
        return networkValue;
    }
    
    func callNetworkAlert()
    {
        let alert = UIAlertView()
        alert.title = "No Network Found!"
        alert.message = "Please check your internet connection."
        alert.addButton(withTitle: "OK")
        alert.show()
    }
    
    func ShowAlert(title: String, messsage: String)
    {
        let alert = UIAlertView()
        alert.title = title
        alert.message = messsage
        alert.addButton(withTitle: "OK")
        alert.show()
    }
    
    func callBadNetworkAlert()
    {
        let alert = UIAlertView()
        alert.title = "Bad Internet Connection!"
        alert.message = "Please check your internet connection."
        alert.addButton(withTitle: "OK")
        alert.show()
    }
}



