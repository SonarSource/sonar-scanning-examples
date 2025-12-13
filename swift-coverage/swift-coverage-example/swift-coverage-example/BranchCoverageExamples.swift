//
//  BranchCoverageExamples.swift
//  swift-coverage-example
//
//  Examples demonstrating branch coverage scenarios that xccov captures
//  but the conversion script may not properly handle.
//

import Foundation

/// This class contains examples of code with multiple branches per line
/// that xccov tracks but the conversion script doesn't account for.
class BranchCoverageExamples {
    
    // MARK: - Nil Coalescing Operator (??)
    
    /// Nil coalescing creates 2 branches:
    /// - Branch 1: value exists → use it
    /// - Branch 2: value is nil → use fallback
    func nilCoalescingExample(optionalValue: String?) -> String {
        return optionalValue ?? "default"  // 2 branches on this line
    }
    
    /// Multiple nil coalescing on same line = more branches
    func multipleNilCoalescing(a: Int?, b: Int?) -> Int {
        return a ?? b ?? 0  // 3+ branches on this line
    }
    
    // MARK: - Ternary Operator (? :)
    
    /// Ternary operator creates 2 branches:
    /// - Branch 1: condition is true
    /// - Branch 2: condition is false
    func ternaryExample(flag: Bool) -> String {
        return flag ? "yes" : "no"  // 2 branches on this line
    }
    
    /// Nested ternary = more branches
    func nestedTernary(a: Bool, b: Bool) -> String {
        return a ? (b ? "both" : "onlyA") : "neither"  // 4 branches on this line
    }
    
    // MARK: - Optional Chaining
    
    /// Optional chaining creates branches for each `?`
    func optionalChainingExample(text: String?) -> Int {
        return text?.count ?? 0  // 2+ branches: text exists or nil, then coalescing
    }
    
    // MARK: - Short-circuit Evaluation
    
    /// Logical AND (&&) creates branches
    func shortCircuitAnd(a: Bool, b: Bool) -> Bool {
        return a && b  // If a is false, b is never evaluated
    }
    
    /// Logical OR (||) creates branches
    func shortCircuitOr(a: Bool, b: Bool) -> Bool {
        return a || b  // If a is true, b is never evaluated
    }
    
    // MARK: - Combined Example
    
    /// This function has multiple branches on a single line
    /// xccov will show branch info like: `42: 5 [(1, 10, 2)(50, 0, 3)]`
    func complexBranchExample(optionalBool: Bool?, threshold: Int?) -> String {
        let flag = optionalBool ?? false  // 2 branches
        let limit = threshold ?? 10       // 2 branches
        return flag && limit > 5 ? "active" : "inactive"  // 3+ branches
    }
    
    // MARK: - Guard with Optional Binding
    
    /// Guard statements with optional binding create branches
    func guardExample(value: String?) -> String {
        guard let unwrapped = value else {  // 2 branches
            return "no value"
        }
        return "value: \(unwrapped)"
    }
    
    // MARK: - If-let with Nil Coalescing
    
    /// Combining if-let with other operators
    func ifLetWithCoalescing(primary: String?, fallback: String?) -> String {
        if let result = primary ?? fallback {  // Multiple branches
            return result
        }
        return "none"
    }
    
    // MARK: - Closure with Branches
    
    /// Even closures on a single line can have branches
    func closureWithBranches(numbers: [Int]) -> [Int] {
        return numbers.map { $0 > 0 ? $0 * 2 : 0 }  // Branch per element evaluation
    }
}

