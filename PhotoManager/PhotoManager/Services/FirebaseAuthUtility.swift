//
//  FirebaseAuthUtility.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-08-22.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseAuthUtility{
    public static func errorMessage(error: Error) -> String{
        var errorMessage: String = ""
        if let errCode = AuthErrorCode(rawValue: error._code){
            
            switch errCode {
            case .invalidEmail:
                errorMessage += "Invalid Email"
            case .customTokenMismatch:
                errorMessage += "Custom Token Mismatch"
            case .invalidCredential:
                errorMessage += "Invalid Credential"
            case .userDisabled:
                errorMessage += "User Disabled"
            case .operationNotAllowed:
                errorMessage += "Operation Not Allowed"
            case .emailAlreadyInUse:
                errorMessage += "Email Already In Use"
            case .wrongPassword:
                errorMessage += "Wrong Password"
            case .tooManyRequests:
                errorMessage += "Too Many Requests"
            case .userNotFound:
                errorMessage += "User Not Found"
            case .accountExistsWithDifferentCredential:
                errorMessage += "Account Exists With Different Credential"
            case .requiresRecentLogin:
                errorMessage += "Requires Recent Login"
            case .providerAlreadyLinked:
                errorMessage += "Provider Already Linked"
            case .noSuchProvider:
                errorMessage += "No Such Provider"
            case .invalidUserToken:
                errorMessage += "Invalid User Token"
            case .networkError:
                errorMessage += "Network Error"
            case .userTokenExpired:
                errorMessage += "User Token Expired"
            case .invalidAPIKey:
                errorMessage += "Invalid API Key"
            case .userMismatch:
                errorMessage += "User Mismatch"
            case .credentialAlreadyInUse:
                errorMessage += "Credential Already In Use"
            case .weakPassword:
                errorMessage += "Weak Password"
            case .appNotAuthorized:
                errorMessage += "App Not Authorized"
            case .expiredActionCode:
                errorMessage += "Expired Action Code"
            case .invalidActionCode:
                errorMessage += "Invalid Action Code"
            case .invalidMessagePayload:
                errorMessage += "Invalid Message Payload"
            case .invalidSender:
                errorMessage += "Invalid Sender"
            case .invalidRecipientEmail:
                errorMessage += "Invalid Recipient Email"
            case .missingEmail:
                errorMessage += "Missing Email"
            case .missingIosBundleID:
                errorMessage += "Missing IOS Bundle ID"
            case .missingAndroidPackageName:
                errorMessage += "Missing Android Package Name"
            case .unauthorizedDomain:
                errorMessage += "Unauthroized Domain"
            case .invalidContinueURI:
                errorMessage += "Invalid Continue URI"
            case .missingContinueURI:
                errorMessage += "Missing Continue URI"
            case .missingPhoneNumber:
                errorMessage += "Missing Phone Number"
            case .invalidPhoneNumber:
                errorMessage += "Invalid Phone Number"
            case .missingVerificationCode:
                errorMessage += "Missing Verification Code"
            case .invalidVerificationCode:
                errorMessage += "Invalid Verification Code"
            case .missingVerificationID:
                errorMessage += "Missing Verification ID"
            case .invalidVerificationID:
                errorMessage += "Invalid Verification ID"
            case .missingAppCredential:
                errorMessage += "Missing App Credential"
            case .invalidAppCredential:
                errorMessage += "Invalid App Credential"
            case .sessionExpired:
                errorMessage += "Session Expired"
            case .quotaExceeded:
                errorMessage += "Quota Exceeded"
            case .missingAppToken:
                errorMessage += "Missing App Token"
            case .notificationNotForwarded:
                errorMessage += "Noficiation Not Forwarded"
            case .appNotVerified:
                errorMessage += "App Not Verified"
            case .captchaCheckFailed:
                errorMessage += "Captcha Check Failed"
            case .webContextAlreadyPresented:
                errorMessage += "Web Context Already Presented"
            case .webContextCancelled:
                errorMessage += "Web Context Cancelled"
            case .appVerificationUserInteractionFailure:
                errorMessage += "App Verification User Interaction Failure"
            case .invalidClientID:
                errorMessage += "Invalid Client ID"
            case .webNetworkRequestFailed:
                errorMessage += "Web Network Request Failed"
            case .webInternalError:
                errorMessage += "Web Internal Error"
            case .keychainError:
                errorMessage += "Keychain Error"
            case .internalError:
                errorMessage += "Internal Error"
            case .invalidCustomToken:
                errorMessage += "Invalid Custom Token"
            }
            
            
        }
        return errorMessage
    }
    
}
