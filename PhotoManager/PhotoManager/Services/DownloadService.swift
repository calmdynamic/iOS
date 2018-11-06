//
//  DownloadService.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-10-13.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class DownloadService{

    public static func setEmptyMessageWhenNoCell(text: String, downloadedImageArray: DownloadedImageArray, collectionView: UICollectionView){
        print("setEmptyMessageWhenNoCell function performed")
        if (downloadedImageArray.getTotalImage() == 0) {
            collectionView.setEmptyMessage(text)
            
        } else {
            collectionView.restore()
        }
    }
    
    public static func fetchDataFromPixabay(page: Int, text: String, collectionView: UICollectionView, downloadedImageArray: DownloadedImageArray, loadingAlert: UIAlertController, downloadedVC: UIViewController, selectedFolderName: String, selectedFolderTypeName: String, newFolder: Folder, completion: ((Bool) -> (Void))?){
        
        print("fetchDataFromPixabay function performed")
        
        
        let replaced = text.replacingOccurrences(of: " ", with: "+")
        
        
        guard let url = URL(string: "https://pixabay.com/api/?key=10343860-c286c74258a86bca1122e224a&q=\(replaced)&image_type=photo&pretty=true&page=\(page)") else {
            
            setEmptyMessageWhenNoCell(text: "No data found", downloadedImageArray: downloadedImageArray, collectionView: collectionView)
            
            collectionView.reloadData()
            return
            
        }
        
//        loadingAlert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        print("11")
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        loadingAlert.view.addSubview(loadingIndicator)
        
        print("22")
        
        downloadedVC.present(loadingAlert, animated: true, completion: nil)
        
        print("22")
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    loadingAlert.dismiss(animated: true, completion: {
                        AlertDialog.showAlertMessage(controller: downloadedVC, title: "", message: "No internet connection; Please check your internet.", btnTitle: "Ok")
                    })
                    
                    print(error?.localizedDescription ?? "Response Error")
                    
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse as Data, options: []) as! [String:AnyObject]
                
                let hits = jsonResponse["hits"] as! [[String:AnyObject]]
                for i in hits{
                    let webImageURL = URL(string: i["webformatURL"] as! String)!
                    //for downloading
                    let largeImageURL = URL(string: i["largeImageURL"] as! String)!
                    let previewImageURL = URL(string: i["previewURL"] as! String)!
                    downloadedImageArray.addWebImageURLs(url: webImageURL)
                    downloadedImageArray.addLargeImageURLs(url: largeImageURL)
                    downloadedImageArray.addPreviewImageURLs(url: previewImageURL)
                    
                    
                    let hashTags = List<HashTag>()
                    
                    let hashTag1 = HashTag(hashTag: "#"+selectedFolderName)
                    let hashTag2 = HashTag(hashTag: "#"+selectedFolderTypeName)
                    
                    if selectedFolderTypeName == "Default"{
                        hashTags.append(hashTag1)
                    }else{
                        hashTags.append(hashTag1)
                        hashTags.append(hashTag2)
                    }
                    
                    
                    newFolder.addElementToImageArray(image: Image(categoryName: selectedFolderTypeName, subCategoryName: selectedFolderName, dateCreated: Date(), imagePath:
                        webImageURL.absoluteString as NSString, hashTags: hashTags, location: Location()))
                    
                }
                completion?(true)
                
            } catch let parsingError {
                print("Error", parsingError)
                completion?(false)
            }
        }
        task.resume()
        
    }
    
    
}
