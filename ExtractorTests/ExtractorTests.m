//
//  ExtractorTests.m
//  ExtractorTests
//
//  Created by Neil Daniels on 4/18/15.
//  Copyright (c) 2015 Ebates Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

#import <Extractor/Extractor.h>

@interface ExtractorTests : XCTestCase

@end

@implementation ExtractorTests

- (void)testKeyedExtractorUse
{
    NSDictionary *sampleDictionary = @{
                                       @"valueA" : @"135",
                                       @"valueB" : [NSDecimalNumber decimalNumberWithMantissa:458 exponent:-2 isNegative:YES],
                                       @"valueC" : @[ @"2.3", @"4.8", @"6.4" ]
                                       };
    EBTExtractor *extractor = [EBTExtractor extractorWithDictionary:sampleDictionary];
    
    XCTAssertEqualObjects([extractor numberForKey:@"valueA"], @135);
    XCTAssertEqualObjects([extractor stringForKey:@"valueB"], @"-4.58");
    
    NSArray *valueCNumberArrayTruth = @[ @2, @4, @6 ];
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"valueC"] isEqualToArray:valueCNumberArrayTruth]);
}

- (void)testDirectObjectUseFromNumber
{
    NSNumber *object = @45;
    
    XCTAssertEqual([EBTExtractor boolFromObject:object], YES);
    XCTAssertEqual([EBTExtractor integerFromObject:object], 45);
    XCTAssertEqualObjects([EBTExtractor numberFromObject:object], [NSNumber numberWithInteger:45]);
    XCTAssertEqualObjects([EBTExtractor stringFromObject:object], @"45");
}

@end
