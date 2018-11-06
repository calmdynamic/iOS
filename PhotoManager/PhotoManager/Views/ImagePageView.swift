//
//  ImagePageViewViewController.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-12.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
import SDWebImage

class ImagePageView: NSObject, UIPageViewControllerDataSource {

    var imageArray: [Image] = []
    
    func setupImageArray(imageArray: [Image]) {
        self.imageArray = imageArray
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return goFowardPage(viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return goBackPage(viewController)
    }
    
    fileprivate func goBackPage(_ viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! ImageSliderView).itemIndex
        if index == 0 || index == NSNotFound {
            return nil
        }
        index -= 1
        return getItemController(index)
    }
    
    fileprivate func goFowardPage(_ viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! ImageSliderView).itemIndex
        
        if index == NSNotFound {
            return nil;
        }
        index += 1
        if index == imageArray.count {
            return nil;
        }
        return self.getItemController(index)
    }

    
    func getItemController(_ itemIndex: Int)-> ImageSliderView?{
        if itemIndex < imageArray.count{
            let pageItemController = UIStoryboard.getViewController("Main", identifier: "ItemController") as! ImageSliderView
            pageItemController.itemIndex = itemIndex
            
            print("url.....path")
            print(imageArray[itemIndex].getImagePath())
            
            pageItemController.image = #imageLiteral(resourceName: "Placeholder")
            
            if imageArray[itemIndex].getImagePath().hasPrefix("https"){
                
               
 
                let imageViewUI: UIImageView = UIImageView()
                

                
                imageViewUI.sd_setImage(with: URL(string: self.imageArray[itemIndex].getImagePath() as! String), placeholderImage: #imageLiteral(resourceName: "Placeholder")) { (image, error, cacheType, url) in
                    
                    
                    
                    pageItemController.image = imageViewUI.image!
                   
                }
                
                
            }else{
            
                pageItemController.image = imageArray[itemIndex].loadImageFromPath()!
            }
            //pageItemController.scrollView.delegate = pageViewController
            
            return pageItemController
        }
        
        return nil
    }
    
    

}
