//
//  DemoDataService.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-11.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation

class DemoDataService{
    
    
    public static func dummyData(){
        let type: TypeList = TypeList()
        type.createTypeData()
        
        for i in type.getFolderTypes(){
//            if i.getName() == "Sports"{
//                i.createSportFolders()
//                for j in i.getFolders(){
//                    if j.getName() == "Olympics"{
//                        j.createOlympicData()
//                    }
//                }
//            }
//            if i.getName() == "Mountains"{
//                i.createMountainFolders()
//                for j in i.getFolders(){
//                    if j.getName() == "Rocky"{
//                        j.createRockeyMountainData()
//                    }
//                    if j.getName() == "Grouse"{
//                        j.createGrouseMountainData()
//                    }
//                }
//            }
//
//            if i.getName() == "Buildings"{
//                i.createBuildingsFolders()
//                for j in i.getFolders(){
//                    if j.getName() == "Chinese"{
//                        j.createChineseBuildingsData()
//                    }
//                    if j.getName() == "Japanese"{
//                        j.createJapenseBuildingsData()
//                    }
//                    if j.getName() == "Castles"{
//                        j.createCastleBuildingsData()
//                    }
//                    if j.getName() == "Schools"{
//                        j.createSchoolBuildingsData()
//                    }
//
//                }
//            }
//
//            if i.getName() == "Fruits"{
//                i.createFruitFolders()
//                for j in i.getFolders(){
//                    if j.getName() == "Apples"{
//                        j.createApplesFruiteData()
//                    }
//                    if j.getName() == "Mandarines"{
//                        j.createOrangesFruiteData()
//                    }
//                    if j.getName() == "Lemons"{
//                        j.createLemonsFruiteData()
//                    }
//                    if j.getName() == "Peaches"{
//                        j.createPeachsFruiteData()
//                    }
//                    if j.getName() == "Cherries"{
//                        j.createCherryFruiteData()
//                    }
//
//                }
//            }
//
//
//            if i.getName() == "Animals"{
//                i.createAnimalsFolders()
//                for j in i.getFolders(){
//                    if j.getName() == "Dogs"{
//                        j.createDogAnimalsData()
//                    }
//                    if j.getName() == "Cats"{
//                        j.createCatAnimalsData()
//                    }
//                    if j.getName() == "Lions"{
//                        j.createLionAnimalsData()
//                    }
//                    if j.getName() == "Birds"{
//                        j.createBirdAnimalsData()
//                    }
//                    if j.getName() == "Fish"{
//                        j.createFishAnimalsData()
//                    }
//
//                }
//            }
//
//
//            if i.getName() == "Science"{
//                i.createScienceFolders()
//                for j in i.getFolders(){
//                    if j.getName() == "Physics"{
//                        j.createPhysicsScienceData()
//                    }
//                    if j.getName() == "Chemistry"{
//                        j.createChemistryScienceData()
//                    }
//                    if j.getName() == "Biology"{
//                        j.createBiologyScienceData()
//                    }
//
//                }
//            }
//
//            if i.getName() == "Food"{
//                i.createFoodFolders()
//                for j in i.getFolders(){
//                    if j.getName() == "Fish"{
//                        j.createFishFoodData()
//                    }
//                    if j.getName() == "Milk"{
//                        j.createMilkFoodData()
//                    }
//                    if j.getName() == "Yogurt"{
//                        j.createYogurtFoodData()
//                    }
//                    if j.getName() == "Cheese"{
//                        j.createCheeseFoodData()
//                    }
//                    if j.getName() == "Cereal"{
//                        j.createCerealFoodData()
//                    }
//                    if j.getName() == "Eggs"{
//                        j.createEggFoodData()
//                    }
//                    if j.getName() == "Cakes"{
//                        j.createCakeFoodData()
//                    }
//                    if j.getName() == "Candy"{
//                        j.createCandyFoodData()
//                    }
//
//                }
//            }
//
//
//            if i.getName() == "Movies"{
//                i.createMovieFolders()
//                for j in i.getFolders(){
//                    if j.getName() == "Action"{
//                        j.createActionMoviesData()
//                    }
//                    if j.getName() == "Comedy"{
//                        j.createComedyMoviesData()
//                    }
//                    if j.getName() == "Historical"{
//                        j.createHistoricalMoviesData()
//                    }
//                    if j.getName() == "Adventure"{
//                        j.createAdventureMoviesData()
//                    }
//                    if j.getName() == "Crime"{
//                        j.createCrimeMoviesData()
//                    }
//                    if j.getName() == "Drama"{
//                        j.createDramaMoviesData()
//                    }
//                    if j.getName() == "Fantasy"{
//                        j.createFantasyMoviesData()
//                    }
//                    if j.getName() == "Horror"{
//                        j.createHorrorMoviesData()
//                    }
//                    if j.getName() == "Mystery"{
//                        j.createMysteryMoviesData()
//                    }
//                    if j.getName() == "Romance"{
//                        j.createRomanceMoviesData()
//                    }
//
//                }
//            }
//
//
//            if i.getName() == "Planets"{
//                i.createPlanetsFolders()
//                for j in i.getFolders(){
//                    if j.getName() == "Saturn"{
//                        j.createSaturnPlanetsData()
//                    }
//                    if j.getName() == "Earth"{
//                        j.createEarthPlanetsData()
//                    }
//                    if j.getName() == "Jupiter"{
//                        j.createJupiterPlanetsData()
//                    }
//                    if j.getName() == "Mercury"{
//                        j.createMercuryPlanetsData()
//                    }
//                    if j.getName() == "Uranus"{
//                        j.createUranusPlanetsData()
//                    }
//                    if j.getName() == "Mars"{
//                        j.createMarsPlanetsData()
//                    }
//                    if j.getName() == "Venus"{
//                        j.createVenusPlanetsData()
//                    }
//                    if j.getName() == "Neptune"{
//                        j.createNeptunePlanetsData()
//                    }
//
//                }
//            }

            
            if i.getName() == "Default"{
                i.createDefaultFolder()
                for j in i.getFolders(){
                    if j.getName() == "Default"{
//                        j.createDefaultData()
                    }
                }
            }
        }
    }
    
    
}
