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
    
    func testFoo2() {
        AB().foo()
    }
    
}
