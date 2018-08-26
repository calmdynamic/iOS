//
//  PhotoManagerUITests.swift
//  PhotoManagerUITests
//
//  Created by Jason Chih-Yuan on 2018-08-18.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import XCTest

class PhotoManagerUITests: XCTestCase {
        
    override func setUp() {
        
        XCUIApplication().terminate()
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
         XCUIApplication().terminate()
    }
    
    func testCreateDeleteFolderType() {
        
        
        let app = XCUIApplication()
        app.otherElements.containing(.button, identifier:"GIDSignInButton").children(matching: .button).matching(identifier: "Button").element(boundBy: 1).tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 0).buttons["Button"].tap()
        app.navigationBars["Types"].buttons["Edit"].tap()
        
        let toolbar = app.toolbars["Toolbar"]
        toolbar.buttons["Add"].tap()
        
        let addNameAlert = app.alerts["Add name?"]
        let enterFolderTypeNameTextField = addNameAlert.collectionViews.textFields["Enter Folder Type Name"]
        enterFolderTypeNameTextField.tap()

        
        let aKey = app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        aKey.tap()
      
        addNameAlert.buttons["Add"]/*@START_MENU_TOKEN@*/.press(forDuration: 0.6);/*[[".tap()",".press(forDuration: 0.6);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        let collectionView = element.children(matching: .collectionView).element
        collectionView.swipeUp()
collectionView.swipeUp()
collectionView.swipeUp()
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"a").element.tap()
        toolbar.buttons["Delete"].tap()
        app.alerts["Delete this folder type?"].buttons["Delete"].tap()
       
    }
    
    func testExample2(){
        
        let app = XCUIApplication()
        app.otherElements.containing(.button, identifier:"GIDSignInButton").children(matching: .button).matching(identifier: "Button").element(boundBy: 1).tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 0).buttons["Button"].tap()
        
        let collectionView = element.children(matching: .collectionView).element
        collectionView/*@START_MENU_TOKEN@*/.swipeRight()/*[[".swipeUp()",".swipeRight()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        collectionView.swipeUp()
        collectionView.swipeUp()
        app.navigationBars["Types"].buttons["Edit"].tap()
        
        let toolbar = app.toolbars["Toolbar"]
        toolbar.buttons["Add"].tap()
        
        let addNameAlert = app.alerts["Add name?"]
        addNameAlert.collectionViews.textFields["Enter Folder Type Name"].tap()
        
        let bKey = app/*@START_MENU_TOKEN@*/.keys["b"]/*[[".keyboards.keys[\"b\"]",".keys[\"b\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        bKey.tap()
        addNameAlert.buttons["Add"].tap()
        
        
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"b").staticTexts["Empty"].tap()
        toolbar.buttons["Delete"].tap()
        app.alerts["Delete this folder type?"].buttons["Delete"].tap()
        
    }
    
}
