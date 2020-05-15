//
//  DogSitterAppUITests.swift
//  DogSitterAppUITests
//
//  Created by Raymond Yu on 5/3/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import XCTest

class DogSitterAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testHelloWorld() throws {
//        // given
//        let app = XCUIApplication()
//        app.launch()
//        let testString = "Hello, World!"
//
//        // when
//        let textView = app.staticTexts.element(boundBy: 0)
//
//        // then
//        XCTAssertEqual(textView.label, testString)
//    }

    func testLoginButtonLinkstoCameraControlView() {
        // given
        let app = XCUIApplication()
        app.launch()
        
        // when
        app.buttons["Login"].tap()
        let appNavBarTitle = app.navigationBars.element.staticTexts.firstMatch.label
        
        // then
        XCTAssertEqual(appNavBarTitle, "Camera Control")
        
//        XCUIApplication().navigationBars.buttons["Back"].tap()
    }
    
    func testViewCameraButtonDisplaysLiveVideo() {
        // given
        let app = XCUIApplication()
        app.launch()
        
        // when
        app.buttons["Login"].tap()
        app.buttons["View Camera"].tap()
        
        
        
//        let app = XCUIApplication()
        app.buttons["View Camera"].tap()
        
        
        let app = XCUIApplication()
        app.buttons["View Camera"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.tap()
        element.tap()
        element.tap()
        element.tap()
        element.tap()
        element.tap()
        element.tap()
        element.swipeRight()
        element.swipeLeft()
        
        
        
        
        let liveVideoNavigationBar = app.navigationBars["Live Video"]
        liveVideoNavigationBar.staticTexts["Live Video"].tap()
        liveVideoNavigationBar.buttons["Camera Control"].tap()
        
        
        // then
//        XCTAssert
    }
    
    
    
    
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
