//
//  downloadedImageArray.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-10-29.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
class DownloadedImageArray{
    private var previewImageURLs: [URL] = [URL]()
    private var largeImageURLs: [URL] = [URL]()
    private var webImageURLs: [URL] = [URL]()
//    private var imageUI: [UIImage] = [UIImage]()
    private var currentPage: Int = 1
    
    public func addPreviewImageURLs(url: URL){
        self.previewImageURLs.append(url)
    }
    
    public func clearPreviewImageURLs(){
        self.previewImageURLs.removeAll()
    }
    
    public func addLargeImageURLs(url: URL){
        self.largeImageURLs.append(url)
    }
    
    public func clearLargeImageURLs(){
        self.largeImageURLs.removeAll()
    }
    
    public func addWebImageURLs(url: URL){
        self.webImageURLs.append(url)
    }
    
    public func clearWebImageURLs(){
        self.webImageURLs.removeAll()
    }
    
    public func setCurrentPage(currentPage: Int){
        self.currentPage = currentPage
    }
    
    public func getCurrentPage() -> Int{
        return self.currentPage
    }
    
    public func getTotalImage() -> Int{
        if self.largeImageURLs.count == self.previewImageURLs.count{
            return self.largeImageURLs.count
        }else{
            return 0
        }
    }
    
    public func getLargeImageURLs() -> [URL]{
        return self.largeImageURLs
    }
    
    public func getPreviewImageURLs() -> [URL]{
        return self.previewImageURLs
    }
    
    public func getWebImageURLs() -> [URL]{
        return self.webImageURLs
    }
    
}
