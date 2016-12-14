#import <XCTest/XCTest.h>

#import "Example.h"

@interface ExampleTests : XCTestCase

@end

@implementation ExampleTests

- (void)test_abs {
    XCTAssert(abs(-1) == 1);
}

@end
