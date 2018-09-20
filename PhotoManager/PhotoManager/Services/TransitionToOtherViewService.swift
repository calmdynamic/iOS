//
//  TransitionToOtherViewService.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-01.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import UIKit

class TransitionToOtherViewService{
    static let SEGUE_IDENTIFIER_FOR_TYPE_TO_FOLDER = "typeFolderSegue"
    static let SEGUE_IDENTIFIER_FOR_TYPE_TO_IMAGE = "typeImageSegue"
    static let DEFAULT_FOLDER_TYPE_NAME = "Default"
    static let SEGUE_IDENTIFIER_FOR_FOLDER_TO_IMAGE = "folderImageSegue"
    static let SEGUE_IDENTIFIER_FOR_IMAGE_TO_IMAGE_DETAIL = "imageDetailSegue"
    static let SEGUE_IDENTIFIER_FOR_IMAGE_TO_DOWNLOAD = "downloadSegue"
    
    
    public static func folderTypeViewTransition(folderTypes: TypeList, segue: UIStoryboardSegue, collectionView: UICollectionView){
        
        let indexpaths = collectionView.indexPathsForSelectedItems
        var selectedFolderType = folderTypes.getOneFolderTypeByIndedx(index: indexpaths![0].item)
        
        
        //if user clicks non default folder then it will go to the next folder
        if selectedFolderType.getName() != DEFAULT_FOLDER_TYPE_NAME{
            if segue.identifier == SEGUE_IDENTIFIER_FOR_TYPE_TO_FOLDER{
                let folderVC = segue.destination as! FolderViewController
                
                selectedFolderType = folderTypes.getOneFolderTypeByIndedx(index: indexpaths![0].item)
                folderVC.folderType = selectedFolderType
            }
            
        } else {
            //if user click default folder then it will go to image view
            if segue.identifier == SEGUE_IDENTIFIER_FOR_TYPE_TO_IMAGE{
                let imageVC = segue.destination as! ImageViewController
                selectedFolderType = folderTypes.getOneFolderTypeByIndedx(index: indexpaths![0].item)
                let selectedFolder = selectedFolderType.getFolders()[0]
                
                //imageVC.selectedFolderType = selectedFolderType
                imageVC.selectedFolder = selectedFolder
                
            }
        }
    }
    
    public static func folderViewTransition(folderType: Type, segue: UIStoryboardSegue, collectionView: UICollectionView){
        if segue.identifier == SEGUE_IDENTIFIER_FOR_FOLDER_TO_IMAGE{
            let imageVC = segue.destination as! ImageViewController
            let indexpaths = collectionView.indexPathsForSelectedItems
            
            let selectedFolder = folderType.getFolderArray()[indexpaths![0].item]
            
            //imageVC.selectedFolderType = folderType
            imageVC.selectedFolder = selectedFolder
            
        }
    }
    
    public static func imageViewTransition(selectedFolder: Folder,segue: UIStoryboardSegue, collectionView: UICollectionView){
        if segue.identifier == SEGUE_IDENTIFIER_FOR_IMAGE_TO_IMAGE_DETAIL{
            let imageDetailVC = segue.destination as! ImageDetailsViewController
            let indexpaths = collectionView.indexPathsForSelectedItems
            
            //self.selectedFolder.getImageArray()[indexPath.item].loadImageFromPath()
            imageDetailVC.currentImage = selectedFolder.getImageArray()[indexpaths![0].item]
            imageDetailVC.selectedFolder = selectedFolder
            
        }
        
        if segue.identifier == SEGUE_IDENTIFIER_FOR_IMAGE_TO_DOWNLOAD{
            let downloadVC = segue.destination as! DownloadListViewController
            //let indexpaths = self.collectionView?.indexPathsForSelectedItems
            downloadVC.selectedFolderTypeName = selectedFolder.getCategoryName()
            downloadVC.selectedFolder = selectedFolder
            //downloadVC.location = self.location
            
        }
    }
}
