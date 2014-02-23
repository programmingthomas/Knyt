// Knyt_Tests.m
//
// Copyright 2014 Programming Thomas
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import <XCTest/XCTest.h>
#import "KNTArgumentParser.h"
#import "KNTFourSpacesRule.h"

@interface Knyt_Tests : XCTestCase

@end

@implementation Knyt_Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testArgumentParser {
    const char * testArguments[] = {
        "-argument1",
        "option1",
        "option2",
        "-argument2",
        "option3"
    };
    NSArray * arguments = [KNTArgumentParser parseArgumentsWithCount:5 values:testArguments];
    XCTAssert(arguments.count == 2, @"Got %d arguments, expected 2", (int)arguments.count);
    
    KNTArgument * argument1 = arguments[0];
    
    XCTAssert([argument1.argument isEqualToString:@"argument1"], @"Argument name is %@, not argument1", argument1.argument);
    XCTAssert(argument1.options.count == 2, @"Found %d options, not 2", (int)argument1.options.count);
    
    NSString * option1 = argument1.options[0], * option2 = argument1.options[1];
    XCTAssert([option1 isEqualToString:@"option1"], @"option1 != %@", option1);
    XCTAssert([option2 isEqualToString:@"option2"], @"option2 != %@", option2);
    
    KNTArgument * argument2 = arguments[1];
    
    XCTAssert([argument2.argument isEqualToString:@"argument2"], @"argument2 != %@", argument2.argument);
    XCTAssert(argument2.options.count == 1, @"Got %d options, not 1", (int)argument2.options.count);
    
    NSString * option3 = argument2.options[0];
    XCTAssert([option3 isEqualToString:@"option3"], @"option3 != %@", option3);
}

- (void)testFourSpaces {
    XCTAssert([KNTFourSpacesRule openingSpaces:@"    s"] == 4, @"%d != 4", (int)[KNTFourSpacesRule openingSpaces:@"    s"]);
    XCTAssert([KNTFourSpacesRule openingSpaces:@"   s"] == 3, @"%d != 3", (int)[KNTFourSpacesRule openingSpaces:@"   s"]);
    XCTAssert([KNTFourSpacesRule openingSpaces:@"  s"] == 2, @"%d != 2", (int)[KNTFourSpacesRule openingSpaces:@"  s"]);
    XCTAssert([KNTFourSpacesRule openingSpaces:@"    s "] == 4, @"%d != 4", (int)[KNTFourSpacesRule openingSpaces:@"    s "]);
}

@end
