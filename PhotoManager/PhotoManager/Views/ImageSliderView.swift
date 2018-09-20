//
//  ItemViewController.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-12.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit

class ImageSliderView: UIViewController {
    
    fileprivate var isHidden = false
    var itemIndex: Int = 0
    
    @IBOutlet weak var scrollView: UIScrollView!
    var image: UIImage = UIImage(){
        didSet{
            if let imageView = contentImageView{
                imageView.image = image
            }
        }
    }

    
    @IBOutlet weak var contentImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        contentImageView.image = image
        
        scrollView.delegate = self
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func singleTap(_ sender: UITapGestureRecognizer) {
        isHidden = !isHidden
        self.navigationController?.setNavigationBarHidden(isHidden, animated: true)
        
        self.tabBarController?.tabBar.isHidden = isHidden
    
    }
    
    @IBAction func doubleTap(_ sender: UITapGestureRecognizer) {
        if ( self.scrollView.zoomScale < 1.9 ) {
            let newScale:CGFloat = scrollView.zoomScale * 2.0
            let zoomRect:CGRect = self.zoomRectForScale(newScale,
                                                        center: sender.location(in: sender.view))
            scrollView.zoom(to: zoomRect, animated: true)
        } else {
            scrollView.setZoomScale(1.0, animated: true)
        }
    }
    
}


//MARK:- UIScrollViewDelegate
extension ImageSliderView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.contentImageView
    }
    
    func zoomRectForScale(_ scale:CGFloat, center: CGPoint) -> CGRect{
        var zoomRect = CGRect()
        zoomRect.size.height = scrollView.frame.size.height / scale
        zoomRect.size.width = scrollView.frame.size.width / scale
        zoomRect.origin.x = center.x - zoomRect.size.width / 2.0
        zoomRect.origin.y = center.y - zoomRect.size.height / 2.0
        return zoomRect
    }
}

