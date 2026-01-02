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
    
    // MARK: - Branch Coverage Tests
    // These tests demonstrate scenarios where xccov captures branch info
    // that the conversion script currently ignores.
    
    let examples = BranchCoverageExamples()
    
    // MARK: - Nil Coalescing Tests
    
    func testNilCoalescing_WithValue() {
        // This only tests ONE branch (value exists)
        // The nil branch is NOT covered
        let result = examples.nilCoalescingExample(optionalValue: "hello")
        XCTAssertEqual(result, "hello")
    }
    
    // Uncomment to cover the other branch:
    // func testNilCoalescing_WithNil() {
    //     let result = examples.nilCoalescingExample(optionalValue: nil)
    //     XCTAssertEqual(result, "default")
    // }
    
    func testMultipleNilCoalescing_FirstValue() {
        // Only covers the first branch (a has value)
        // Other branches (a nil, b has value) and (both nil) are NOT covered
        let result = examples.multipleNilCoalescing(a: 42, b: 10)
        XCTAssertEqual(result, 42)
    }
    
    // MARK: - Ternary Operator Tests
    
    func testTernary_TrueOnly() {
        // Only covers the TRUE branch
        // The FALSE branch is NOT covered
        let result = examples.ternaryExample(flag: true)
        XCTAssertEqual(result, "yes")
    }
    
    func testNestedTernary_PartialCoverage() {
        // Only covers 2 of 4 possible branches
        _ = examples.nestedTernary(a: true, b: true)   // covers "both"
        _ = examples.nestedTernary(a: false, b: true)  // covers "neither"
        // Missing: (true, false) -> "onlyA"
    }
    
    // MARK: - Optional Chaining Tests
    
    func testOptionalChaining_WithValue() {
        // Only covers branch where text exists
        let result = examples.optionalChainingExample(text: "hello")
        XCTAssertEqual(result, 5)
    }
    
    // MARK: - Short-circuit Tests
    
    func testShortCircuitAnd_PartialCoverage() {
        // When a=true, b is evaluated
        // When a=false, b is NOT evaluated (short-circuit)
        _ = examples.shortCircuitAnd(a: true, b: true)
        // Missing: testing when a=false (short-circuit branch)
    }
    
    func testShortCircuitOr_PartialCoverage() {
        // When a=false, b is evaluated
        // When a=true, b is NOT evaluated (short-circuit)
        _ = examples.shortCircuitOr(a: false, b: true)
        // Missing: testing when a=true (short-circuit branch)
    }
    
    // MARK: - Complex Example Tests
    
    func testComplexBranch_PartialCoverage() {
        // This covers some branches but not all combinations
        _ = examples.complexBranchExample(optionalBool: true, threshold: 10)
        _ = examples.complexBranchExample(optionalBool: nil, threshold: nil)
        // Many branch combinations are still uncovered
    }
    
    // MARK: - Guard Tests
    
    func testGuard_WithValue() {
        // Only covers the happy path (value exists)
        // The early return branch is NOT covered
        let result = examples.guardExample(value: "test")
        XCTAssertEqual(result, "value: test")
    }
    
    // MARK: - If-let with Coalescing Tests
    
    func testIfLetCoalescing_Primary() {
        // Only covers branch where primary has value
        let result = examples.ifLetWithCoalescing(primary: "primary", fallback: nil)
        XCTAssertEqual(result, "primary")
    }
    
    // MARK: - Closure Tests
    
    func testClosureWithBranches_PositiveOnly() {
        // Only covers the positive number branch
        let result = examples.closureWithBranches(numbers: [1, 2, 3])
        XCTAssertEqual(result, [2, 4, 6])
        // Missing: testing with negative/zero numbers
    }
}
