//
//  FirebaseService.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-17.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase
import FirebaseAuth

class FirebaseService{
    
//    static var isSignIn: Bool!
    
    public static func getLocationDataFromFirebase(_ userLocation : NSDictionary) -> Location{
        let locationlongtitude = userLocation["longtitude"] as? Double
        let locationlatitude = userLocation["latitude"] as? Double
        let locationStreet = userLocation["street"] as? String
        let locationCity = userLocation["city"] as? String
        let locationProvince = userLocation["province"] as? String
        
        return Location(latitude: locationlatitude!, longtitude: locationlongtitude!, street: locationStreet!, city: locationCity!, province: locationProvince!)
    }
    
    public static func getDateFromFirebase(_ userDate : NSDictionary) -> Date{
        // Specify date components
        var dateComponents = DateComponents()
        dateComponents.year = userDate["year"] as? Int
        dateComponents.month = userDate["month"] as? Int
        dateComponents.day = userDate["day"] as? Int
        dateComponents.hour = userDate["hour"] as? Int
        dateComponents.minute = userDate["minute"] as? Int
        dateComponents.second = userDate["second"] as? Int
        
        // Create date from components
        let userCalendar = Calendar.current // user calendar
        return userCalendar.date(from: dateComponents)!
    }
    
    public static func getHashTagDataFromFirebase(_ userHashtag : [String: String]) -> List<HashTag> {
        var hashtags: List<HashTag>
        hashtags = List<HashTag>()
        
        for k in userHashtag{
            hashtags.append(HashTag(hashTag: k.value))
        }
        
        return hashtags
    }
    
    
    public static func deleteFirebaseImage(controller: UIViewController, tableView: UITableView,indexPath: IndexPath, imageArray: ImageArray, noDataAvailableLabel: UILabel){
        
        let image = (imageArray.getImageFromArray(index: indexPath.item))
        var userEmail: String = (Auth.auth().currentUser?.email)!
        userEmail = userEmail.replacingOccurrences(of: ".", with: ",")
        Database.database().reference().child(userEmail).child(image.getImageID()).setValue(nil){
            error,_  in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
        Storage.storage().reference().child(image.getImageID()+".png").delete { error in
            if error != nil{
                AlertDialog.showAlertMessage(controller: controller, title: "Error", message: "Deleted Unsuccessfully", btnTitle: "Ok")
                
            }else{
                AlertDialog.showAlertMessage(controller: controller, title: "", message: "Deleted Successfully", btnTitle: "Ok")
            }
        }
        imageArray.removeOneElementFromImageArray(index: indexPath.item)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        
        print("counting...")
        print(indexPath.count)
        
        if tableView.numberOfRows(inSection: 0) == 0 {
            noDataAvailableLabel.isHidden = false
        }
    }
    
    public static func authErrorMessage(error: Error, email: String, pass: String) -> String{
        var errorMessage: String = ""
        
        if email == ""{
            return "Please Enter Your Email"
        }
        
        if pass == ""{
            return "Please Enter Your Password"
        }
        
        if let errCode = AuthErrorCode(rawValue: error._code){
            
            switch errCode {
            case .invalidEmail:
                errorMessage += "Invalid Email"
                break
            case .customTokenMismatch:
                errorMessage += "Custom Token Mismatch"
                break
            case .invalidCredential:
                errorMessage += "Invalid Credential"
                break
            case .userDisabled:
                errorMessage += "User Disabled"
                break
            case .operationNotAllowed:
                errorMessage += "Operation Not Allowed"
                break
            case .emailAlreadyInUse:
                errorMessage += "Email Already In Use"
                break
            case .wrongPassword:
                errorMessage += "Wrong Password"
                break
            case .tooManyRequests:
                errorMessage += "Too Many Requests"
                break
            case .userNotFound:
                errorMessage += "User Not Found"
                break
            case .accountExistsWithDifferentCredential:
                errorMessage += "Account Exists With Different Credential"
                break
            case .requiresRecentLogin:
                errorMessage += "Requires Recent Login"
                break
            case .providerAlreadyLinked:
                errorMessage += "Provider Already Linked"
                break
            case .noSuchProvider:
                errorMessage += "No Such Provider"
                break
            case .invalidUserToken:
                errorMessage += "Invalid User Token"
                break
            case .networkError:
                errorMessage += "Network Error"
                break
            case .userTokenExpired:
                errorMessage += "User Token Expired"
                break
            case .invalidAPIKey:
                errorMessage += "Invalid API Key"
                break
            case .userMismatch:
                errorMessage += "User Mismatch"
                break
            case .credentialAlreadyInUse:
                errorMessage += "Credential Already In Use"
                break
            case .weakPassword:
                errorMessage += "Weak Password"
                break
            case .appNotAuthorized:
                errorMessage += "App Not Authorized"
                break
            case .expiredActionCode:
                errorMessage += "Expired Action Code"
                break
            case .invalidActionCode:
                errorMessage += "Invalid Action Code"
                break
            case .invalidMessagePayload:
                errorMessage += "Invalid Message Payload"
                break
            case .invalidSender:
                errorMessage += "Invalid Sender"
                break
            case .invalidRecipientEmail:
                errorMessage += "Invalid Recipient Email"
                break
            case .missingEmail:
                errorMessage += "Missing Email"
                break
            case .missingIosBundleID:
                errorMessage += "Missing IOS Bundle ID"
                break
            case .missingAndroidPackageName:
                errorMessage += "Missing Android Package Name"
                break
            case .unauthorizedDomain:
                errorMessage += "Unauthroized Domain"
                break
            case .invalidContinueURI:
                errorMessage += "Invalid Continue URI"
                break
            case .missingContinueURI:
                errorMessage += "Missing Continue URI"
                break
            case .missingPhoneNumber:
                errorMessage += "Missing Phone Number"
                break
            case .invalidPhoneNumber:
                errorMessage += "Invalid Phone Number"
                break
            case .missingVerificationCode:
                errorMessage += "Missing Verification Code"
                break
            case .invalidVerificationCode:
                errorMessage += "Invalid Verification Code"
                break
            case .missingVerificationID:
                errorMessage += "Missing Verification ID"
                break
            case .invalidVerificationID:
                errorMessage += "Invalid Verification ID"
                break
            case .missingAppCredential:
                errorMessage += "Missing App Credential"
                break
            case .invalidAppCredential:
                errorMessage += "Invalid App Credential"
                break
            case .sessionExpired:
                errorMessage += "Session Expired"
                break
            case .quotaExceeded:
                errorMessage += "Quota Exceeded"
                break
            case .missingAppToken:
                errorMessage += "Missing App Token"
                break
            case .notificationNotForwarded:
                errorMessage += "Noficiation Not Forwarded"
                break
            case .appNotVerified:
                errorMessage += "App Not Verified"
                break
            case .captchaCheckFailed:
                errorMessage += "Captcha Check Failed"
                break
            case .webContextAlreadyPresented:
                errorMessage += "Web Context Already Presented"
                break
            case .webContextCancelled:
                errorMessage += "Web Context Cancelled"
                break
            case .appVerificationUserInteractionFailure:
                errorMessage += "App Verification User Interaction Failure"
                break
            case .invalidClientID:
                errorMessage += "Invalid Client ID"
                break
            case .webNetworkRequestFailed:
                errorMessage += "Web Network Request Failed"
                break
            case .webInternalError:
                errorMessage += "Web Internal Error"
                break
            case .keychainError:
                errorMessage += "Keychain Error"
                break
            case .internalError:
                errorMessage += "Internal Error"
                break
            case .invalidCustomToken:
                errorMessage += "Invalid Custom Token"
                break
            }
            
            
        }
        return errorMessage
    }
    
    static func getCurrentUserName()->String{
        if Auth.auth().currentUser != nil{
            return (Auth.auth().currentUser?.email)!
        }else{
            return ""
        }
    }
    
}
