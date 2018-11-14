//
//  Folder.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-02-27.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import RealmSwift

class Folder: Object{
    @objc private dynamic  var folderID: String = UUID().uuidString
    @objc private dynamic var name: String = ""
    @objc private dynamic var categoryName: String = ""
    @objc private dynamic var createdDate: Date = Date()
    @objc private dynamic var imageCount: Int = 0
    
    private var images = List<Image>()
    private var imageArray:[Image] = [Image]()
    
    private var movedImagesSelection:[Image] = [Image]()
    
    private var numOfImageSelection: Int = 0
    private var didAddAlready: Bool = false
    private var newImage: UIImage = UIImage()
    private var ascSort: Bool = false
    
    override class func primaryKey() -> String?{
        return "folderID"
    }
    
    convenience init(name: String, createdDate: Date, images: List<Image>, categoryName: String){
        self.init()
        self.name = name
        self.createdDate = createdDate
        self.images = images
        self.categoryName = categoryName
    }
    
    
    func createCastleBuildingsData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "castle_1"), location: Location(latitude: 47.94, longtitude: -9.76, street: "ABC St", city: "Wierscheme", province: "Germany"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "castle_2"), location: Location(latitude: 47.94, longtitude: -9.76, street: "ABC St", city: "Wierscheme", province: "Germany"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "castle_3"), location: Location(latitude: 47.94, longtitude: -9.76, street: "ABC St", city: "Wierscheme", province: "Germany"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
    }
    
    func createSchoolBuildingsData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "school_1"), location: Location(latitude: 34.6784656, longtitude: 135.46, street: "ABC St", city: "Osaka", province: "Osaka Prefecture"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "school_2"), location: Location(latitude: 34.6784656, longtitude: 135.46, street: "ABC St", city: "Osaka", province: "Osaka Prefecture"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "school_3"), location: Location(latitude: 34.6784656, longtitude: 135.46, street: "ABC St", city: "Osaka", province: "Osaka Prefecture"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
    }
    
    func createJapenseBuildingsData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "japenses_building_1"), location: Location(latitude: 34.6784656, longtitude: 135.46, street: "ABC St", city: "Osaka", province: "Osaka Prefecture"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "japenses_building_2"), location: Location(latitude: 34.6784656, longtitude: 135.46, street: "ABC St", city: "Osaka", province: "Osaka Prefecture"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
    }
    
    func createChineseBuildingsData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "chinese_building_1"), location: Location(latitude: 38.937499, longtitude: 117.5000497, street: "ABC St", city: "Beijing", province: "Hebei"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "chinese_building_2"), location: Location(latitude: 38.937499, longtitude: 117.5000497, street: "ABC St", city: "Beijing", province: "Hebei"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
    }
    
    func createNeptunePlanetsData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "neptune_1"), location: Location(latitude: 38.8829024, longtitude: -77.0185637, street: "300 E St", city: "Washington", province: "DC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "neptune_2"), location: Location(latitude: 38.8829024, longtitude: -77.0185637, street: "300 E St", city: "Washington", province: "DC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
    }
    
    
    func createUranusPlanetsData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "uranus_1"), location: Location(latitude: 38.8829024, longtitude: -77.0185637, street: "300 E St", city: "Washington", province: "DC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
    }
    
    
    func createVenusPlanetsData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "venus_1"), location: Location(latitude: 38.8829024, longtitude: -77.0185637, street: "300 E St", city: "Washington", province: "DC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "venus_2"), location: Location(latitude: 38.8829024, longtitude: -77.0185637, street: "300 E St", city: "Washington", province: "DC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))

    }
    
    
    
    func createJupiterPlanetsData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "jupiter_1"), location: Location(latitude: 38.8829024, longtitude: -77.0185637, street: "300 E St", city: "Washington", province: "DC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "jupiter_2"), location: Location(latitude: 38.8829024, longtitude: -77.0185637, street: "300 E St", city: "Washington", province: "DC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))

    }
    
    
    func createMarsPlanetsData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "mars_1"), location: Location(latitude: 38.8829024, longtitude: -77.0185637, street: "300 E St", city: "Washington", province: "DC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
    }
    
    
    func createMercuryPlanetsData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "mercury_1"), location: Location(latitude: 38.8829024, longtitude: -77.0185637, street: "300 E St", city: "Washington", province: "DC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
        self.addImageToRealm(newImage:#imageLiteral(resourceName: "mercury_2"), location: Location(latitude: 38.8829024, longtitude: -77.0185637, street: "300 E St", city: "Washington", province: "DC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
     
    }
    
    
    func createSaturnPlanetsData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "saturn_1"), location: Location(latitude: 38.8829024, longtitude: -77.0185637, street: "300 E St", city: "Washington", province: "DC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "saturn_2"), location: Location(latitude: 38.8829024, longtitude: -77.0185637, street: "300 E St", city: "Washington", province: "DC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "saturn_3"), location: Location(latitude: 38.8829024, longtitude: -77.0185637, street: "300 E St", city: "Washington", province: "DC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
    }
    
    func createEarthPlanetsData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "earth_1"), location: Location(latitude: 38.8829024, longtitude: -77.0185637, street: "300 E St", city: "Washington", province: "DC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "earth_2"), location: Location(latitude: 38.8829024, longtitude: -77.0185637, street: "300 E St", city: "Washington", province: "DC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
    }
    
    func createHorrorMoviesData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "horror_1"), location: Location(latitude: 49.0787027, longtitude: -123.08678, street: "14211 Entertainment Blvd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
       
    }
    
    func createCrimeMoviesData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "crime_1"), location: Location(latitude: 49.0787027, longtitude: -123.08678, street: "14211 Entertainment Blvd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "crime_2"), location:  Location(latitude: 49.0787027, longtitude: -123.08678, street: "14211 Entertainment Blvd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2011, month: 9, day: 10, hour: 3, minute: 12, second: 23))
        
    }
    
    func createMysteryMoviesData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "mystery_1"), location: Location(latitude: 49.0787027, longtitude: -123.08678, street: "14211 Entertainment Blvd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
      
        
    }
    
    func createFantasyMoviesData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "fantasy_1"), location: Location(latitude: 49.0787027, longtitude: -123.08678, street: "14211 Entertainment Blvd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "fantasy_2"), location:  Location(latitude: 49.0787027, longtitude: -123.08678, street: "14211 Entertainment Blvd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2011, month: 9, day: 10, hour: 3, minute: 12, second: 23))
    }
    
    func createAdventureMoviesData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "adventure_1"), location: Location(latitude: 49.0787027, longtitude: -123.08678, street: "14211 Entertainment Blvd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "adventure_2"), location:  Location(latitude: 49.0787027, longtitude: -123.08678, street: "14211 Entertainment Blvd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2011, month: 9, day: 10, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "adventure_3"), location:  Location(latitude: 49.0787027, longtitude: -123.08678, street: "14211 Entertainment Blvd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2007, month: 3, day: 15, hour: 3, minute: 12, second: 23))
        
    }
    
    func createHistoricalMoviesData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "historical_1"), location: Location(latitude: 49.0787027, longtitude: -123.08678, street: "14211 Entertainment Blvd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "historical_2"), location:  Location(latitude: 49.0787027, longtitude: -123.08678, street: "14211 Entertainment Blvd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2011, month: 9, day: 10, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "historical_3"), location:  Location(latitude: 49.0787027, longtitude: -123.08678, street: "14211 Entertainment Blvd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2007, month: 3, day: 15, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "historical_4"), location:  Location(latitude: 49.0787027, longtitude: -123.08678, street: "14211 Entertainment Blvd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2007, month: 3, day: 15, hour: 3, minute: 12, second: 23))
        
    }
    
    func createRomanceMoviesData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "romance_1"), location: Location(latitude: 49.0787027, longtitude: -123.08678, street: "14211 Entertainment Blvd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
        
    }
    
    func createDramaMoviesData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "drama_1"), location: Location(latitude: 49.0787027, longtitude: -123.08678, street: "14211 Entertainment Blvd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
        
    }
    
    func createComedyMoviesData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "comedy_1"), location: Location(latitude: 49.0787027, longtitude: -123.08678, street: "14211 Entertainment Blvd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
        
    }
    
    func createActionMoviesData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "action_1"), location: Location(latitude: 49.0787027, longtitude: -123.08678, street: "14211 Entertainment Blvd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2012, month: 5, day: 15, hour: 8, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "action_2"), location:  Location(latitude: 49.0787027, longtitude: -123.08678, street: "14211 Entertainment Blvd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2011, month: 9, day: 10, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "action_3"), location:  Location(latitude: 49.0787027, longtitude: -123.08678, street: "14211 Entertainment Blvd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2007, month: 3, day: 15, hour: 3, minute: 12, second: 23))
        
    }
    
    func createBirdAnimalsData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "bird_1"), location: Location(latitude: 49.1511587, longtitude: -123.2013094, street: "5048 264 St", city: "Aldergrove", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 1, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "bird_2"), location:  Location(latitude: 49.1511587, longtitude: -123.2013094, street: "5048 264 St", city: "Aldergrove", province: "BC"), date:Image.setImageDate(year: 2011, month: 8, day: 2, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "bird_3"), location:  Location(latitude: 49.1511587, longtitude: -123.2013094, street: "5048 264 St", city: "Aldergrove", province: "BC"), date:Image.setImageDate(year: 2011, month: 8, day: 2, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "bird_4"), location:  Location(latitude: 49.1511587, longtitude: -123.2013094, street: "5048 264 St", city: "Aldergrove", province: "BC"), date:Image.setImageDate(year: 2011, month: 8, day: 2, hour: 3, minute: 12, second: 23))
    }
    
    func createCatAnimalsData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "cat_1"), location: Location(latitude: 49.1511587, longtitude: -123.2013094, street: "5048 264 St", city: "Aldergrove", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 1, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "cat_2"), location:  Location(latitude: 49.1511587, longtitude: -123.2013094, street: "5048 264 St", city: "Aldergrove", province: "BC"), date:Image.setImageDate(year: 2011, month: 8, day: 2, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "cat_3"), location:  Location(latitude: 49.1511587, longtitude: -123.2013094, street: "5048 264 St", city: "Aldergrove", province: "BC"), date:Image.setImageDate(year: 2011, month: 8, day: 2, hour: 3, minute: 12, second: 23))
    }
    
    func createDogAnimalsData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "dog_1"), location: Location(latitude: 49.1511587, longtitude: -123.2013094, street: "5048 264 St", city: "Aldergrove", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 1, hour: 3, minute: 12, second: 23))
    }
    
    func createLionAnimalsData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "lion_1"), location: Location(latitude: 49.1511587, longtitude: -123.2013094, street: "5048 264 St", city: "Aldergrove", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 1, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "lion_2"), location:  Location(latitude: 49.1511587, longtitude: -123.2013094, street: "5048 264 St", city: "Aldergrove", province: "BC"), date:Image.setImageDate(year: 2011, month: 8, day: 2, hour: 3, minute: 12, second: 23))
    }
    
    func createFishAnimalsData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "fish_1"), location: Location(latitude: 49.1511587, longtitude: -123.2013094, street: "5048 264 St", city: "Aldergrove", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 1, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "fish_2"), location:  Location(latitude: 49.1511587, longtitude: -123.2013094, street: "5048 264 St", city: "Aldergrove", province: "BC"), date:Image.setImageDate(year: 2011, month: 8, day: 2, hour: 3, minute: 12, second: 23))
    }
    
    func createPhysicsScienceData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "physics_1"), location: Location(latitude: 49.0920, longtitude: -122.5200, street: "ABC Rd", city: "Surrey", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 1, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "physics_2"), location: Location(latitude: 49.0920, longtitude: -122.5200, street: "ABC Rd", city: "Surrey", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 2, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "physics_3"), location: Location(latitude: 49.0920, longtitude: -122.5200, street: "ABC Rd", city: "Surrey", province: "BC"), date: Image.setImageDate(year: 2012, month: 9, day: 5, hour: 2, minute: 12, second: 23))
    }
    
    func createChemistryScienceData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "chemistry_1"), location: Location(latitude: 49.0920, longtitude: -122.5200, street: "ABC Rd", city: "Surrey", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 1, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "chemistry_2"), location: Location(latitude: 49.0920, longtitude: -122.5200, street: "ABC Rd", city: "Surrey", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 2, hour: 3, minute: 12, second: 23))
    }
    
    func createBiologyScienceData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "biology_1"), location: Location(latitude: 49.0920, longtitude: -122.5200, street: "ABC Rd", city: "Surrey", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 1, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "biology_2"), location: Location(latitude: 49.0920, longtitude: -122.5200, street: "ABC Rd", city: "Surrey", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 2, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "biology_3"), location: Location(latitude: 49.0920, longtitude: -122.5200, street: "ABC Rd", city: "Surrey", province: "BC"), date: Image.setImageDate(year: 2012, month: 9, day: 5, hour: 2, minute: 12, second: 23))
    }
    
    func createYogurtFoodData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "yogurt_1"), location: Location(latitude: 49.166592, longtitude: -123.133568, street: "No.3 Rd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 1, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "yogurt_2"), location: Location(latitude: 49.166592, longtitude: -123.133568, street: "No.3 Rd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 2, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "yogurt_3"), location: Location(latitude: 49.166592, longtitude: -123.133568, street: "No.3 Rd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2012, month: 9, day: 5, hour: 2, minute: 12, second: 23))
    }
    
    func createCheeseFoodData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "cheese_1"), location: Location(latitude: 49.166592, longtitude: -123.133568, street: "No.3 Rd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 1, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "cheese_2"), location: Location(latitude: 49.166592, longtitude: -123.133568, street: "No.3 Rd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 2, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "cheese_3"), location: Location(latitude: 49.166592, longtitude: -123.133568, street: "No.3 Rd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2012, month: 9, day: 5, hour: 2, minute: 12, second: 23))
    }
    
    func createCerealFoodData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "cereal_1"), location: Location(latitude: 49.166592, longtitude: -123.133568, street: "No.3 Rd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 1, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "cereal_2"), location: Location(latitude: 49.166592, longtitude: -123.133568, street: "No.3 Rd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 2, hour: 3, minute: 12, second: 23))
    }
    
    func createCakeFoodData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "cake_1"), location: Location(latitude: 49.166592, longtitude: -123.133568, street: "No.3 Rd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 1, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "cake_2"), location: Location(latitude: 49.166592, longtitude: -123.133568, street: "No.3 Rd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 2, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "cake_3"), location: Location(latitude: 49.166592, longtitude: -123.133568, street: "No.3 Rd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2012, month: 9, day: 5, hour: 2, minute: 12, second: 23))
    }
    
    
    func createCandyFoodData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "candy_1"), location: Location(latitude: 49.166592, longtitude: -123.133568, street: "No.3 Rd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 1, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "candy_2"), location: Location(latitude: 49.166592, longtitude: -123.133568, street: "No.3 Rd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 2, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "candy_3"), location: Location(latitude: 49.166592, longtitude: -123.133568, street: "No.3 Rd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2012, month: 9, day: 5, hour: 2, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "candy_4"), location: Location(latitude: 49.166592, longtitude: -123.133568, street: "No.3 Rd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 2, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "candy_5"), location: Location(latitude: 49.166592, longtitude: -123.133568, street: "No.3 Rd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 2, hour: 3, minute: 12, second: 23))
    }
    
    
    func createEggFoodData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "egg_1"), location: Location(latitude: 49.166592, longtitude: -123.133568, street: "No.3 Rd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 1, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "egg_2"), location: Location(latitude: 49.166592, longtitude: -123.133568, street: "No.3 Rd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 2, hour: 3, minute: 12, second: 23))
    }
    
    
    func createMilkFoodData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "milk_1"), location: Location(latitude: 49.166592, longtitude: -123.133568, street: "No.3 Rd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 1, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "milk_2"), location: Location(latitude: 49.166592, longtitude: -123.133568, street: "No.3 Rd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 2, hour: 3, minute: 12, second: 23))
    }
    
    
    func createFishFoodData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "fishFood_1"), location: Location(latitude: 49.166592, longtitude: -123.133568, street: "No.3 Rd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 1, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "fishFood_2"), location: Location(latitude: 49.166592, longtitude: -123.133568, street: "No.3 Rd", city: "Richmond", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 2, hour: 3, minute: 12, second: 23))
    }
    
    func createCherryFruiteData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "cherry_1"), location: Location(latitude: 49.8880, longtitude: -119.496, street: "697 Bernard Ave", city: "Kelowna", province: "BC"), date: Image.setImageDate(year: 2011, month: 8, day: 1, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "cherry_2"), location: Location(latitude: 49.8880, longtitude: -119.496, street: "697 Bernard Ave", city: "Kelowna", province: "BC"), date: Image.setImageDate(year: 2013, month: 4, day: 1, hour: 3, minute: 12, second: 24))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "cherry_3"), location: Location(latitude: 49.8880, longtitude: -119.496, street: "697 Bernard Ave", city: "Kelowna", province: "BC"), date: Image.setImageDate(year: 2012, month: 12, day: 1, hour: 3, minute: 12, second: 24))
    }
    
    func createLemonsFruiteData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "lemon_1"), location: Location(latitude: 49.8880, longtitude: -119.496, street: "697 Bernard Ave", city: "Kelowna", province: "BC"), date: Image.setImageDate(year: 2017, month: 2, day: 1, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "lemon_2"), location: Location(latitude: 49.8880, longtitude: -119.496, street: "697 Bernard Ave", city: "Kelowna", province: "BC"), date: Image.setImageDate(year: 2016, month: 2, day: 1, hour: 3, minute: 12, second: 24))
    }
    
    func createOrangesFruiteData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "orange_1"), location: Location(latitude: 49.8880, longtitude: -119.496, street: "697 Bernard Ave", city: "Kelowna", province: "BC"), date: Image.setImageDate(year: 2015, month: 5, day: 21, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "orange_2"), location: Location(latitude: 49.8880, longtitude: -119.496, street: "697 Bernard Ave", city: "Kelowna", province: "BC"), date: Image.setImageDate(year: 2015, month: 5, day: 13, hour: 3, minute: 12, second: 24))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "orange_3"), location: Location(latitude: 49.8880, longtitude: -119.496, street: "697 Bernard Ave", city: "Kelowna", province: "BC"), date: Image.setImageDate(year: 2015, month: 5, day: 12, hour: 3, minute: 12, second: 25))

    }
    
    func createPeachsFruiteData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "peach_1"), location: Location(latitude: 49.8880, longtitude: -119.496, street: "697 Bernard Ave", city: "Kelowna", province: "BC"), date: Image.setImageDate(year: 2017, month: 2, day: 1, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "peach_2"), location: Location(latitude: 49.8880, longtitude: -119.496, street: "697 Bernard Ave", city: "Kelowna", province: "BC"), date: Image.setImageDate(year: 2017, month: 2, day: 1, hour: 3, minute: 12, second: 24))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "peach_3"), location: Location(latitude: 49.8880, longtitude: -119.496, street: "697 Bernard Ave", city: "Kelowna", province: "BC"), date: Image.setImageDate(year: 2017, month: 3, day: 1, hour: 3, minute: 12, second: 25))
    }
    
    func createApplesFruiteData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "apple_1"), location: Location(latitude: 49.8880, longtitude: -119.496, street: "697 Bernard Ave", city: "Kelowna", province: "BC"), date: Image.setImageDate(year: 2017, month: 1, day: 1, hour: 3, minute: 12, second: 23))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "apple_2"), location: Location(latitude: 49.8880, longtitude: -119.496, street: "697 Bernard Ave", city: "Kelowna", province: "BC"), date: Image.setImageDate(year: 2017, month: 1, day: 1, hour: 3, minute: 12, second: 24))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "apple_3"), location: Location(latitude: 49.8880, longtitude: -119.496, street: "697 Bernard Ave", city: "Kelowna", province: "BC"), date: Image.setImageDate(year: 2017, month: 1, day: 1, hour: 3, minute: 12, second: 25))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "apple_4"), location: Location(latitude: 49.8880, longtitude: -119.496, street: "697 Bernard Ave", city: "Kelowna", province: "BC"), date: Image.setImageDate(year: 2017, month: 1, day: 1, hour: 3, minute: 12, second: 27))
    }
    
    func createRockeyMountainData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "rockyMountain1"), location: Location(latitude: 44.2643, longtitude: -109.7870, street: "491 Arrow Rd", city: "Invermere", province: "BC"), date: Image.setImageDate(year: 2017, month: 7, day: 1, hour: 3, minute: 12, second: 27))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "rockyMountain2"), location: Location(latitude: 44.2643, longtitude: -109.7870, street: "491 Arrow Rd", city: "Invermere", province: "BC"), date: Image.setImageDate(year: 2007, month: 1, day: 31, hour: 5, minute: 12, second: 27))
    }
    
    func createGrouseMountainData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "grouseMountain1"), location: Location(latitude: 49.3723, longtitude: -123.0995, street: "6400 Nancy Greene Way", city: "North Vancouver", province: "BC"), date: Image.setImageDate(year: 2010, month: 11, day: 1, hour: 3, minute: 12, second: 27))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "grouseMountain2"), location: Location(latitude: 49.3723, longtitude: -123.0995, street: "6400 Nancy Greene Way", city: "North Vancouver", province: "BC"), date: Image.setImageDate(year: 2017, month: 10, day: 12, hour: 10, minute: 12, second: 27))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "grouseMountain3"), location: Location(latitude: 49.3723, longtitude: -123.0995, street: "6400 Nancy Greene Way", city: "North Vancouver", province: "BC"), date: Image.setImageDate(year: 2013, month: 6, day: 19, hour: 3, minute: 12, second: 27))
    }
    
    func createOlympicData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "olympicsVancouver1"), location: Location(latitude: 49.2768, longtitude: -123.1120, street: "777 Pacific Blvd", city: "Vancouver", province: "BC"), date: Image.setImageDate(year: 2011, month: 12, day: 11, hour: 3, minute: 12, second: 27))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "olympicsVancouver2"), location: Location(latitude: 49.2768, longtitude: -123.1120, street: "777 Pacific Blvd", city: "Vancouver", province: "BC"), date: Image.setImageDate(year: 2017, month: 11, day: 12, hour: 3, minute: 59, second: 27))
    }
    
    func createDefaultData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "testing"), location: Location(), date: Image.setImageDate(year: 1999, month: 12, day: 31, hour: 11, minute: 59, second: 59))
    }
    
    func decrementImageCount(){
        try! self.realm?.write {
            self.imageCount = imageCount - 1
        }
    }
    
    func incrementImageCount(){
        try! self.realm?.write {
            self.imageCount = imageCount + 1
        }
    }
    
    public func setName(_ name: String){
        self.name = name
    }
    
    public func setCreatedDate(_ createdDate: Date){
        self.createdDate = createdDate
    }
    public func setImages(_ images: List<Image>){
        self.images = images
    }
    
    public func getImageCount() -> Int{
        return self.imageCount
    }
    public func getFolderID() -> String{
        return self.folderID
    }
    
    public func getName() -> String{
        return self.name
    }
    
    public func getCreatedDate() -> Date{
        return self.createdDate
    }
    
    public func getImages() -> List<Image>{
        return self.images
    }
    
    public func setNumOfImageSelection(number: Int){
        self.numOfImageSelection = number
    }
    
    public func getNumOfImageSelection()->Int{
        return self.numOfImageSelection
    }
    
    public func setDidAddAlready(didAddAlready: Bool){
        self.didAddAlready = didAddAlready
    }
    
    public func getDidAddAlready()->Bool{
        return self.didAddAlready
    }
    
    public func setNewImage(newImage: UIImage){
        self.newImage = newImage
    }
    
    public func getNewImage() -> UIImage{
        return self.newImage
    }
    
    public func getImageArray()->[Image]{
        return self.imageArray
    }
    
    public func getCategoryName()-> String{
        return self.categoryName
    }
    
    func getASCSort()-> Bool{
        return self.ascSort
    }
    
    public func setImageArray(imageArray: [Image]){
        self.imageArray = imageArray
    }
    
    public func addElementToImageArray(image: Image){
        self.imageArray.append(image)
    }
    
    public func clearImageArray(){
        self.imageArray = [Image]()
    }
    
    public func addElementToMovedImageArray(image: Image){
        self.movedImagesSelection.append(image)
    }
    
    public func clearMovedImageArray(){
        self.movedImagesSelection = [Image]()
    }
    
    public func getMovedImageArray()->[Image]{
        return self.movedImagesSelection
    }
    
    private func getDateString(date: Date) -> String{
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy MMM dd"
        let mydt = dateFormatter1.string(from: date)
        
        return mydt
    }
    
    func getDateAndImageDictionary()->[String: [Image]]{
        print("print...")
        var dict: [String: [Image]] = [:]
        
        var newImageCreatedDateString: Set<String> = Set<String>()
        for i in self.getImageArray(){
            newImageCreatedDateString.insert(self.getDateString(date: i.getDateCreated()))
        }
        
        
        for i in newImageCreatedDateString{
            var newImageArray = [Image]()
            for j in self.imageArray{
                
                if i == self.getDateString(date:  j.getDateCreated()){
                    newImageArray.append(j)
                }
            }
            dict[i] = newImageArray
        }
        
        print(dict)
        print("finished print...")
        
        return dict
        
    }
    
    func getImageArraySoryByDate()->[[Image]]{
        let dict: [String: [Image]] = self.getDateAndImageDictionary()
        var imageArray: [[Image]] = [[Image]]()
        
        for i in dict{
            imageArray.append(i.value)
        }
        
        print(imageArray)
        return imageArray
        
    }

    func addImageToRealm(newImage: UIImage, location: Location, date: Date){
        let filenamePath = self.writeImageToDirectoryAndGetFilePath(image: newImage)
        
        let hashTags = List<HashTag>()
        
        let hashTag1 = HashTag(hashTag: "#"+self.getName())
        let hashTag2 = HashTag(hashTag: "#"+self.categoryName)
        
        if self.categoryName == "Default"{
            hashTags.append(hashTag1)
        }else{
            hashTags.append(hashTag1)
            hashTags.append(hashTag2)
        }
        let newLocation = Location(latitude: location.getLatitude(), longtitude: location.getLongtitude(), street: location.getStreet(), city: location.getCity(), province: location.getProvince())
        
        let newRealmFormattedImageData = Image(categoryName: self.categoryName, subCategoryName: self.name, dateCreated: date, imagePath: filenamePath as NSString, hashTags: hashTags, location: newLocation)
        
        try! realm?.write {
            images.append(newRealmFormattedImageData)
        }
        
        incrementImageCount()
        
        self.addElementToImageArray(image: newRealmFormattedImageData)
    }
    
    func addImageToRealm(newImage: Image){
        
        let hashTags = List<HashTag>()
        
        let hashTag1 = HashTag(hashTag: "#"+self.getName())
        let hashTag2 = HashTag(hashTag: "#"+self.categoryName)
        
        if self.categoryName == "Default"{
            hashTags.append(hashTag1)
        }else{
            hashTags.append(hashTag1)
            hashTags.append(hashTag2)
        }
        let newLocation = Location(latitude: newImage.getLocation().getLatitude(), longtitude: newImage.getLocation().getLongtitude(), street: newImage.getLocation().getStreet(), city: newImage.getLocation().getCity(), province: newImage.getLocation().getProvince())
        
        let image = Image(categoryName: self.categoryName, subCategoryName: self.getName(), dateCreated: newImage.getDateCreated(), imagePath: newImage.getImagePath(), hashTags: hashTags, location: newLocation)
        try! realm?.write {
            images.append(image)
        }
        
        incrementImageCount()
        
    }
    
    func addOneOrMultipleHashtagToImages(indexpaths: [IndexPath], newHashtagName: String){
        for item  in indexpaths {

            let image = self.getImageArray()[item.row]
            //let image = self.getImageArraySoryByDate()[item.section][item.item]
            
            image.addOneHashtagToRealm(newHashtagName: newHashtagName)

        }

    }
    
    func deleteImageFromFileDirectory(deletedImages: List<Image>){
        
        let fileManager = FileManager.default
        for i in deletedImages{
            let imagePathString = i.getImagePath() as String
            do{
                try fileManager.removeItem(atPath: imagePathString)
                
            }catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        }
        
    }
    
    func deleteImageFromFileDirectory(deletedImages: [Image]){
        
        let fileManager = FileManager.default
        for i in deletedImages{
            let imagePathString = i.getImagePath() as String
            do{
                try fileManager.removeItem(atPath: imagePathString)
                
            }catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        }
        
    }
    
    
    func deletImages(indexpaths: [IndexPath]){
        var deletedImages:[Image] = []
        
        for item  in indexpaths {
            
            
            //let selectedImage = self.getImageArraySoryByDate()[item.section][item.item]
            
            let selectedImage = self.getImageArray()[item.row]
            deletedImages.append(selectedImage)
            decrementImageCount()
        }

        self.deleteImageFromFileDirectory(deletedImages: deletedImages)
        
        
        
        
        guard let database = try? Realm() else { return }
        do {
            try database.write {
                database.delete(deletedImages, cascading: true)
            }
        } catch {
            // handle write error here
        }
        

        let tempFolderType = RealmService.shared.realm.objects(Type.self).filter("name = %@", self.categoryName )
        

        let tempFolders = tempFolderType[0].getFolders().filter("name = %@", self.getName() )
        
        self.clearImageArray()
        for i in tempFolders[0].getImages(){
            self.addElementToImageArray(image: i)
        }
//        self.getImageArraySoryByDate()
    }
    
    
    
    func deletImagesWithoutDeletingDirectoryImages(deletedImages: [Image]){
        for _ in deletedImages{
   
            decrementImageCount()
        }

        guard let database = try? Realm() else { return }
        do {
            try database.write {
                database.delete(deletedImages, cascading: true)
            }
        } catch {
            // handle write error here
        }
        
        
        let tempFolderType = RealmService.shared.realm.objects(Type.self).filter("name = %@", self.categoryName )
        
        
        let tempFolders = tempFolderType[0].getFolders().filter("name = %@", self.getName() )
        
        self.clearImageArray()
        for i in tempFolders[0].getImages(){
            self.addElementToImageArray(image: i)
        }
        //        self.getImageArraySoryByDate()
    }
    
    
    
    
    
    private func writeImageToDirectoryAndGetFilePath(image: UIImage)->String{
        let data = NSData(data: UIImageJPEGRepresentation(image, 0.9)!)
        let randomNum = Int(arc4random_uniform(99999) + 1)
        
        let timestampFilename = String(Int(Date().timeIntervalSince1970)) + "\(randomNum).png"
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        
        let fullFilePath = (documentsDirectory as NSString)

//        print(fullFilePath)
        let fullFilePathArr = fullFilePath.components(separatedBy: "/")
        var formattedFullFilePath: String = ""

//        print("full")
        for i in fullFilePathArr{
//            print(i)
//            if i != fullFilePathArr[0]{
            if i == fullFilePathArr[0]{
                formattedFullFilePath = formattedFullFilePath + "\(i)"
            }else{
                formattedFullFilePath = formattedFullFilePath + "/\(i)"
            }
//            }
            if i == "Application"{
                break
            }
        }
        
//        print(formattedFullFilePath)
        
        let filenamePath = (fullFilePath as NSString).appendingPathComponent(timestampFilename)

        //write failed... even you created a file path...
        let fileManager = FileManager.default
        fileManager.createFile(atPath: filenamePath, contents: data as Data, attributes: nil)
        
        return filenamePath
    }
    
    public func getFolderDataFromRealm(){
        let images = RealmService.shared.realm.objects(Image.self)
        
        for i in images{
            self.addElementToImageArray(image: i)
        }
    }
    
    func filterImage(sortByHashtag: String){
        
        let images = self.imageArray
        self.clearImageArray()
        
        var found = false
        
        let searchText = sortByHashtag
        
        let myStrippedString = searchText.components(separatedBy: CharacterSet.alphanumerics.inverted).joined(separator: " ")
        
        let ok = myStrippedString.lowercased().split(whereSeparator: { $0 == " " })
        
        print("search text")
        print(searchText)
        
        if !searchText.isEmpty && searchText != "" {
            for i in images{
                for j in i.getHashTags(){
                    
                    for word in ok{
                        
                        if j.getHashTag().lowercased().contains(word.lowercased()){
                            found = true
                            break
                        }
                        
                    }
                    
                }
                if(found){
                    self.addElementToImageArray(image: i)
                    found = false
                }
            }
            
        }else{
            self.clearImageArray()
            
        }
    }
    
    func filterImage(sortByLocation: String){
        
        let images = self.imageArray
        self.clearImageArray()
        
        var found = false
        
        let searchText = sortByLocation
        
        
        let formattedWord = searchText.lowercased().split(whereSeparator: { $0 == "@" })
        
        if !searchText.isEmpty && searchText != "" {
            for i in images{
                let newImageLocationFormatted = i.getLocation().getCity() + ", " + i.getLocation().getProvince() + " "
                for word in formattedWord{
                    if newImageLocationFormatted.lowercased() == word.lowercased(){
                        found = true
                        break
                    }
                }
                if(found){
                    self.addElementToImageArray(image: i)
                    found = false
                }
            }
            
        }else{
            self.clearImageArray()
            
        }
    }
    
    
    func filterImage2(sortByCordination: String){
        
        let images = self.imageArray
        self.clearImageArray()
 
        let searchText = sortByCordination
        
        
            for i in images{
                
                let newX = String(format: "%.3f", i.getLocation().getLatitude())
                let newY = String(format: "%.3f", i.getLocation().getLongtitude())
                let newImageLocationFormatted = "@latitude: \(newX), longitude: \(newY)"
                
                print(newImageLocationFormatted)
                print(searchText)
                    if newImageLocationFormatted.lowercased() == searchText.lowercased(){
                        self.addElementToImageArray(image: i)

                    }

            }
        
        
    }
    
    func filterImage(sortByDate: String){
        
        let images = self.imageArray
        self.clearImageArray()
        
        var found = false
        
        let searchText = sortByDate
        
        
        let formattedWord = searchText.lowercased().split(whereSeparator: { $0 == "&" })
        
        print("first")
        print(formattedWord)
        
        if !searchText.isEmpty && searchText != "" {
            for i in images{
                let newImageDateCreatedFormatted = i.getImageCreatedDateString() + "  "
                for word in formattedWord{
                    if newImageDateCreatedFormatted.lowercased() == word.lowercased(){
                        found = true
                        break
                    }
                }
                if(found){
                    self.addElementToImageArray(image: i)
                    found = false
                }
            }
            
        }else{
            self.clearImageArray()
            
        }
    }
    
    
    
    
    func sortByDateCreated(){
        self.ascSort = !self.ascSort
        if self.ascSort{
            self.imageArray = self.imageArray.sorted(by: { $0.getDateCreated() > $1.getDateCreated() })
        }else{
            self.imageArray = self.imageArray.sorted(by: { $0.getDateCreated() < $1.getDateCreated() })
        }
        
    }
    
}
