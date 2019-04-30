//
//  swift_coverage_exampleTests.swift
//  swift-coverage-exampleTests
//
//  Created by Elena Vilchik on 17/08/16.
//  Copyright © 2016 SonarSource. All rights reserved.
//

import XCTest
@testable import swift_coverage_example

class swift_coverage_exampleTests: XCTestCase {
    
    func testFoo() {
        A().foo()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testFoo2() {
        AB().foo()
    }
    
}
