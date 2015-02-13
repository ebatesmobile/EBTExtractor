//
//  PPExtractorTests.m
//
//  Created by Neil Daniels
//  Copyright (c) 2015 Ebates Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "PPExtractor.h"

@interface PPExtractor_Tests : XCTestCase

@property (nonatomic, strong) PPExtractor *emptyExtractor;
@property (nonatomic, strong) PPExtractor *extractor;

@end

@implementation PPExtractor_Tests

- (void)setUp
{
    [super setUp];
    
    self.emptyExtractor = [PPExtractor extractorWithDictionary:@{}];
    
    NSLocale *locale = [NSLocale systemLocale];
    
    NSDictionary *dictionary =
    @{
      @"boolA" : @(YES),
      @"boolB" : @(NO),
      
      @"numberA" : @(0),
      @"numberB" : @(1),
      @"numberC" : @(2),
      @"numberD" : @(-1),
      @"numberE" : @(8),
      @"numberF" : @(-5),
      @"numberG" : @(5.24195),
      @"numberH" : @(7.999999),
      @"numberI" : @(-835.452),
      @"numberJ" : @(685885182),
      
      @"decimalA" : [NSDecimalNumber decimalNumberWithString:@"0.00" locale:locale],
      @"decimalB" : [NSDecimalNumber decimalNumberWithString:@"4.13" locale:locale],
      @"decimalC" : [NSDecimalNumber decimalNumberWithString:@"6.99" locale:locale],
      @"decimalD" : [NSDecimalNumber decimalNumberWithString:@"-3.01" locale:locale],
      @"decimalE" : [NSDecimalNumber decimalNumberWithString:@"18.24" locale:locale],
      @"decimalF" : [NSDecimalNumber decimalNumberWithString:@"42.504245679" locale:locale],
      @"decimalG" : [NSDecimalNumber decimalNumberWithString:@"13" locale:locale],
      @"decimalH" : [NSDecimalNumber decimalNumberWithString:@"1415210903" locale:locale],
      @"decimalI" : [NSDecimalNumber decimalNumberWithString:@"1415250000.34642456" locale:locale],
      @"decimalJ" : [NSDecimalNumber decimalNumberWithString:@"saddle" locale:locale],
      @"decimalK" : [NSDecimalNumber decimalNumberWithString:@"0.0000001" locale:locale],
      
      @"stringA" : @"potato",
      @"stringB" : @"",
      @"stringC" : @"Applejacks",
      @"stringD" : @"5",
      @"stringE" : @"8.45",
      @"stringF" : @"-5.84",
      @"stringG" : @"The quick brown fox jumped.",
      @"stringH" : @"35,452.45",
      @"stringI" : @"$99.45",
      @"stringJ" : @"$1,049.45",
      @"stringK" : @"!",
      @"stringL" : @"YES",
      @"stringM" : @"NO",
      @"stringN" : @"1",
      @"stringO" : @"0",
      @"stringP" : @"1413172800",
      @"stringQ" : @"true",
      @"stringR" : @"false",
      @"stringS" : @"72345 23590",
      @"stringT" : @"11 hamsters",
      @"stringU" : @"the crazy 88",
      @"stringV" : @"the 21 slices",
      @"stringW" : @"two",
      @"stringX" : @"0 changes",
      @"stringY" : @".009",
      @"stringZ" : @"-2.5006e3",
      
      @"dateA" : @(-5482343),
      @"dateB" : @(1415162234),
      @"dateC" : [NSDecimalNumber decimalNumberWithString:@"1451606400.545684" locale:locale],
      @"dateD" : @"2012-10-27",
      @"dateE" : @"2013-11-28T08:40:32Z",
      @"dateF" : @"2014-12-29T09:44:55+00:00",
      
      @"nullA" : [NSNull null],
      
      @"arrayEmpty" : @[],
      @"arrayStringA" : @[ @"apple", @"box", @"cat", @"dog" ],
      @"arrayNumberA" : @[ @5, @8, @(-3), [NSDecimalNumber decimalNumberWithString:@"5.9999" locale:locale], @4.2, @0 ],
      @"arrayMixA" : @[ @"pizza", @9, @"pie", [NSNull null], @(YES), @"88", @"2", @"", @"3.45" ],
      
      @"dictionaryEmpty" : @{},
      @"dictionaryStringStringA" : @{ @"one" : @"uno", @"two" : @"duo", @"three" : @"trio" },
      @"dictionaryStringNumberA" : @{ @"first" : @1, @"second" : @2, @"third" : @3 },
      @"dictionaryNumberStringA" : @{ @1 : @"single", @2 : @"double" , @3 : @"triple" },
      @"dictionaryMixMixA" : @{ @"Anna" : @"ant", @5 : @"fizz", @"Tom" : @8, @"no-more" : [NSNull null] },
      
      @"garbageA" : NSClassFromString(NSStringFromClass([NSScanner class])),
      @"garbageB" : [NSError errorWithDomain:@"test.domain" code:888 userInfo:nil],
      };
    
    self.extractor = [PPExtractor extractorWithDictionary:dictionary];
}

- (void)tearDown
{
    self.emptyExtractor = nil;
    self.extractor = nil;
    
    [super tearDown];
}

- (void)testExtractorCreation
{
    XCTAssertNil([[PPExtractor alloc] init]);
    XCTAssertNil([[PPExtractor alloc] initWithDictionary:nil]);
    XCTAssertNil([PPExtractor extractorWithDictionary:nil]);
    XCTAssertNotNil([[PPExtractor alloc] initWithDictionary:@{}]);
    XCTAssertNotNil([PPExtractor extractorWithDictionary:@{}]);
    
    id notDictionary;
    
    notDictionary = @[ @"test" ];
    XCTAssertNil([[PPExtractor alloc] initWithDictionary:notDictionary]);
    
    notDictionary = @"hello";
    XCTAssertNil([[PPExtractor alloc] initWithDictionary:notDictionary]);
    
    notDictionary = [NSNull null];
    XCTAssertNil([[PPExtractor alloc] initWithDictionary:notDictionary]);
    
    notDictionary = [NSString class];
    XCTAssertNil([[PPExtractor alloc] initWithDictionary:notDictionary]);
}

- (void)testImmutability
{
    {
        NSMutableDictionary *mutableDictionary = [@{ @"post" : @"note" , @"maple" : @"syrup" , @"twenty" : @1 } mutableCopy];
        PPExtractor *extractor = [PPExtractor extractorWithDictionary:mutableDictionary];
        XCTAssertTrue([extractor.dictionary isEqualToDictionary:mutableDictionary]);
        XCTAssertEqualObjects([extractor stringForKey:@"post"], @"note");
        [mutableDictionary removeAllObjects];
        XCTAssertFalse([extractor.dictionary isEqualToDictionary:mutableDictionary]);
        XCTAssertEqualObjects([extractor stringForKey:@"post"], @"note");
        XCTAssertEqualObjects([extractor stringForKey:@"maple"], @"syrup");
        XCTAssertEqualObjects([extractor numberForKey:@"twenty"], @1);
    }
    
    {
        NSMutableDictionary *mutableDictionary = [@{ @"post" : @"note" , @"maple" : @"syrup" , @"twenty" : @1 } mutableCopy];
        PPExtractor *extractor = [[PPExtractor alloc] initWithDictionary:mutableDictionary];
        XCTAssertTrue([extractor.dictionary isEqualToDictionary:mutableDictionary]);
        XCTAssertEqualObjects([extractor stringForKey:@"post"], @"note");
        [mutableDictionary removeAllObjects];
        XCTAssertFalse([extractor.dictionary isEqualToDictionary:mutableDictionary]);
        XCTAssertEqualObjects([extractor stringForKey:@"post"], @"note");
        XCTAssertEqualObjects([extractor stringForKey:@"maple"], @"syrup");
        XCTAssertEqualObjects([extractor numberForKey:@"twenty"], @1);
    }
}

#pragma mark - Primitives

- (void)testBool
{
    XCTAssertFalse([self.emptyExtractor boolForKey:@"none"]);
    XCTAssertFalse([self.extractor boolForKey:@"none"]);
    
    PPExtractor *extractor = self.extractor;
    
    XCTAssertTrue([extractor boolForKey:@"boolA"]);
    XCTAssertFalse([extractor boolForKey:@"boolB"]);
    
    XCTAssertFalse([extractor boolForKey:@"numberA"]);
    XCTAssertTrue([extractor boolForKey:@"numberB"]);
    XCTAssertTrue([extractor boolForKey:@"numberC"]);
    XCTAssertTrue([extractor boolForKey:@"numberD"]);
    XCTAssertTrue([extractor boolForKey:@"numberE"]);
    XCTAssertTrue([extractor boolForKey:@"numberF"]);
    XCTAssertTrue([extractor boolForKey:@"numberG"]);
    XCTAssertTrue([extractor boolForKey:@"numberH"]);
    XCTAssertTrue([extractor boolForKey:@"numberI"]);
    XCTAssertTrue([extractor boolForKey:@"numberJ"]);
    
    XCTAssertFalse([extractor boolForKey:@"decimalA"]);
    XCTAssertTrue([extractor boolForKey:@"decimalB"]);
    XCTAssertTrue([extractor boolForKey:@"decimalC"]);
    XCTAssertTrue([extractor boolForKey:@"decimalD"]);
    XCTAssertTrue([extractor boolForKey:@"decimalE"]);
    XCTAssertTrue([extractor boolForKey:@"decimalF"]);
    XCTAssertTrue([extractor boolForKey:@"decimalG"]);
    XCTAssertTrue([extractor boolForKey:@"decimalH"]);
    XCTAssertTrue([extractor boolForKey:@"decimalI"]);
    XCTAssertFalse([extractor boolForKey:@"decimalJ"]);
    XCTAssertFalse([extractor boolForKey:@"decimalK"]);
    
    XCTAssertFalse([extractor boolForKey:@"stringA"]);
    XCTAssertFalse([extractor boolForKey:@"stringB"]);
    XCTAssertFalse([extractor boolForKey:@"stringC"]);
    XCTAssertTrue([extractor boolForKey:@"stringD"]);
    XCTAssertTrue([extractor boolForKey:@"stringE"]);
    XCTAssertTrue([extractor boolForKey:@"stringF"]);
    XCTAssertFalse([extractor boolForKey:@"stringG"]);
    XCTAssertTrue([extractor boolForKey:@"stringH"]);
    XCTAssertTrue([extractor boolForKey:@"stringI"]);
    XCTAssertTrue([extractor boolForKey:@"stringJ"]);
    XCTAssertFalse([extractor boolForKey:@"stringK"]);
    XCTAssertFalse([extractor boolForKey:@"stringL"]);
    XCTAssertFalse([extractor boolForKey:@"stringM"]);
    XCTAssertTrue([extractor boolForKey:@"stringN"]);
    XCTAssertFalse([extractor boolForKey:@"stringO"]);
    XCTAssertTrue([extractor boolForKey:@"stringP"]);
    XCTAssertFalse([extractor boolForKey:@"stringQ"]);
    XCTAssertFalse([extractor boolForKey:@"stringR"]);
    XCTAssertTrue([extractor boolForKey:@"stringS"]);
    XCTAssertTrue([extractor boolForKey:@"stringT"]);
    XCTAssertTrue([extractor boolForKey:@"stringU"]);
    XCTAssertTrue([extractor boolForKey:@"stringV"]);
    XCTAssertFalse([extractor boolForKey:@"stringW"]);
    XCTAssertFalse([extractor boolForKey:@"stringX"]);
    XCTAssertFalse([extractor boolForKey:@"stringY"]);
    XCTAssertTrue([extractor boolForKey:@"stringZ"]);
    
    XCTAssertTrue([extractor boolForKey:@"dateA"]);
    XCTAssertTrue([extractor boolForKey:@"dateB"]);
    XCTAssertTrue([extractor boolForKey:@"dateC"]);
    XCTAssertTrue([extractor boolForKey:@"dateD"]);
    XCTAssertTrue([extractor boolForKey:@"dateE"]);
    XCTAssertTrue([extractor boolForKey:@"dateF"]);
    
    XCTAssertFalse([extractor boolForKey:@"nullA"]);
    
    XCTAssertFalse([extractor boolForKey:@"arrayEmpty"]);
    XCTAssertFalse([extractor boolForKey:@"arrayStringA"]);
    XCTAssertFalse([extractor boolForKey:@"arrayNumberA"]);
    XCTAssertFalse([extractor boolForKey:@"arrayMixA"]);
    
    XCTAssertFalse([extractor boolForKey:@"dictionaryEmpty"]);
    XCTAssertFalse([extractor boolForKey:@"dictionaryStringStringA"]);
    XCTAssertFalse([extractor boolForKey:@"dictionaryStringNumberA"]);
    XCTAssertFalse([extractor boolForKey:@"dictionaryNumberStringA"]);
    XCTAssertFalse([extractor boolForKey:@"dictionaryMixMixA"]);
    
    XCTAssertFalse([extractor boolForKey:@"garbageA"]);
    XCTAssertFalse([extractor boolForKey:@"garbageB"]);
}

- (void)testInteger
{
    XCTAssertEqual([self.emptyExtractor integerForKey:@"none"], 0);
    XCTAssertEqual([self.extractor integerForKey:@"none"], 0);
    
    PPExtractor *extractor = self.extractor;
    
    XCTAssertEqual([extractor integerForKey:@"boolA"], 1);
    XCTAssertEqual([extractor integerForKey:@"boolB"], 0);
    
    XCTAssertEqual([extractor integerForKey:@"numberA"], 0);
    XCTAssertEqual([extractor integerForKey:@"numberB"], 1);
    XCTAssertEqual([extractor integerForKey:@"numberC"], 2);
    XCTAssertEqual([extractor integerForKey:@"numberD"], -1);
    XCTAssertEqual([extractor integerForKey:@"numberE"], 8);
    XCTAssertEqual([extractor integerForKey:@"numberF"], -5);
    XCTAssertEqual([extractor integerForKey:@"numberG"], 5);
    XCTAssertEqual([extractor integerForKey:@"numberH"], 7);
    XCTAssertEqual([extractor integerForKey:@"numberI"], -835);
    XCTAssertEqual([extractor integerForKey:@"numberJ"], 685885182);
    
    XCTAssertEqual([extractor integerForKey:@"decimalA"], 0);
    XCTAssertEqual([extractor integerForKey:@"decimalB"], 4);
    XCTAssertEqual([extractor integerForKey:@"decimalC"], 6);
    XCTAssertEqual([extractor integerForKey:@"decimalD"], -3);
    XCTAssertEqual([extractor integerForKey:@"decimalE"], 18);
    XCTAssertEqual([extractor integerForKey:@"decimalF"], 42);
    XCTAssertEqual([extractor integerForKey:@"decimalG"], 13);
    XCTAssertEqual([extractor integerForKey:@"decimalH"], 1415210903);
    XCTAssertEqual([extractor integerForKey:@"decimalI"], 1415250000);
    XCTAssertEqual([extractor integerForKey:@"decimalJ"], 0);
    XCTAssertEqual([extractor integerForKey:@"decimalK"], 0);
    
    XCTAssertEqual([extractor integerForKey:@"stringA"], 0);
    XCTAssertEqual([extractor integerForKey:@"stringB"], 0);
    XCTAssertEqual([extractor integerForKey:@"stringC"], 0);
    XCTAssertEqual([extractor integerForKey:@"stringD"], 5);
    XCTAssertEqual([extractor integerForKey:@"stringE"], 8);
    XCTAssertEqual([extractor integerForKey:@"stringF"], -5);
    XCTAssertEqual([extractor integerForKey:@"stringG"], 0);
    XCTAssertEqual([extractor integerForKey:@"stringH"], 35);
    XCTAssertEqual([extractor integerForKey:@"stringI"], 99);
    XCTAssertEqual([extractor integerForKey:@"stringJ"], 1);
    XCTAssertEqual([extractor integerForKey:@"stringK"], 0);
    XCTAssertEqual([extractor integerForKey:@"stringL"], 0);
    XCTAssertEqual([extractor integerForKey:@"stringM"], 0);
    XCTAssertEqual([extractor integerForKey:@"stringN"], 1);
    XCTAssertEqual([extractor integerForKey:@"stringO"], 0);
    XCTAssertEqual([extractor integerForKey:@"stringP"], 1413172800);
    XCTAssertEqual([extractor integerForKey:@"stringQ"], 0);
    XCTAssertEqual([extractor integerForKey:@"stringR"], 0);
    XCTAssertEqual([extractor integerForKey:@"stringS"], 72345);
    XCTAssertEqual([extractor integerForKey:@"stringT"], 11);
    XCTAssertEqual([extractor integerForKey:@"stringU"], 88);
    XCTAssertEqual([extractor integerForKey:@"stringV"], 21);
    XCTAssertEqual([extractor integerForKey:@"stringW"], 0);
    XCTAssertEqual([extractor integerForKey:@"stringX"], 0);
    XCTAssertEqual([extractor integerForKey:@"stringY"], 0);
    XCTAssertEqual([extractor integerForKey:@"stringZ"], -2);
    
    XCTAssertEqual([extractor integerForKey:@"dateA"], -5482343);
    XCTAssertEqual([extractor integerForKey:@"dateB"], 1415162234);
    XCTAssertEqual([extractor integerForKey:@"dateC"], 1451606400);
    XCTAssertEqual([extractor integerForKey:@"dateD"], 2012);
    XCTAssertEqual([extractor integerForKey:@"dateE"], 2013);
    XCTAssertEqual([extractor integerForKey:@"dateF"], 2014);
    
    XCTAssertEqual([extractor integerForKey:@"nullA"], 0);
    
    XCTAssertEqual([extractor integerForKey:@"arrayEmpty"], 0);
    XCTAssertEqual([extractor integerForKey:@"arrayStringA"], 0);
    XCTAssertEqual([extractor integerForKey:@"arrayNumberA"], 0);
    XCTAssertEqual([extractor integerForKey:@"arrayMixA"], 0);
    
    XCTAssertEqual([extractor integerForKey:@"dictionaryEmpty"], 0);
    XCTAssertEqual([extractor integerForKey:@"dictionaryStringStringA"], 0);
    XCTAssertEqual([extractor integerForKey:@"dictionaryStringNumberA"], 0);
    XCTAssertEqual([extractor integerForKey:@"dictionaryNumberStringA"], 0);
    XCTAssertEqual([extractor integerForKey:@"dictionaryMixMixA"], 0);
    
    XCTAssertEqual([extractor integerForKey:@"garbageA"], 0);
    XCTAssertEqual([extractor integerForKey:@"garbageB"], 0);
}

- (void)testUnsignedInteger
{
    XCTAssertEqual([self.emptyExtractor unsignedIntegerForKey:@"none"], 0u);
    XCTAssertEqual([self.extractor unsignedIntegerForKey:@"none"], 0u);
    
    PPExtractor *extractor = self.extractor;
    
    XCTAssertEqual([extractor unsignedIntegerForKey:@"boolA"], 1u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"boolB"], 0u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"numberA"], 0u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"numberB"], 1u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"numberC"], 2u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"numberD"], NSUIntegerMax - (1u) + 1u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"numberE"], 8u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"numberF"], NSUIntegerMax - (5u) + 1u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"numberG"], 5u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"numberH"], 7u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"numberI"], NSUIntegerMax - (835u) + 1u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"numberJ"], 685885182u);
    
    XCTAssertEqual([extractor unsignedIntegerForKey:@"decimalA"], 0u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"decimalB"], 4u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"decimalC"], 6u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"decimalD"], NSUIntegerMax - (3u) + 1u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"decimalE"], 18u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"decimalF"], 42u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"decimalG"], 13u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"decimalH"], 1415210903u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"decimalI"], 1415250000u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"decimalJ"], 0u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"decimalK"], 0u);
    
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringA"], 0u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringB"], 0u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringC"], 0u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringD"], 5u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringE"], 8u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringF"], NSUIntegerMax - (5u) + 1u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringG"], 0u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringH"], 35u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringI"], 99u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringJ"], 1u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringK"], 0u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringL"], 0u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringM"], 0u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringN"], 1u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringO"], 0u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringP"], 1413172800u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringQ"], 0u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringR"], 0u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringS"], 72345u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringT"], 11u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringU"], 88u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringV"], 21u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringW"], 0u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringX"], 0u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringY"], 0u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"stringZ"], NSUIntegerMax - (2u) + 1u);
    
    XCTAssertEqual([extractor unsignedIntegerForKey:@"dateA"], NSUIntegerMax - (5482343u) + 1u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"dateB"], 1415162234u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"dateC"], 1451606400u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"dateD"], 2012u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"dateE"], 2013u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"dateF"], 2014u);
    
    XCTAssertEqual([extractor unsignedIntegerForKey:@"nullA"], 0u);
    
    XCTAssertEqual([extractor unsignedIntegerForKey:@"arrayEmpty"], 0u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"arrayStringA"], 0u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"arrayNumberA"], 0u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"arrayMixA"], 0u);
    
    XCTAssertEqual([extractor unsignedIntegerForKey:@"dictionaryEmpty"], 0u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"dictionaryStringStringA"], 0u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"dictionaryStringNumberA"], 0u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"dictionaryNumberStringA"], 0u);
    XCTAssertEqual([extractor unsignedIntegerForKey:@"dictionaryMixMixA"], 0u);
    
    XCTAssertEqual([extractor integerForKey:@"garbageA"], 0u);
    XCTAssertEqual([extractor integerForKey:@"garbageB"], 0u);
}

#pragma mark - Objects

- (void)testDate
{
    XCTAssertNil([self.emptyExtractor dateForKey:@"none"]);
    XCTAssertNil([self.emptyExtractor dateForKey:@"none" forceObject:NO]);
    XCTAssertEqualObjects([self.emptyExtractor dateForKey:@"none" forceObject:YES], [NSDate dateWithTimeIntervalSince1970:0]);
    XCTAssertNil([self.extractor dateForKey:@"none"]);
    XCTAssertNil([self.extractor dateForKey:@"none" forceObject:NO]);
    XCTAssertEqualObjects([self.extractor dateForKey:@"none" forceObject:YES], [NSDate dateWithTimeIntervalSince1970:0]);
    
    PPExtractor *extractor = self.extractor;
    NSLocale *locale = [NSLocale systemLocale];
    
    XCTAssertEqualObjects([extractor dateForKey:@"boolA"], [NSDate dateWithTimeIntervalSince1970:1]);
    XCTAssertNil([extractor dateForKey:@"boolB"]);
    XCTAssertEqualObjects([extractor dateForKey:@"boolB" forceObject:YES], [NSDate dateWithTimeIntervalSince1970:0]);
    
    XCTAssertNil([extractor dateForKey:@"numberA"]);
    XCTAssertEqualObjects([extractor dateForKey:@"numberA" forceObject:YES], [NSDate dateWithTimeIntervalSince1970:0]);
    XCTAssertEqualObjects([extractor dateForKey:@"numberB"], [NSDate dateWithTimeIntervalSince1970:1]);
    XCTAssertEqualObjects([extractor dateForKey:@"numberC"], [NSDate dateWithTimeIntervalSince1970:2]);
    XCTAssertEqualObjects([extractor dateForKey:@"numberD"], [NSDate dateWithTimeIntervalSince1970:-1]);
    XCTAssertEqualObjects([extractor dateForKey:@"numberE"], [NSDate dateWithTimeIntervalSince1970:8]);
    XCTAssertEqualObjects([extractor dateForKey:@"numberF"], [NSDate dateWithTimeIntervalSince1970:-5]);
    XCTAssertEqualObjects([extractor dateForKey:@"numberG"], [NSDate dateWithTimeIntervalSince1970:5.24195]);
    XCTAssertEqualObjects([extractor dateForKey:@"numberH"], [NSDate dateWithTimeIntervalSince1970:7.999999]);
    XCTAssertEqualObjects([extractor dateForKey:@"numberI"], [NSDate dateWithTimeIntervalSince1970:-835.452]);
    XCTAssertEqualObjects([extractor dateForKey:@"numberJ"], [NSDate dateWithTimeIntervalSince1970:685885182]);
    
    XCTAssertNil([extractor dateForKey:@"decimalA"]);
    XCTAssertEqualObjects([extractor dateForKey:@"decimalA" forceObject:YES], [NSDate dateWithTimeIntervalSince1970:0]);
    XCTAssertEqualObjects([extractor dateForKey:@"decimalB"], [NSDate dateWithTimeIntervalSince1970:4.13]);
    XCTAssertEqualObjects([extractor dateForKey:@"decimalC"], [NSDate dateWithTimeIntervalSince1970:6.99]);
    XCTAssertEqualObjects([extractor dateForKey:@"decimalD"], [NSDate dateWithTimeIntervalSince1970:-3.01]);
    XCTAssertEqualObjects([extractor dateForKey:@"decimalE"], [NSDate dateWithTimeIntervalSince1970:18.24]);
    XCTAssertEqualObjects([extractor dateForKey:@"decimalF"], [NSDate dateWithTimeIntervalSince1970:42.504245679]);
    XCTAssertEqualObjects([extractor dateForKey:@"decimalG"], [NSDate dateWithTimeIntervalSince1970:13]);
    XCTAssertEqualObjects([extractor dateForKey:@"decimalH"], [NSDate dateWithTimeIntervalSince1970:1415210903]);
    XCTAssertEqualObjects([extractor dateForKey:@"decimalI"], [NSDate dateWithTimeIntervalSince1970:[[NSDecimalNumber decimalNumberWithString:@"1415250000.34642456" locale:locale] doubleValue]]);
    XCTAssertNil([extractor dateForKey:@"decimalJ"]);
    XCTAssertEqualObjects([extractor dateForKey:@"decimalJ" forceObject:YES], [NSDate dateWithTimeIntervalSince1970:0]);
    XCTAssertEqualObjects([extractor dateForKey:@"decimalK"], [NSDate dateWithTimeIntervalSince1970:[[NSDecimalNumber decimalNumberWithString:@"0.0000001" locale:locale] doubleValue]]);
    
    XCTAssertNil([extractor dateForKey:@"stringA"]);
    XCTAssertEqualObjects([extractor dateForKey:@"stringA" forceObject:YES], [NSDate dateWithTimeIntervalSince1970:0]);
    XCTAssertNil([extractor dateForKey:@"stringB"]);
    XCTAssertEqualObjects([extractor dateForKey:@"stringB" forceObject:YES], [NSDate dateWithTimeIntervalSince1970:0]);
    XCTAssertNil([extractor dateForKey:@"stringC"]);
    XCTAssertEqualObjects([extractor dateForKey:@"stringD"], [NSDate dateWithTimeIntervalSince1970:5]);
    XCTAssertEqualObjects([extractor dateForKey:@"stringE"], [NSDate dateWithTimeIntervalSince1970:8.45]);
    XCTAssertEqualObjects([extractor dateForKey:@"stringF"], [NSDate dateWithTimeIntervalSince1970:-5.84]);
    XCTAssertNil([extractor dateForKey:@"stringG"]);
    XCTAssertEqualObjects([extractor dateForKey:@"stringH"], [NSDate dateWithTimeIntervalSince1970:35]);
    XCTAssertEqualObjects([extractor dateForKey:@"stringI"], [NSDate dateWithTimeIntervalSince1970:99.45]);
    XCTAssertEqualObjects([extractor dateForKey:@"stringJ"], [NSDate dateWithTimeIntervalSince1970:1]);
    XCTAssertNil([extractor dateForKey:@"stringK"]);
    XCTAssertNil([extractor dateForKey:@"stringL"]);
    XCTAssertNil([extractor dateForKey:@"stringM"]);
    XCTAssertEqualObjects([extractor dateForKey:@"stringN"], [NSDate dateWithTimeIntervalSince1970:1]);
    XCTAssertNil([extractor dateForKey:@"stringO"]);
    XCTAssertEqualObjects([extractor dateForKey:@"stringP"], [NSDate dateWithTimeIntervalSince1970:1413172800]);
    XCTAssertNil([extractor dateForKey:@"stringQ"]);
    XCTAssertNil([extractor dateForKey:@"stringR"]);
    XCTAssertEqualObjects([extractor dateForKey:@"stringS"], [NSDate dateWithTimeIntervalSince1970:72345]);
    XCTAssertEqualObjects([extractor dateForKey:@"stringT"], [NSDate dateWithTimeIntervalSince1970:11]);
    XCTAssertEqualObjects([extractor dateForKey:@"stringU"], [NSDate dateWithTimeIntervalSince1970:88]);
    XCTAssertEqualObjects([extractor dateForKey:@"stringV"], [NSDate dateWithTimeIntervalSince1970:21]);
    XCTAssertNil([extractor dateForKey:@"stringW"]);
    XCTAssertNil([extractor dateForKey:@"stringX"]);
    XCTAssertEqualObjects([extractor dateForKey:@"stringY"], [NSDate dateWithTimeIntervalSince1970:0.009]);
    XCTAssertEqualObjects([extractor dateForKey:@"stringZ"], [NSDate dateWithTimeIntervalSince1970:[[NSDecimalNumber decimalNumberWithString:@"-2500.6" locale:locale] doubleValue]]);
    
    XCTAssertEqualObjects([extractor dateForKey:@"dateA"], [NSDate dateWithTimeIntervalSince1970:-5482343]);
    XCTAssertEqualObjects([extractor dateForKey:@"dateB"], [NSDate dateWithTimeIntervalSince1970:1415162234]);
    XCTAssertEqualObjects([extractor dateForKey:@"dateB" forceObject:NO], [NSDate dateWithTimeIntervalSince1970:1415162234]);
    XCTAssertEqualObjects([extractor dateForKey:@"dateB" forceObject:YES], [NSDate dateWithTimeIntervalSince1970:1415162234]);
    XCTAssertEqualObjects([extractor dateForKey:@"dateC"], [NSDate dateWithTimeIntervalSince1970:[[NSDecimalNumber decimalNumberWithString:@"1451606400.545684" locale:locale] doubleValue]]);
    XCTAssertEqualObjects([extractor dateForKey:@"dateD"], [NSDate dateWithTimeIntervalSince1970:2012]);
    XCTAssertEqualObjects([extractor dateForKey:@"dateE"], [NSDate dateWithTimeIntervalSince1970:2013]);
    XCTAssertEqualObjects([extractor dateForKey:@"dateF"], [NSDate dateWithTimeIntervalSince1970:2014]);
    
    XCTAssertNil([extractor dateForKey:@"nullA"]);
    XCTAssertEqualObjects([extractor dateForKey:@"nullA" forceObject:YES], [NSDate dateWithTimeIntervalSince1970:0]);
    
    XCTAssertNil([extractor dateForKey:@"arrayEmpty"]);
    XCTAssertNil([extractor dateForKey:@"arrayStringA"]);
    XCTAssertNil([extractor dateForKey:@"arrayNumberA"]);
    XCTAssertNil([extractor dateForKey:@"arrayMixA"]);
    XCTAssertEqualObjects([extractor dateForKey:@"arrayMixA" forceObject:YES], [NSDate dateWithTimeIntervalSince1970:0]);
    
    XCTAssertNil([extractor dateForKey:@"dictionaryEmpty"]);
    XCTAssertNil([extractor dateForKey:@"dictionaryStringStringA"]);
    XCTAssertNil([extractor dateForKey:@"dictionaryStringNumberA"]);
    XCTAssertNil([extractor dateForKey:@"dictionaryNumberStringA"]);
    XCTAssertNil([extractor dateForKey:@"dictionaryMixMixA"]);
    XCTAssertEqualObjects([extractor dateForKey:@"dictionaryMixMixA" forceObject:YES], [NSDate dateWithTimeIntervalSince1970:0]);
    
    XCTAssertNil([extractor dateForKey:@"garbageA"]);
    XCTAssertNil([extractor dateForKey:@"garbageB"]);
    XCTAssertEqualObjects([extractor dateForKey:@"garbageB" forceObject:YES], [NSDate dateWithTimeIntervalSince1970:0]);
}

- (void)testNumber
{
    XCTAssertNil([self.emptyExtractor numberForKey:@"none"]);
    XCTAssertNil([self.emptyExtractor numberForKey:@"none" forceObject:NO]);
    XCTAssertEqualObjects([self.emptyExtractor numberForKey:@"none" forceObject:YES], @0);
    XCTAssertNil([self.extractor numberForKey:@"none"]);
    XCTAssertNil([self.extractor numberForKey:@"none" forceObject:NO]);
    XCTAssertEqualObjects([self.extractor numberForKey:@"none" forceObject:YES], @0);
    
    PPExtractor *extractor = self.extractor;
    
    XCTAssertEqualObjects([extractor numberForKey:@"boolA"], @1);
    XCTAssertEqualObjects([extractor numberForKey:@"boolB"], @0);
    
    XCTAssertEqualObjects([extractor numberForKey:@"numberA"], @0);
    XCTAssertEqualObjects([extractor numberForKey:@"numberB"], @1);
    XCTAssertEqualObjects([extractor numberForKey:@"numberC"], @2);
    XCTAssertEqualObjects([extractor numberForKey:@"numberD"], @(-1));
    XCTAssertEqualObjects([extractor numberForKey:@"numberE"], @8);
    XCTAssertEqualObjects([extractor numberForKey:@"numberF"], @(-5));
    XCTAssertEqualObjects([extractor numberForKey:@"numberG"], @5);
    XCTAssertEqualObjects([extractor numberForKey:@"numberH"], @7);
    XCTAssertEqualObjects([extractor numberForKey:@"numberI"], @(-835));
    XCTAssertEqualObjects([extractor numberForKey:@"numberJ"], @685885182);
    XCTAssertEqualObjects([extractor numberForKey:@"numberJ" forceObject:NO], @685885182);
    XCTAssertEqualObjects([extractor numberForKey:@"numberJ" forceObject:YES], @685885182);
    
    XCTAssertEqualObjects([extractor numberForKey:@"decimalA"], @0);
    XCTAssertEqualObjects([extractor numberForKey:@"decimalB"], @4);
    XCTAssertEqualObjects([extractor numberForKey:@"decimalC"], @6);
    XCTAssertEqualObjects([extractor numberForKey:@"decimalD"], @(-3));
    XCTAssertEqualObjects([extractor numberForKey:@"decimalE"], @18);
    XCTAssertEqualObjects([extractor numberForKey:@"decimalF"], @42);
    XCTAssertEqualObjects([extractor numberForKey:@"decimalG"], @13);
    XCTAssertEqualObjects([extractor numberForKey:@"decimalH"], @1415210903);
    XCTAssertEqualObjects([extractor numberForKey:@"decimalI"], @1415250000);
    XCTAssertEqualObjects([extractor numberForKey:@"decimalJ"], @0);
    XCTAssertEqualObjects([extractor numberForKey:@"decimalK"], @0);
    
    XCTAssertNil([extractor numberForKey:@"stringA"]);
    XCTAssertNil([extractor numberForKey:@"stringB"]);
    XCTAssertEqualObjects([extractor numberForKey:@"stringB" forceObject:YES], @0);
    XCTAssertNil([extractor numberForKey:@"stringC"]);
    XCTAssertEqualObjects([extractor numberForKey:@"stringD"], @5);
    XCTAssertEqualObjects([extractor numberForKey:@"stringE"], @8);
    XCTAssertEqualObjects([extractor numberForKey:@"stringF"], @(-5));
    XCTAssertNil([extractor numberForKey:@"stringG"]);
    XCTAssertEqualObjects([extractor numberForKey:@"stringH"], @35);
    XCTAssertEqualObjects([extractor numberForKey:@"stringI"], @99);
    XCTAssertEqualObjects([extractor numberForKey:@"stringJ"], @1);
    XCTAssertNil([extractor numberForKey:@"stringK"]);
    XCTAssertNil([extractor numberForKey:@"stringL"]);
    XCTAssertNil([extractor numberForKey:@"stringM"]);
    XCTAssertEqualObjects([extractor numberForKey:@"stringN"], @1);
    XCTAssertEqualObjects([extractor numberForKey:@"stringO"], @0);
    XCTAssertEqualObjects([extractor numberForKey:@"stringP"], @1413172800);
    XCTAssertNil([extractor numberForKey:@"stringQ"]);
    XCTAssertNil([extractor numberForKey:@"stringR"]);
    XCTAssertEqualObjects([extractor numberForKey:@"stringS"], @72345);
    XCTAssertEqualObjects([extractor numberForKey:@"stringT"], @11);
    XCTAssertEqualObjects([extractor numberForKey:@"stringU"], @88);
    XCTAssertEqualObjects([extractor numberForKey:@"stringV"], @21);
    XCTAssertNil([extractor numberForKey:@"stringW"]);
    XCTAssertEqualObjects([extractor numberForKey:@"stringX"], @0);
    XCTAssertEqualObjects([extractor numberForKey:@"stringY"], @0);
    XCTAssertEqualObjects([extractor numberForKey:@"stringZ"], @(-2));
    
    XCTAssertEqualObjects([extractor numberForKey:@"dateA"], @(-5482343));
    XCTAssertEqualObjects([extractor numberForKey:@"dateB"], @1415162234);
    XCTAssertEqualObjects([extractor numberForKey:@"dateC"], @1451606400);
    XCTAssertEqualObjects([extractor numberForKey:@"dateD"], @2012);
    XCTAssertEqualObjects([extractor numberForKey:@"dateE"], @2013);
    XCTAssertEqualObjects([extractor numberForKey:@"dateF"], @2014);
    
    XCTAssertNil([extractor numberForKey:@"nullA"]);
    XCTAssertEqualObjects([extractor numberForKey:@"nullA" forceObject:YES], @0);
    
    XCTAssertNil([extractor numberForKey:@"arrayEmpty"]);
    XCTAssertNil([extractor numberForKey:@"arrayStringA"]);
    XCTAssertNil([extractor numberForKey:@"arrayNumberA"]);
    XCTAssertNil([extractor numberForKey:@"arrayMixA"]);
    XCTAssertEqualObjects([extractor numberForKey:@"arrayMixA" forceObject:YES], @0);
    
    XCTAssertNil([extractor numberForKey:@"dictionaryEmpty"]);
    XCTAssertNil([extractor numberForKey:@"dictionaryStringStringA"]);
    XCTAssertNil([extractor numberForKey:@"dictionaryStringNumberA"]);
    XCTAssertNil([extractor numberForKey:@"dictionaryNumberStringA"]);
    XCTAssertNil([extractor numberForKey:@"dictionaryMixMixA"]);
    XCTAssertEqualObjects([extractor numberForKey:@"dictionaryMixMixA" forceObject:YES], @0);
    
    XCTAssertNil([extractor numberForKey:@"garbageA"]);
    XCTAssertNil([extractor numberForKey:@"garbageB"]);
    XCTAssertEqualObjects([extractor numberForKey:@"garbageB" forceObject:YES], @0);
}

- (void)testString
{
    XCTAssertNil([self.emptyExtractor stringForKey:@"none"]);
    XCTAssertNil([self.emptyExtractor stringForKey:@"none" forceObject:NO]);
    XCTAssertEqualObjects([self.emptyExtractor stringForKey:@"none" forceObject:YES], @"");
    XCTAssertNil([self.extractor stringForKey:@"none"]);
    XCTAssertNil([self.extractor stringForKey:@"none" forceObject:NO]);
    XCTAssertEqualObjects([self.extractor stringForKey:@"none" forceObject:YES], @"");
    
    PPExtractor *extractor = self.extractor;
    
    XCTAssertEqualObjects([extractor stringForKey:@"boolA"], @"1");
    XCTAssertEqualObjects([extractor stringForKey:@"boolB"], @"0");
    
    XCTAssertEqualObjects([extractor stringForKey:@"numberA"], @"0");
    XCTAssertEqualObjects([extractor stringForKey:@"numberB"], @"1");
    XCTAssertEqualObjects([extractor stringForKey:@"numberC"], @"2");
    XCTAssertEqualObjects([extractor stringForKey:@"numberD"], @"-1");
    XCTAssertEqualObjects([extractor stringForKey:@"numberE"], @"8");
    XCTAssertEqualObjects([extractor stringForKey:@"numberF"], @"-5");
    XCTAssertEqualObjects([extractor stringForKey:@"numberG"], @"5.24195");
    XCTAssertEqualObjects([extractor stringForKey:@"numberH"], @"7.999999");
    XCTAssertEqualObjects([extractor stringForKey:@"numberI"], @"-835.452");
    XCTAssertEqualObjects([extractor stringForKey:@"numberJ"], @"685885182");
    
    XCTAssertEqualObjects([extractor stringForKey:@"decimalA"], @"0");
    XCTAssertEqualObjects([extractor stringForKey:@"decimalB"], @"4.13");
    XCTAssertEqualObjects([extractor stringForKey:@"decimalC"], @"6.99");
    XCTAssertEqualObjects([extractor stringForKey:@"decimalD"], @"-3.01");
    XCTAssertEqualObjects([extractor stringForKey:@"decimalE"], @"18.24");
    XCTAssertEqualObjects([extractor stringForKey:@"decimalF"], @"42.504245679");
    XCTAssertEqualObjects([extractor stringForKey:@"decimalG"], @"13");
    XCTAssertEqualObjects([extractor stringForKey:@"decimalH"], @"1415210903");
    XCTAssertEqualObjects([extractor stringForKey:@"decimalI"], @"1415250000.34642456");
    XCTAssertEqualObjects([extractor stringForKey:@"decimalJ"], @"NaN");
    XCTAssertEqualObjects([extractor stringForKey:@"decimalK"], @"0.0000001");
    
    XCTAssertEqualObjects([extractor stringForKey:@"stringA"], @"potato");
    XCTAssertEqualObjects([extractor stringForKey:@"stringA" forceObject:NO], @"potato");
    XCTAssertEqualObjects([extractor stringForKey:@"stringA" forceObject:YES], @"potato");
    XCTAssertEqualObjects([extractor stringForKey:@"stringB"], @"");
    XCTAssertEqualObjects([extractor stringForKey:@"stringC"], @"Applejacks");
    XCTAssertEqualObjects([extractor stringForKey:@"stringD"], @"5");
    XCTAssertEqualObjects([extractor stringForKey:@"stringE"], @"8.45");
    XCTAssertEqualObjects([extractor stringForKey:@"stringF"], @"-5.84");
    XCTAssertEqualObjects([extractor stringForKey:@"stringG"], @"The quick brown fox jumped.");
    XCTAssertEqualObjects([extractor stringForKey:@"stringH"], @"35,452.45");
    XCTAssertEqualObjects([extractor stringForKey:@"stringI"], @"$99.45");
    XCTAssertEqualObjects([extractor stringForKey:@"stringJ"], @"$1,049.45");
    XCTAssertEqualObjects([extractor stringForKey:@"stringK"], @"!");
    XCTAssertEqualObjects([extractor stringForKey:@"stringL"], @"YES");
    XCTAssertEqualObjects([extractor stringForKey:@"stringM"], @"NO");
    XCTAssertEqualObjects([extractor stringForKey:@"stringN"], @"1");
    XCTAssertEqualObjects([extractor stringForKey:@"stringO"], @"0");
    XCTAssertEqualObjects([extractor stringForKey:@"stringP"], @"1413172800");
    XCTAssertEqualObjects([extractor stringForKey:@"stringQ"], @"true");
    XCTAssertEqualObjects([extractor stringForKey:@"stringR"], @"false");
    XCTAssertEqualObjects([extractor stringForKey:@"stringS"], @"72345 23590");
    XCTAssertEqualObjects([extractor stringForKey:@"stringT"], @"11 hamsters");
    XCTAssertEqualObjects([extractor stringForKey:@"stringU"], @"the crazy 88");
    XCTAssertEqualObjects([extractor stringForKey:@"stringV"], @"the 21 slices");
    XCTAssertEqualObjects([extractor stringForKey:@"stringW"], @"two");
    XCTAssertEqualObjects([extractor stringForKey:@"stringX"], @"0 changes");
    XCTAssertEqualObjects([extractor stringForKey:@"stringY"], @".009");
    XCTAssertEqualObjects([extractor stringForKey:@"stringZ"], @"-2.5006e3");
    
    XCTAssertEqualObjects([extractor stringForKey:@"dateA"], @"-5482343");
    XCTAssertEqualObjects([extractor stringForKey:@"dateB"], @"1415162234");
    XCTAssertEqualObjects([extractor stringForKey:@"dateC"], @"1451606400.545684");
    XCTAssertEqualObjects([extractor stringForKey:@"dateD"], @"2012-10-27");
    XCTAssertEqualObjects([extractor stringForKey:@"dateE"], @"2013-11-28T08:40:32Z");
    XCTAssertEqualObjects([extractor stringForKey:@"dateF"], @"2014-12-29T09:44:55+00:00");
    
    XCTAssertNil([extractor stringForKey:@"nullA"]);
    XCTAssertEqualObjects([extractor stringForKey:@"nullA" forceObject:YES], @"");
    
    XCTAssertNil([extractor stringForKey:@"arrayEmpty"]);
    XCTAssertNil([extractor stringForKey:@"arrayStringA"]);
    XCTAssertNil([extractor stringForKey:@"arrayNumberA"]);
    XCTAssertNil([extractor stringForKey:@"arrayMixA"]);
    XCTAssertEqualObjects([extractor stringForKey:@"arrayMixA" forceObject:YES], @"");
    
    XCTAssertNil([extractor stringForKey:@"dictionaryEmpty"]);
    XCTAssertNil([extractor stringForKey:@"dictionaryStringStringA"]);
    XCTAssertNil([extractor stringForKey:@"dictionaryStringNumberA"]);
    XCTAssertNil([extractor stringForKey:@"dictionaryNumberStringA"]);
    XCTAssertNil([extractor stringForKey:@"dictionaryMixMixA"]);
    XCTAssertEqualObjects([extractor stringForKey:@"dictionaryMixMixA" forceObject:YES], @"");
    
    XCTAssertNil([extractor stringForKey:@"garbageA"]);
    XCTAssertNil([extractor stringForKey:@"garbageB"]);
    XCTAssertEqualObjects([extractor stringForKey:@"garbageB" forceObject:YES], @"");
}

- (void)testDecimalNumber
{
    XCTAssertNil([self.emptyExtractor decimalNumberForKey:@"none"]);
    XCTAssertNil([self.emptyExtractor decimalNumberForKey:@"none" forceObject:NO]);
    XCTAssertEqualObjects([self.emptyExtractor decimalNumberForKey:@"none" forceObject:YES], [NSDecimalNumber notANumber]);
    XCTAssertNil([self.extractor decimalNumberForKey:@"none"]);
    XCTAssertNil([self.extractor decimalNumberForKey:@"none" forceObject:NO]);
    XCTAssertEqualObjects([self.extractor decimalNumberForKey:@"none" forceObject:YES], [NSDecimalNumber notANumber]);
    
    PPExtractor *extractor = self.extractor;
    NSLocale *locale = [NSLocale systemLocale];
    
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"boolA"], [NSDecimalNumber one]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"boolB"], [NSDecimalNumber zero]);
    
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"numberA"], [NSDecimalNumber zero]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"numberB"], [NSDecimalNumber one]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"numberC"], [NSDecimalNumber decimalNumberWithString:@"2" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"numberD"], [NSDecimalNumber decimalNumberWithString:@"-1" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"numberE"], [NSDecimalNumber decimalNumberWithString:@"8" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"numberF"], [NSDecimalNumber decimalNumberWithString:@"-5" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"numberG"], [NSDecimalNumber decimalNumberWithString:@"5.24195" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"numberH"], [NSDecimalNumber decimalNumberWithString:@"7.999999" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"numberI"], [NSDecimalNumber decimalNumberWithString:@"-835.452" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"numberJ"], [NSDecimalNumber decimalNumberWithString:@"685885182" locale:locale]);
    
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"decimalA"], [NSDecimalNumber zero]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"decimalB"], [NSDecimalNumber decimalNumberWithString:@"4.13" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"decimalC"], [NSDecimalNumber decimalNumberWithString:@"6.99" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"decimalD"], [NSDecimalNumber decimalNumberWithString:@"-3.01" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"decimalE"], [NSDecimalNumber decimalNumberWithString:@"18.24" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"decimalE" forceObject:NO], [NSDecimalNumber decimalNumberWithString:@"18.24" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"decimalE" forceObject:YES], [NSDecimalNumber decimalNumberWithString:@"18.24" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"decimalF"], [NSDecimalNumber decimalNumberWithString:@"42.504245679" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"decimalG"], [NSDecimalNumber decimalNumberWithString:@"13" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"decimalH"], [NSDecimalNumber decimalNumberWithString:@"1415210903" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"decimalI"], [NSDecimalNumber decimalNumberWithString:@"1415250000.34642456" locale:locale]);
    XCTAssertNil([extractor decimalNumberForKey:@"decimalJ"]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"decimalJ" forceObject:YES], [NSDecimalNumber notANumber]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"decimalK"], [NSDecimalNumber decimalNumberWithString:@"0.0000001" locale:locale]);
    
    XCTAssertNil([extractor decimalNumberForKey:@"stringA"]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringA" forceObject:YES], [NSDecimalNumber notANumber]);
    XCTAssertNil([extractor decimalNumberForKey:@"stringB"]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringB" forceObject:YES], [NSDecimalNumber notANumber]);
    XCTAssertNil([extractor decimalNumberForKey:@"stringC"]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringC" forceObject:YES], [NSDecimalNumber notANumber]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringD"], [NSDecimalNumber decimalNumberWithString:@"5" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringE"], [NSDecimalNumber decimalNumberWithString:@"8.45" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringF"], [NSDecimalNumber decimalNumberWithString:@"-5.84" locale:locale]);
    XCTAssertNil([extractor decimalNumberForKey:@"stringG"]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringG" forceObject:YES], [NSDecimalNumber notANumber]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringH"], [NSDecimalNumber decimalNumberWithString:@"35" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringI"], [NSDecimalNumber decimalNumberWithString:@"99.45" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringJ"], [NSDecimalNumber decimalNumberWithString:@"1" locale:locale]);
    XCTAssertNil([extractor decimalNumberForKey:@"stringK"]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringK" forceObject:YES], [NSDecimalNumber notANumber]);
    XCTAssertNil([extractor decimalNumberForKey:@"stringL"]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringL" forceObject:YES], [NSDecimalNumber notANumber]);
    XCTAssertNil([extractor decimalNumberForKey:@"stringM"]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringM" forceObject:YES], [NSDecimalNumber notANumber]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringN"], [NSDecimalNumber one]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringO"], [NSDecimalNumber zero]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringP"], [NSDecimalNumber decimalNumberWithString:@"1413172800" locale:locale]);
    XCTAssertNil([extractor decimalNumberForKey:@"stringQ"]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringQ" forceObject:YES], [NSDecimalNumber notANumber]);
    XCTAssertNil([extractor decimalNumberForKey:@"stringR"]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringR" forceObject:YES], [NSDecimalNumber notANumber]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringS"], [NSDecimalNumber decimalNumberWithString:@"72345" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringT"], [NSDecimalNumber decimalNumberWithString:@"11" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringU" forceObject:YES], [NSDecimalNumber decimalNumberWithString:@"88" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringV" forceObject:YES], [NSDecimalNumber decimalNumberWithString:@"21" locale:locale]);
    XCTAssertNil([extractor decimalNumberForKey:@"stringW"]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringW" forceObject:YES], [NSDecimalNumber notANumber]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringX"], [NSDecimalNumber zero]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringY"], [NSDecimalNumber decimalNumberWithString:@"0.009" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"stringZ"], [NSDecimalNumber decimalNumberWithString:@"-2500.6" locale:locale]);
    
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"dateA"], [NSDecimalNumber decimalNumberWithString:@"-5482343" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"dateB"], [NSDecimalNumber decimalNumberWithString:@"1415162234" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"dateC"], [NSDecimalNumber decimalNumberWithString:@"1451606400.545684" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"dateD"], [NSDecimalNumber decimalNumberWithString:@"2012" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"dateE"], [NSDecimalNumber decimalNumberWithString:@"2013" locale:locale]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"dateF"], [NSDecimalNumber decimalNumberWithString:@"2014" locale:locale]);
    
    XCTAssertNil([extractor decimalNumberForKey:@"nullA"]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"nullA" forceObject:YES], [NSDecimalNumber notANumber]);
    
    XCTAssertNil([extractor decimalNumberForKey:@"arrayEmpty"]);
    XCTAssertNil([extractor decimalNumberForKey:@"arrayStringA"]);
    XCTAssertNil([extractor decimalNumberForKey:@"arrayNumberA"]);
    XCTAssertNil([extractor decimalNumberForKey:@"arrayMixA"]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"arrayMixA" forceObject:YES], [NSDecimalNumber notANumber]);
    
    XCTAssertNil([extractor decimalNumberForKey:@"dictionaryEmpty"]);
    XCTAssertNil([extractor decimalNumberForKey:@"dictionaryStringStringA"]);
    XCTAssertNil([extractor decimalNumberForKey:@"dictionaryStringNumberA"]);
    XCTAssertNil([extractor decimalNumberForKey:@"dictionaryNumberStringA"]);
    XCTAssertNil([extractor decimalNumberForKey:@"dictionaryMixMixA"]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"dictionaryMixMixA" forceObject:YES], [NSDecimalNumber notANumber]);
    
    XCTAssertNil([extractor decimalNumberForKey:@"garbageA"]);
    XCTAssertNil([extractor decimalNumberForKey:@"garbageB"]);
    XCTAssertEqualObjects([extractor decimalNumberForKey:@"garbageB" forceObject:YES], [NSDecimalNumber notANumber]);
}

- (void)testArray
{
    XCTAssertNil([self.emptyExtractor arrayForKey:@"none"]);
    XCTAssertNil([self.emptyExtractor arrayForKey:@"none" forceObject:NO]);
    XCTAssertTrue([[self.emptyExtractor arrayForKey:@"none" forceObject:YES] isEqualToArray:@[]]);
    XCTAssertNil([self.extractor arrayForKey:@"none"]);
    XCTAssertNil([self.extractor arrayForKey:@"none" forceObject:NO]);
    XCTAssertTrue([[self.extractor arrayForKey:@"none" forceObject:YES] isEqualToArray:@[]]);
    
    PPExtractor *extractor = self.extractor;
    NSLocale *locale = [NSLocale systemLocale];
    
    XCTAssertNil([extractor arrayForKey:@"boolA"]);
    XCTAssertNil([extractor arrayForKey:@"boolB"]);
    XCTAssertTrue([[extractor arrayForKey:@"boolB" forceObject:YES] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayForKey:@"numberA"]);
    XCTAssertNil([extractor arrayForKey:@"numberB"]);
    XCTAssertNil([extractor arrayForKey:@"numberC"]);
    XCTAssertNil([extractor arrayForKey:@"numberD"]);
    XCTAssertNil([extractor arrayForKey:@"numberE"]);
    XCTAssertNil([extractor arrayForKey:@"numberF"]);
    XCTAssertNil([extractor arrayForKey:@"numberG"]);
    XCTAssertNil([extractor arrayForKey:@"numberH"]);
    XCTAssertNil([extractor arrayForKey:@"numberI"]);
    XCTAssertNil([extractor arrayForKey:@"numberJ"]);
    XCTAssertTrue([[extractor arrayForKey:@"numberJ" forceObject:YES] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayForKey:@"decimalA"]);
    XCTAssertNil([extractor arrayForKey:@"decimalB"]);
    XCTAssertNil([extractor arrayForKey:@"decimalC"]);
    XCTAssertNil([extractor arrayForKey:@"decimalD"]);
    XCTAssertNil([extractor arrayForKey:@"decimalE"]);
    XCTAssertNil([extractor arrayForKey:@"decimalF"]);
    XCTAssertNil([extractor arrayForKey:@"decimalG"]);
    XCTAssertNil([extractor arrayForKey:@"decimalH"]);
    XCTAssertNil([extractor arrayForKey:@"decimalI"]);
    XCTAssertNil([extractor arrayForKey:@"decimalJ"]);
    XCTAssertNil([extractor arrayForKey:@"decimalK"]);
    XCTAssertTrue([[extractor arrayForKey:@"decimalK" forceObject:YES] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayForKey:@"stringA"]);
    XCTAssertNil([extractor arrayForKey:@"stringB"]);
    XCTAssertNil([extractor arrayForKey:@"stringC"]);
    XCTAssertNil([extractor arrayForKey:@"stringD"]);
    XCTAssertNil([extractor arrayForKey:@"stringE"]);
    XCTAssertNil([extractor arrayForKey:@"stringF"]);
    XCTAssertNil([extractor arrayForKey:@"stringG"]);
    XCTAssertNil([extractor arrayForKey:@"stringH"]);
    XCTAssertNil([extractor arrayForKey:@"stringI"]);
    XCTAssertNil([extractor arrayForKey:@"stringJ"]);
    XCTAssertNil([extractor arrayForKey:@"stringK"]);
    XCTAssertNil([extractor arrayForKey:@"stringL"]);
    XCTAssertNil([extractor arrayForKey:@"stringM"]);
    XCTAssertNil([extractor arrayForKey:@"stringN"]);
    XCTAssertNil([extractor arrayForKey:@"stringO"]);
    XCTAssertNil([extractor arrayForKey:@"stringP"]);
    XCTAssertNil([extractor arrayForKey:@"stringQ"]);
    XCTAssertNil([extractor arrayForKey:@"stringR"]);
    XCTAssertNil([extractor arrayForKey:@"stringS"]);
    XCTAssertNil([extractor arrayForKey:@"stringT"]);
    XCTAssertNil([extractor arrayForKey:@"stringU"]);
    XCTAssertNil([extractor arrayForKey:@"stringV"]);
    XCTAssertNil([extractor arrayForKey:@"stringW"]);
    XCTAssertNil([extractor arrayForKey:@"stringX"]);
    XCTAssertNil([extractor arrayForKey:@"stringY"]);
    XCTAssertNil([extractor arrayForKey:@"stringZ"]);
    XCTAssertTrue([[extractor arrayForKey:@"stringZ" forceObject:YES] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayForKey:@"dateA"]);
    XCTAssertNil([extractor arrayForKey:@"dateB"]);
    XCTAssertNil([extractor arrayForKey:@"dateC"]);
    XCTAssertNil([extractor arrayForKey:@"dateD"]);
    XCTAssertNil([extractor arrayForKey:@"dateE"]);
    XCTAssertNil([extractor arrayForKey:@"dateF"]);
    XCTAssertTrue([[extractor arrayForKey:@"dateF" forceObject:YES] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayForKey:@"nullA"]);
    XCTAssertTrue([[extractor arrayForKey:@"nullA" forceObject:YES] isEqualToArray:@[]]);
    
    XCTAssertTrue([[extractor arrayForKey:@"arrayEmpty"] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayForKey:@"arrayStringA"] isEqualToArray:(@[ @"apple", @"box", @"cat", @"dog" ])]);
    XCTAssertTrue([[extractor arrayForKey:@"arrayStringA" forceObject:NO] isEqualToArray:(@[ @"apple", @"box", @"cat", @"dog" ])]);
    XCTAssertTrue([[extractor arrayForKey:@"arrayStringA" forceObject:YES] isEqualToArray:(@[ @"apple", @"box", @"cat", @"dog" ])]);
    XCTAssertTrue([[extractor arrayForKey:@"arrayNumberA"] isEqualToArray:(@[ @5, @8, @(-3), [NSDecimalNumber decimalNumberWithString:@"5.9999" locale:locale], @4.2, @0 ])]);
    XCTAssertTrue([[extractor arrayForKey:@"arrayMixA"] isEqualToArray:(@[ @"pizza", @9, @"pie", [NSNull null], @(YES), @"88", @"2", @"", @"3.45" ])]);
    
    XCTAssertNil([extractor arrayForKey:@"dictionaryEmpty"]);
    XCTAssertNil([extractor arrayForKey:@"dictionaryStringStringA"]);
    XCTAssertNil([extractor arrayForKey:@"dictionaryStringNumberA"]);
    XCTAssertNil([extractor arrayForKey:@"dictionaryNumberStringA"]);
    XCTAssertNil([extractor arrayForKey:@"dictionaryMixMixA"]);
    XCTAssertTrue([[extractor arrayForKey:@"dictionaryMixMixA" forceObject:YES] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayForKey:@"garbageA"]);
    XCTAssertNil([extractor arrayForKey:@"garbageB"]);
    XCTAssertTrue([[extractor arrayForKey:@"garbageB" forceObject:YES] isEqualToArray:@[]]);
}

- (void)testDictionary
{
    XCTAssertNil([self.emptyExtractor dictionaryForKey:@"none"]);
    XCTAssertNil([self.emptyExtractor dictionaryForKey:@"none" forceObject:NO]);
    XCTAssertTrue([[self.emptyExtractor dictionaryForKey:@"none" forceObject:YES] isEqualToDictionary:@{}]);
    XCTAssertNil([self.extractor dictionaryForKey:@"none"]);
    XCTAssertNil([self.extractor dictionaryForKey:@"none" forceObject:NO]);
    XCTAssertTrue([[self.extractor dictionaryForKey:@"none" forceObject:YES] isEqualToDictionary:@{}]);
    
    PPExtractor *extractor = self.extractor;
    
    XCTAssertNil([extractor dictionaryForKey:@"boolA"]);
    XCTAssertNil([extractor dictionaryForKey:@"boolB"]);
    XCTAssertTrue([[extractor dictionaryForKey:@"boolB" forceObject:YES] isEqualToDictionary:@{}]);
    
    XCTAssertNil([extractor dictionaryForKey:@"numberA"]);
    XCTAssertNil([extractor dictionaryForKey:@"numberB"]);
    XCTAssertNil([extractor dictionaryForKey:@"numberC"]);
    XCTAssertNil([extractor dictionaryForKey:@"numberD"]);
    XCTAssertNil([extractor dictionaryForKey:@"numberE"]);
    XCTAssertNil([extractor dictionaryForKey:@"numberF"]);
    XCTAssertNil([extractor dictionaryForKey:@"numberG"]);
    XCTAssertNil([extractor dictionaryForKey:@"numberH"]);
    XCTAssertNil([extractor dictionaryForKey:@"numberI"]);
    XCTAssertNil([extractor dictionaryForKey:@"numberJ"]);
    XCTAssertTrue([[extractor dictionaryForKey:@"numberJ" forceObject:YES] isEqualToDictionary:@{}]);
    
    XCTAssertNil([extractor dictionaryForKey:@"decimalA"]);
    XCTAssertNil([extractor dictionaryForKey:@"decimalB"]);
    XCTAssertNil([extractor dictionaryForKey:@"decimalC"]);
    XCTAssertNil([extractor dictionaryForKey:@"decimalD"]);
    XCTAssertNil([extractor dictionaryForKey:@"decimalE"]);
    XCTAssertNil([extractor dictionaryForKey:@"decimalF"]);
    XCTAssertNil([extractor dictionaryForKey:@"decimalG"]);
    XCTAssertNil([extractor dictionaryForKey:@"decimalH"]);
    XCTAssertNil([extractor dictionaryForKey:@"decimalI"]);
    XCTAssertNil([extractor dictionaryForKey:@"decimalJ"]);
    XCTAssertNil([extractor dictionaryForKey:@"decimalK"]);
    XCTAssertTrue([[extractor dictionaryForKey:@"decimalK" forceObject:YES] isEqualToDictionary:@{}]);
    
    XCTAssertNil([extractor dictionaryForKey:@"stringA"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringB"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringC"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringD"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringE"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringF"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringG"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringH"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringI"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringJ"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringK"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringL"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringM"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringN"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringO"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringP"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringQ"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringR"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringS"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringT"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringU"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringV"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringW"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringX"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringY"]);
    XCTAssertNil([extractor dictionaryForKey:@"stringZ"]);
    XCTAssertTrue([[extractor dictionaryForKey:@"stringZ" forceObject:YES] isEqualToDictionary:@{}]);
    
    XCTAssertNil([extractor dictionaryForKey:@"dateA"]);
    XCTAssertNil([extractor dictionaryForKey:@"dateB"]);
    XCTAssertNil([extractor dictionaryForKey:@"dateC"]);
    XCTAssertNil([extractor dictionaryForKey:@"dateD"]);
    XCTAssertNil([extractor dictionaryForKey:@"dateE"]);
    XCTAssertNil([extractor dictionaryForKey:@"dateF"]);
    XCTAssertTrue([[extractor dictionaryForKey:@"dateF" forceObject:YES] isEqualToDictionary:@{}]);
    
    XCTAssertNil([extractor dictionaryForKey:@"nullA"]);
    XCTAssertTrue([[extractor dictionaryForKey:@"nullA" forceObject:YES] isEqualToDictionary:@{}]);
    
    XCTAssertNil([extractor dictionaryForKey:@"arrayEmpty"]);
    XCTAssertNil([extractor dictionaryForKey:@"arrayStringA"]);
    XCTAssertNil([extractor dictionaryForKey:@"arrayNumberA"]);
    XCTAssertNil([extractor dictionaryForKey:@"arrayMixA"]);
    XCTAssertTrue([[extractor dictionaryForKey:@"arrayMixA" forceObject:YES] isEqualToDictionary:@{}]);
    
    XCTAssertTrue([[extractor dictionaryForKey:@"dictionaryEmpty"] isEqualToDictionary:@{}]);
    XCTAssertTrue([[extractor dictionaryForKey:@"dictionaryStringStringA"] isEqualToDictionary:(@{ @"one" : @"uno", @"two" : @"duo", @"three" : @"trio" })]);
    XCTAssertTrue([[extractor dictionaryForKey:@"dictionaryStringStringA" forceObject:NO] isEqualToDictionary:(@{ @"one" : @"uno", @"two" : @"duo", @"three" : @"trio" })]);
    XCTAssertTrue([[extractor dictionaryForKey:@"dictionaryStringStringA" forceObject:YES] isEqualToDictionary:(@{ @"one" : @"uno", @"two" : @"duo", @"three" : @"trio" })]);
    XCTAssertTrue([[extractor dictionaryForKey:@"dictionaryStringNumberA"] isEqualToDictionary:(@{ @"first" : @1, @"second" : @2, @"third" : @3 })]);
    XCTAssertTrue([[extractor dictionaryForKey:@"dictionaryNumberStringA"] isEqualToDictionary:(@{ @1 : @"single", @2 : @"double" , @3 : @"triple" })]);
    XCTAssertTrue([[extractor dictionaryForKey:@"dictionaryMixMixA"] isEqualToDictionary:(@{ @"Anna" : @"ant", @5 : @"fizz", @"Tom" : @8, @"no-more" : [NSNull null] })]);
    
    XCTAssertNil([extractor dictionaryForKey:@"garbageA"]);
    XCTAssertNil([extractor dictionaryForKey:@"garbageB"]);
    XCTAssertTrue([[extractor dictionaryForKey:@"garbageB" forceObject:YES] isEqualToDictionary:@{}]);
}

- (void)testExtractorForDictionary
{
    {
        XCTAssertNil([self.emptyExtractor extractorForKey:@"none"]);
        XCTAssertNil([self.emptyExtractor extractorForKey:@"none" forceObject:NO]);
        XCTAssertTrue([[self.emptyExtractor extractorForKey:@"none" forceObject:YES].dictionary isEqualToDictionary:@{}]);
        
        XCTAssertNil([self.extractor extractorForKey:@"none"]);
        XCTAssertNil([self.extractor extractorForKey:@"none" forceObject:NO]);
        XCTAssertTrue([[self.extractor extractorForKey:@"none" forceObject:YES].dictionary isEqualToDictionary:@{}]);
        
        {
            PPExtractor *nonForcedExtractor = [self.extractor extractorForKey:@"dictionaryStringStringA"];
            XCTAssertNotNil(nonForcedExtractor);
            
            PPExtractor *forcedFalseExtractor = [self.extractor extractorForKey:@"dictionaryStringStringA" forceObject:NO];
            XCTAssertNotNil(forcedFalseExtractor);
            
            PPExtractor *forcedTrueExtractor = [self.extractor extractorForKey:@"dictionaryStringStringA" forceObject:YES];
            XCTAssertNotNil(forcedTrueExtractor);
        }
    }
    
    PPExtractor *extractor = self.extractor;
    
    XCTAssertNil([extractor extractorForKey:@"boolA"]);
    XCTAssertNil([extractor extractorForKey:@"boolB"]);
    XCTAssertTrue([[extractor extractorForKey:@"boolB" forceObject:YES].dictionary isEqualToDictionary:@{}]);
    
    XCTAssertNil([extractor extractorForKey:@"numberA"]);
    XCTAssertNil([extractor extractorForKey:@"numberB"]);
    XCTAssertNil([extractor extractorForKey:@"numberC"]);
    XCTAssertNil([extractor extractorForKey:@"numberD"]);
    XCTAssertNil([extractor extractorForKey:@"numberE"]);
    XCTAssertNil([extractor extractorForKey:@"numberF"]);
    XCTAssertNil([extractor extractorForKey:@"numberG"]);
    XCTAssertNil([extractor extractorForKey:@"numberH"]);
    XCTAssertNil([extractor extractorForKey:@"numberI"]);
    XCTAssertNil([extractor extractorForKey:@"numberJ"]);
    XCTAssertTrue([[extractor extractorForKey:@"numberJ" forceObject:YES].dictionary isEqualToDictionary:@{}]);
    
    XCTAssertNil([extractor extractorForKey:@"decimalA"]);
    XCTAssertNil([extractor extractorForKey:@"decimalB"]);
    XCTAssertNil([extractor extractorForKey:@"decimalC"]);
    XCTAssertNil([extractor extractorForKey:@"decimalD"]);
    XCTAssertNil([extractor extractorForKey:@"decimalE"]);
    XCTAssertNil([extractor extractorForKey:@"decimalF"]);
    XCTAssertNil([extractor extractorForKey:@"decimalG"]);
    XCTAssertNil([extractor extractorForKey:@"decimalH"]);
    XCTAssertNil([extractor extractorForKey:@"decimalI"]);
    XCTAssertNil([extractor extractorForKey:@"decimalJ"]);
    XCTAssertNil([extractor extractorForKey:@"decimalK"]);
    XCTAssertTrue([[extractor extractorForKey:@"decimalK" forceObject:YES].dictionary isEqualToDictionary:@{}]);
    
    XCTAssertNil([extractor extractorForKey:@"stringA"]);
    XCTAssertNil([extractor extractorForKey:@"stringB"]);
    XCTAssertNil([extractor extractorForKey:@"stringC"]);
    XCTAssertNil([extractor extractorForKey:@"stringD"]);
    XCTAssertNil([extractor extractorForKey:@"stringE"]);
    XCTAssertNil([extractor extractorForKey:@"stringF"]);
    XCTAssertNil([extractor extractorForKey:@"stringG"]);
    XCTAssertNil([extractor extractorForKey:@"stringH"]);
    XCTAssertNil([extractor extractorForKey:@"stringI"]);
    XCTAssertNil([extractor extractorForKey:@"stringJ"]);
    XCTAssertNil([extractor extractorForKey:@"stringK"]);
    XCTAssertNil([extractor extractorForKey:@"stringL"]);
    XCTAssertNil([extractor extractorForKey:@"stringM"]);
    XCTAssertNil([extractor extractorForKey:@"stringN"]);
    XCTAssertNil([extractor extractorForKey:@"stringO"]);
    XCTAssertNil([extractor extractorForKey:@"stringP"]);
    XCTAssertNil([extractor extractorForKey:@"stringQ"]);
    XCTAssertNil([extractor extractorForKey:@"stringR"]);
    XCTAssertNil([extractor extractorForKey:@"stringS"]);
    XCTAssertNil([extractor extractorForKey:@"stringT"]);
    XCTAssertNil([extractor extractorForKey:@"stringU"]);
    XCTAssertNil([extractor extractorForKey:@"stringV"]);
    XCTAssertNil([extractor extractorForKey:@"stringW"]);
    XCTAssertNil([extractor extractorForKey:@"stringX"]);
    XCTAssertNil([extractor extractorForKey:@"stringY"]);
    XCTAssertNil([extractor extractorForKey:@"stringZ"]);
    XCTAssertTrue([[extractor extractorForKey:@"stringZ" forceObject:YES].dictionary isEqualToDictionary:@{}]);
    
    XCTAssertNil([extractor extractorForKey:@"dateA"]);
    XCTAssertNil([extractor extractorForKey:@"dateB"]);
    XCTAssertNil([extractor extractorForKey:@"dateC"]);
    XCTAssertNil([extractor extractorForKey:@"dateD"]);
    XCTAssertNil([extractor extractorForKey:@"dateE"]);
    XCTAssertNil([extractor extractorForKey:@"dateF"]);
    XCTAssertTrue([[extractor extractorForKey:@"dateF" forceObject:YES].dictionary isEqualToDictionary:@{}]);
    
    XCTAssertNil([extractor extractorForKey:@"nullA"]);
    XCTAssertTrue([[extractor extractorForKey:@"nullA" forceObject:YES].dictionary isEqualToDictionary:@{}]);
    
    XCTAssertNil([extractor extractorForKey:@"arrayEmpty"]);
    XCTAssertNil([extractor extractorForKey:@"arrayStringA"]);
    XCTAssertNil([extractor extractorForKey:@"arrayNumberA"]);
    XCTAssertNil([extractor extractorForKey:@"arrayMixA"]);
    XCTAssertTrue([[extractor extractorForKey:@"arrayMixA" forceObject:YES].dictionary isEqualToDictionary:@{}]);
    
    XCTAssertTrue([[extractor extractorForKey:@"dictionaryEmpty"].dictionary isEqualToDictionary:@{}]);
    XCTAssertTrue([[extractor extractorForKey:@"dictionaryStringStringA"].dictionary isEqualToDictionary:(@{ @"one" : @"uno", @"two" : @"duo", @"three" : @"trio" })]);
    XCTAssertTrue([[extractor extractorForKey:@"dictionaryStringNumberA"].dictionary isEqualToDictionary:(@{ @"first" : @1, @"second" : @2, @"third" : @3 })]);
    XCTAssertTrue([[extractor extractorForKey:@"dictionaryStringNumberA" forceObject:NO].dictionary isEqualToDictionary:(@{ @"first" : @1, @"second" : @2, @"third" : @3 })]);
    XCTAssertTrue([[extractor extractorForKey:@"dictionaryStringNumberA" forceObject:YES].dictionary isEqualToDictionary:(@{ @"first" : @1, @"second" : @2, @"third" : @3 })]);
    XCTAssertTrue([[extractor extractorForKey:@"dictionaryNumberStringA"].dictionary isEqualToDictionary:(@{ @1 : @"single", @2 : @"double" , @3 : @"triple" })]);
    XCTAssertTrue([[extractor extractorForKey:@"dictionaryMixMixA"].dictionary isEqualToDictionary:(@{ @"Anna" : @"ant", @5 : @"fizz", @"Tom" : @8, @"no-more" : [NSNull null] })]);
    
    XCTAssertNil([extractor extractorForKey:@"garbageA"]);
    XCTAssertNil([extractor extractorForKey:@"garbageB"]);
    XCTAssertTrue([[extractor extractorForKey:@"garbageB" forceObject:YES].dictionary isEqualToDictionary:@{}]);
}

#pragma mark - Typed Arrays

- (void)testArrayOfDates
{
    XCTAssertNil([self.emptyExtractor arrayOfDatesForKey:@"none"]);
    XCTAssertNil([self.emptyExtractor arrayOfDatesForKey:@"none" forceArrayObject:NO unconvertibleMarker:nil]);
    XCTAssertNil([self.emptyExtractor arrayOfDatesForKey:@"none" forceArrayObject:NO unconvertibleMarker:[NSNull null]]);
    XCTAssertTrue([[self.emptyExtractor arrayOfDatesForKey:@"none" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertNil([self.extractor arrayOfDatesForKey:@"none"]);
    XCTAssertNil([self.extractor arrayOfDatesForKey:@"none" forceArrayObject:NO unconvertibleMarker:nil]);
    XCTAssertNil([self.extractor arrayOfDatesForKey:@"none" forceArrayObject:NO unconvertibleMarker:[NSNull null]]);
    XCTAssertTrue([[self.extractor arrayOfDatesForKey:@"none" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    
    PPExtractor *extractor = self.extractor;
    NSLocale *locale = [NSLocale systemLocale];
    
    XCTAssertNil([extractor arrayOfDatesForKey:@"boolA"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"boolB"]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"boolB" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayOfDatesForKey:@"numberA"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"numberB"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"numberC"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"numberD"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"numberE"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"numberF"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"numberG"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"numberH"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"numberI"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"numberJ"]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"numberJ" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayOfDatesForKey:@"decimalA"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"decimalB"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"decimalC"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"decimalD"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"decimalE"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"decimalF"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"decimalG"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"decimalH"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"decimalI"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"decimalJ"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"decimalK"]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"decimalK" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringA"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringB"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringC"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringD"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringE"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringF"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringG"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringH"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringI"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringJ"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringK"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringL"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringM"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringN"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringO"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringP"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringQ"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringR"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringS"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringT"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringU"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringV"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringW"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringX"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringY"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"stringZ"]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"stringZ" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayOfDatesForKey:@"dateA"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"dateB"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"dateC"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"dateD"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"dateE"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"dateF"]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"dateF" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayOfDatesForKey:@"nullA"]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"nullA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"arrayEmpty"] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"arrayStringA"] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"arrayNumberA"] isEqualToArray:(@[ [NSDate dateWithTimeIntervalSince1970:5], [NSDate dateWithTimeIntervalSince1970:8], [NSDate dateWithTimeIntervalSince1970:-3], [NSDate dateWithTimeIntervalSince1970:[NSDecimalNumber decimalNumberWithString:@"5.9999" locale:locale].doubleValue], [NSDate dateWithTimeIntervalSince1970:4.2] ])]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"arrayMixA"] isEqualToArray:(@[ [NSDate dateWithTimeIntervalSince1970:9], [NSDate dateWithTimeIntervalSince1970:1], [NSDate dateWithTimeIntervalSince1970:88], [NSDate dateWithTimeIntervalSince1970:2], [NSDate dateWithTimeIntervalSince1970:3.45] ])]);
    
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"arrayEmpty" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"arrayStringA" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"arrayNumberA" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:(@[ [NSDate dateWithTimeIntervalSince1970:5], [NSDate dateWithTimeIntervalSince1970:8], [NSDate dateWithTimeIntervalSince1970:-3], [NSDate dateWithTimeIntervalSince1970:[NSDecimalNumber decimalNumberWithString:@"5.9999" locale:locale].doubleValue], [NSDate dateWithTimeIntervalSince1970:4.2] ])]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"arrayMixA" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:(@[ [NSDate dateWithTimeIntervalSince1970:9], [NSDate dateWithTimeIntervalSince1970:1], [NSDate dateWithTimeIntervalSince1970:88], [NSDate dateWithTimeIntervalSince1970:2], [NSDate dateWithTimeIntervalSince1970:3.45] ])]);
    
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"arrayEmpty" forceArrayObject:NO unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"arrayStringA" forceArrayObject:NO unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"arrayNumberA" forceArrayObject:NO unconvertibleMarker:nil] isEqualToArray:(@[ [NSDate dateWithTimeIntervalSince1970:5], [NSDate dateWithTimeIntervalSince1970:8], [NSDate dateWithTimeIntervalSince1970:-3], [NSDate dateWithTimeIntervalSince1970:[NSDecimalNumber decimalNumberWithString:@"5.9999" locale:locale].doubleValue], [NSDate dateWithTimeIntervalSince1970:4.2] ])]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"arrayMixA" forceArrayObject:NO unconvertibleMarker:nil] isEqualToArray:(@[ [NSDate dateWithTimeIntervalSince1970:9], [NSDate dateWithTimeIntervalSince1970:1], [NSDate dateWithTimeIntervalSince1970:88], [NSDate dateWithTimeIntervalSince1970:2], [NSDate dateWithTimeIntervalSince1970:3.45] ])]);
    
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"arrayEmpty" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"arrayStringA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSNull null], [NSNull null], [NSNull null], [NSNull null] ])]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"arrayNumberA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSDate dateWithTimeIntervalSince1970:5], [NSDate dateWithTimeIntervalSince1970:8], [NSDate dateWithTimeIntervalSince1970:-3], [NSDate dateWithTimeIntervalSince1970:[NSDecimalNumber decimalNumberWithString:@"5.9999" locale:locale].doubleValue], [NSDate dateWithTimeIntervalSince1970:4.2], [NSNull null] ])]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"arrayMixA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSNull null], [NSDate dateWithTimeIntervalSince1970:9], [NSNull null], [NSNull null], [NSDate dateWithTimeIntervalSince1970:1], [NSDate dateWithTimeIntervalSince1970:88], [NSDate dateWithTimeIntervalSince1970:2], [NSNull null], [NSDate dateWithTimeIntervalSince1970:3.45] ])]);
    
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"arrayEmpty" forceArrayObject:NO unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"arrayStringA" forceArrayObject:NO unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSNull null], [NSNull null], [NSNull null], [NSNull null] ])]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"arrayNumberA" forceArrayObject:NO unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSDate dateWithTimeIntervalSince1970:5], [NSDate dateWithTimeIntervalSince1970:8], [NSDate dateWithTimeIntervalSince1970:-3], [NSDate dateWithTimeIntervalSince1970:[NSDecimalNumber decimalNumberWithString:@"5.9999" locale:locale].doubleValue], [NSDate dateWithTimeIntervalSince1970:4.2], [NSNull null] ])]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"arrayMixA" forceArrayObject:NO unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSNull null], [NSDate dateWithTimeIntervalSince1970:9], [NSNull null], [NSNull null], [NSDate dateWithTimeIntervalSince1970:1], [NSDate dateWithTimeIntervalSince1970:88], [NSDate dateWithTimeIntervalSince1970:2], [NSNull null], [NSDate dateWithTimeIntervalSince1970:3.45] ])]);
    
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"arrayEmpty" forceArrayObject:NO unconvertibleMarker:@777] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"arrayStringA" forceArrayObject:NO unconvertibleMarker:@777] isEqualToArray:(@[ @777, @777, @777, @777 ])]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"arrayNumberA" forceArrayObject:NO unconvertibleMarker:@777] isEqualToArray:(@[ [NSDate dateWithTimeIntervalSince1970:5], [NSDate dateWithTimeIntervalSince1970:8], [NSDate dateWithTimeIntervalSince1970:-3], [NSDate dateWithTimeIntervalSince1970:[NSDecimalNumber decimalNumberWithString:@"5.9999" locale:locale].doubleValue], [NSDate dateWithTimeIntervalSince1970:4.2], @777 ])]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"arrayMixA" forceArrayObject:NO unconvertibleMarker:@777] isEqualToArray:(@[ @777, [NSDate dateWithTimeIntervalSince1970:9], @777, @777, [NSDate dateWithTimeIntervalSince1970:1], [NSDate dateWithTimeIntervalSince1970:88], [NSDate dateWithTimeIntervalSince1970:2], @777, [NSDate dateWithTimeIntervalSince1970:3.45] ])]);
    
    XCTAssertNil([extractor arrayOfDatesForKey:@"dictionaryEmpty"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"dictionaryStringStringA"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"dictionaryStringNumberA"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"dictionaryNumberStringA"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"dictionaryMixMixA"]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"dictionaryMixMixA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayOfDatesForKey:@"garbageA"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"garbageA" forceArrayObject:NO unconvertibleMarker:nil]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"garbageA" forceArrayObject:NO unconvertibleMarker:[NSNull null]]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"garbageA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"garbageA" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"garbageB"]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"garbageB" forceArrayObject:NO unconvertibleMarker:nil]);
    XCTAssertNil([extractor arrayOfDatesForKey:@"garbageB" forceArrayObject:NO unconvertibleMarker:[NSNull null]]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"garbageB" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfDatesForKey:@"garbageB" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
}

- (void)testArrayOfNumbers
{
    XCTAssertNil([self.emptyExtractor arrayOfNumbersForKey:@"none"]);
    XCTAssertNil([self.emptyExtractor arrayOfNumbersForKey:@"none" forceArrayObject:NO unconvertibleMarker:nil]);
    XCTAssertNil([self.emptyExtractor arrayOfNumbersForKey:@"none" forceArrayObject:NO unconvertibleMarker:[NSNull null]]);
    XCTAssertTrue([[self.emptyExtractor arrayOfNumbersForKey:@"none" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertNil([self.extractor arrayOfNumbersForKey:@"none"]);
    XCTAssertNil([self.extractor arrayOfNumbersForKey:@"none" forceArrayObject:NO unconvertibleMarker:nil]);
    XCTAssertNil([self.extractor arrayOfNumbersForKey:@"none" forceArrayObject:NO unconvertibleMarker:[NSNull null]]);
    XCTAssertTrue([[self.extractor arrayOfNumbersForKey:@"none" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    
    PPExtractor *extractor = self.extractor;
    
    XCTAssertNil([extractor arrayOfNumbersForKey:@"boolA"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"boolB"]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"boolB" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayOfNumbersForKey:@"numberA"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"numberB"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"numberC"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"numberD"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"numberE"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"numberF"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"numberG"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"numberH"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"numberI"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"numberJ"]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"numberJ" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayOfNumbersForKey:@"decimalA"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"decimalB"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"decimalC"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"decimalD"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"decimalE"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"decimalF"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"decimalG"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"decimalH"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"decimalI"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"decimalJ"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"decimalK"]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"decimalK" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringA"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringB"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringC"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringD"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringE"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringF"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringG"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringH"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringI"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringJ"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringK"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringL"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringM"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringN"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringO"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringP"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringQ"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringR"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringS"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringT"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringU"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringV"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringW"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringX"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringY"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"stringZ"]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"stringZ" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayOfNumbersForKey:@"dateA"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"dateB"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"dateC"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"dateD"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"dateE"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"dateF"]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"dateF" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayOfNumbersForKey:@"nullA"]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"nullA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"arrayEmpty"] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"arrayStringA"] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"arrayNumberA"] isEqualToArray:(@[ @5, @8, @(-3), @5, @4, @0 ])]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"arrayMixA"] isEqualToArray:(@[ @9, @1, @88, @2, @3 ])]);
    
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"arrayEmpty" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"arrayStringA" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"arrayNumberA" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:(@[ @5, @8, @(-3), @5, @4, @0 ])]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"arrayMixA" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:(@[ @9, @1, @88, @2, @3 ])]);
    
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"arrayEmpty" forceArrayObject:NO unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"arrayStringA" forceArrayObject:NO unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"arrayNumberA" forceArrayObject:NO unconvertibleMarker:nil] isEqualToArray:(@[ @5, @8, @(-3), @5, @4, @0 ])]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"arrayMixA" forceArrayObject:NO unconvertibleMarker:nil] isEqualToArray:(@[ @9, @1, @88, @2, @3 ])]);
    
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"arrayEmpty" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"arrayStringA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSNull null], [NSNull null], [NSNull null], [NSNull null] ])]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"arrayNumberA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ @5, @8, @(-3), @5, @4, @0 ])]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"arrayMixA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSNull null], @9, [NSNull null], [NSNull null], @1, @88, @2, [NSNull null], @3 ])]);
    
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"arrayEmpty" forceArrayObject:NO unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"arrayStringA" forceArrayObject:NO unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSNull null], [NSNull null], [NSNull null], [NSNull null] ])]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"arrayNumberA" forceArrayObject:NO unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ @5, @8, @(-3), @5, @4, @0 ])]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"arrayMixA" forceArrayObject:NO unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSNull null], @9, [NSNull null], [NSNull null], @1, @88, @2, [NSNull null], @3 ])]);
    
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"arrayEmpty" forceArrayObject:NO unconvertibleMarker:@777] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"arrayStringA" forceArrayObject:NO unconvertibleMarker:@777] isEqualToArray:(@[ @777, @777, @777, @777 ])]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"arrayNumberA" forceArrayObject:NO unconvertibleMarker:@777] isEqualToArray:(@[ @5, @8, @(-3), @5, @4, @0 ])]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"arrayMixA" forceArrayObject:NO unconvertibleMarker:@777] isEqualToArray:(@[ @777, @9, @777, @777, @1, @88, @2, @777, @3 ])]);
    
    XCTAssertNil([extractor arrayOfNumbersForKey:@"dictionaryEmpty"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"dictionaryStringStringA"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"dictionaryStringNumberA"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"dictionaryNumberStringA"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"dictionaryMixMixA"]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"dictionaryMixMixA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayOfNumbersForKey:@"garbageA"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"garbageA" forceArrayObject:NO unconvertibleMarker:nil]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"garbageA" forceArrayObject:NO unconvertibleMarker:[NSNull null]]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"garbageA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"garbageA" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"garbageB"]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"garbageB" forceArrayObject:NO unconvertibleMarker:nil]);
    XCTAssertNil([extractor arrayOfNumbersForKey:@"garbageB" forceArrayObject:NO unconvertibleMarker:[NSNull null]]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"garbageB" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfNumbersForKey:@"garbageB" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
}

- (void)testArrayOfStrings
{
    XCTAssertNil([self.emptyExtractor arrayOfStringsForKey:@"none"]);
    XCTAssertNil([self.emptyExtractor arrayOfStringsForKey:@"none" forceArrayObject:NO unconvertibleMarker:nil]);
    XCTAssertNil([self.emptyExtractor arrayOfStringsForKey:@"none" forceArrayObject:NO unconvertibleMarker:[NSNull null]]);
    XCTAssertTrue([[self.emptyExtractor arrayOfStringsForKey:@"none" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertTrue([[self.emptyExtractor arrayOfStringsForKey:@"none" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    XCTAssertNil([self.extractor arrayOfStringsForKey:@"none"]);
    XCTAssertNil([self.extractor arrayOfStringsForKey:@"none" forceArrayObject:NO unconvertibleMarker:nil]);
    XCTAssertNil([self.extractor arrayOfStringsForKey:@"none" forceArrayObject:NO unconvertibleMarker:[NSNull null]]);
    XCTAssertTrue([[self.extractor arrayOfStringsForKey:@"none" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertTrue([[self.extractor arrayOfStringsForKey:@"none" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    PPExtractor *extractor = self.extractor;
    
    XCTAssertNil([extractor arrayOfStringsForKey:@"boolA"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"boolB"]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"boolB" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayOfStringsForKey:@"numberA"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"numberB"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"numberC"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"numberD"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"numberE"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"numberF"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"numberG"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"numberH"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"numberI"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"numberJ"]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"numberJ" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayOfStringsForKey:@"decimalA"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"decimalB"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"decimalC"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"decimalD"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"decimalE"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"decimalF"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"decimalG"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"decimalH"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"decimalI"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"decimalJ"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"decimalK"]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"decimalK" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringA"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringB"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringC"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringD"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringE"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringF"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringG"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringH"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringI"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringJ"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringK"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringL"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringM"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringN"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringO"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringP"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringQ"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringR"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringS"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringT"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringU"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringV"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringW"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringX"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringY"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"stringZ"]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"stringZ" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayOfStringsForKey:@"dateA"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"dateB"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"dateC"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"dateD"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"dateE"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"dateF"]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"dateF" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayOfStringsForKey:@"nullA"]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"nullA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"arrayEmpty"] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"arrayStringA"] isEqualToArray:(@[ @"apple", @"box", @"cat", @"dog" ])]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"arrayNumberA"] isEqualToArray:(@[ @"5", @"8", @"-3", @"5.9999", @"4.2", @"0" ])]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"arrayMixA"] isEqualToArray:(@[ @"pizza", @"9", @"pie", @"1", @"88", @"2", @"", @"3.45" ])]);
    
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"arrayEmpty" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"arrayStringA" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:(@[ @"apple", @"box", @"cat", @"dog" ])]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"arrayNumberA" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:(@[ @"5", @"8", @"-3", @"5.9999", @"4.2", @"0" ])]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"arrayMixA" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:(@[ @"pizza", @"9", @"pie", @"1", @"88", @"2", @"", @"3.45" ])]);
    
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"arrayEmpty" forceArrayObject:NO unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"arrayStringA" forceArrayObject:NO unconvertibleMarker:nil] isEqualToArray:(@[ @"apple", @"box", @"cat", @"dog" ])]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"arrayNumberA" forceArrayObject:NO unconvertibleMarker:nil] isEqualToArray:(@[ @"5", @"8", @"-3", @"5.9999", @"4.2", @"0" ])]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"arrayMixA" forceArrayObject:NO unconvertibleMarker:nil] isEqualToArray:(@[ @"pizza", @"9", @"pie", @"1", @"88", @"2", @"", @"3.45" ])]);
    
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"arrayEmpty" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"arrayStringA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ @"apple", @"box", @"cat", @"dog" ])]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"arrayNumberA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ @"5", @"8", @"-3", @"5.9999", @"4.2", @"0" ])]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"arrayMixA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ @"pizza", @"9", @"pie", [NSNull null], @"1", @"88", @"2", @"", @"3.45" ])]);
    
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"arrayEmpty" forceArrayObject:NO unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"arrayStringA" forceArrayObject:NO unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ @"apple", @"box", @"cat", @"dog" ])]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"arrayNumberA" forceArrayObject:NO unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ @"5", @"8", @"-3", @"5.9999", @"4.2", @"0" ])]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"arrayMixA" forceArrayObject:NO unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ @"pizza", @"9", @"pie", [NSNull null], @"1", @"88", @"2", @"", @"3.45" ])]);
    
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"arrayEmpty" forceArrayObject:NO unconvertibleMarker:@"777"] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"arrayStringA" forceArrayObject:NO unconvertibleMarker:@"777"] isEqualToArray:(@[ @"apple", @"box", @"cat", @"dog" ])]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"arrayNumberA" forceArrayObject:NO unconvertibleMarker:@"777"] isEqualToArray:(@[ @"5", @"8", @"-3", @"5.9999", @"4.2", @"0" ])]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"arrayMixA" forceArrayObject:NO unconvertibleMarker:@"777"] isEqualToArray:(@[ @"pizza", @"9", @"pie", @"777", @"1", @"88", @"2", @"", @"3.45" ])]);
    
    XCTAssertNil([extractor arrayOfStringsForKey:@"dictionaryEmpty"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"dictionaryStringStringA"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"dictionaryStringNumberA"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"dictionaryNumberStringA"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"dictionaryMixMixA"]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"dictionaryMixMixA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayOfStringsForKey:@"garbageA"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"garbageA" forceArrayObject:NO unconvertibleMarker:nil]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"garbageA" forceArrayObject:NO unconvertibleMarker:[NSNull null]]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"garbageA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"garbageA" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"garbageB"]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"garbageB" forceArrayObject:NO unconvertibleMarker:nil]);
    XCTAssertNil([extractor arrayOfStringsForKey:@"garbageB" forceArrayObject:NO unconvertibleMarker:[NSNull null]]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"garbageB" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfStringsForKey:@"garbageB" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
}

- (void)testArrayOfDecimalNumbers
{
    XCTAssertNil([self.emptyExtractor arrayOfDecimalNumbersForKey:@"none"]);
    XCTAssertNil([self.emptyExtractor arrayOfDecimalNumbersForKey:@"none" forceArrayObject:NO unconvertibleMarker:nil]);
    XCTAssertNil([self.emptyExtractor arrayOfDecimalNumbersForKey:@"none" forceArrayObject:NO unconvertibleMarker:[NSNull null]]);
    XCTAssertTrue([[self.emptyExtractor arrayOfDecimalNumbersForKey:@"none" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertTrue([[self.emptyExtractor arrayOfDecimalNumbersForKey:@"none" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    XCTAssertNil([self.extractor arrayOfDecimalNumbersForKey:@"none"]);
    XCTAssertNil([self.extractor arrayOfDecimalNumbersForKey:@"none" forceArrayObject:NO unconvertibleMarker:nil]);
    XCTAssertNil([self.extractor arrayOfDecimalNumbersForKey:@"none" forceArrayObject:NO unconvertibleMarker:[NSNull null]]);
    XCTAssertTrue([[self.extractor arrayOfDecimalNumbersForKey:@"none" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertTrue([[self.extractor arrayOfDecimalNumbersForKey:@"none" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    PPExtractor *extractor = self.extractor;
    NSLocale *locale = [NSLocale systemLocale];
    
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"boolA"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"boolB"]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"boolB" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"numberA"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"numberB"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"numberC"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"numberD"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"numberE"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"numberF"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"numberG"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"numberH"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"numberI"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"numberJ"]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"numberJ" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"decimalA"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"decimalB"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"decimalC"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"decimalD"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"decimalE"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"decimalF"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"decimalG"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"decimalH"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"decimalI"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"decimalJ"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"decimalK"]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"decimalK" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringA"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringB"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringC"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringD"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringE"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringF"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringG"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringH"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringI"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringJ"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringK"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringL"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringM"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringN"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringO"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringP"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringQ"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringR"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringS"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringT"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringU"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringV"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringW"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringX"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringY"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"stringZ"]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"stringZ" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"dateA"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"dateB"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"dateC"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"dateD"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"dateE"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"dateF"]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"dateF" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"nullA"]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"nullA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"arrayEmpty"] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"arrayStringA"] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"arrayNumberA"] isEqualToArray:(@[ [NSDecimalNumber decimalNumberWithString:@"5" locale:locale], [NSDecimalNumber decimalNumberWithString:@"8" locale:locale], [NSDecimalNumber decimalNumberWithString:@"-3" locale:locale], [NSDecimalNumber decimalNumberWithString:@"5.9999" locale:locale], [NSDecimalNumber decimalNumberWithString:@"4.2" locale:locale], [NSDecimalNumber decimalNumberWithString:@"0" locale:locale] ])]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"arrayMixA"] isEqualToArray:(@[ [NSDecimalNumber decimalNumberWithString:@"9" locale:locale], [NSDecimalNumber decimalNumberWithString:@"1" locale:locale], [NSDecimalNumber decimalNumberWithString:@"88" locale:locale], [NSDecimalNumber decimalNumberWithString:@"2" locale:locale], [NSDecimalNumber decimalNumberWithString:@"3.45" locale:locale] ])]);
    
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"arrayEmpty" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"arrayStringA" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"arrayNumberA" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:(@[ [NSDecimalNumber decimalNumberWithString:@"5" locale:locale], [NSDecimalNumber decimalNumberWithString:@"8" locale:locale], [NSDecimalNumber decimalNumberWithString:@"-3" locale:locale], [NSDecimalNumber decimalNumberWithString:@"5.9999" locale:locale], [NSDecimalNumber decimalNumberWithString:@"4.2" locale:locale], [NSDecimalNumber decimalNumberWithString:@"0" locale:locale] ])]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"arrayMixA" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:(@[ [NSDecimalNumber decimalNumberWithString:@"9" locale:locale], [NSDecimalNumber decimalNumberWithString:@"1" locale:locale], [NSDecimalNumber decimalNumberWithString:@"88" locale:locale], [NSDecimalNumber decimalNumberWithString:@"2" locale:locale], [NSDecimalNumber decimalNumberWithString:@"3.45" locale:locale] ])]);
    
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"arrayEmpty" forceArrayObject:NO unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"arrayStringA" forceArrayObject:NO unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"arrayNumberA" forceArrayObject:NO unconvertibleMarker:nil] isEqualToArray:(@[ [NSDecimalNumber decimalNumberWithString:@"5" locale:locale], [NSDecimalNumber decimalNumberWithString:@"8" locale:locale], [NSDecimalNumber decimalNumberWithString:@"-3" locale:locale], [NSDecimalNumber decimalNumberWithString:@"5.9999" locale:locale], [NSDecimalNumber decimalNumberWithString:@"4.2" locale:locale], [NSDecimalNumber decimalNumberWithString:@"0" locale:locale] ])]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"arrayMixA" forceArrayObject:NO unconvertibleMarker:nil] isEqualToArray:(@[ [NSDecimalNumber decimalNumberWithString:@"9" locale:locale], [NSDecimalNumber decimalNumberWithString:@"1" locale:locale], [NSDecimalNumber decimalNumberWithString:@"88" locale:locale], [NSDecimalNumber decimalNumberWithString:@"2" locale:locale], [NSDecimalNumber decimalNumberWithString:@"3.45" locale:locale] ])]);
    
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"arrayEmpty" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"arrayStringA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSNull null], [NSNull null], [NSNull null], [NSNull null] ])]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"arrayNumberA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSDecimalNumber decimalNumberWithString:@"5" locale:locale], [NSDecimalNumber decimalNumberWithString:@"8" locale:locale], [NSDecimalNumber decimalNumberWithString:@"-3" locale:locale], [NSDecimalNumber decimalNumberWithString:@"5.9999" locale:locale], [NSDecimalNumber decimalNumberWithString:@"4.2" locale:locale], [NSDecimalNumber decimalNumberWithString:@"0" locale:locale] ])]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"arrayMixA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSNull null], [NSDecimalNumber decimalNumberWithString:@"9" locale:locale], [NSNull null], [NSNull null], [NSDecimalNumber decimalNumberWithString:@"1" locale:locale], [NSDecimalNumber decimalNumberWithString:@"88" locale:locale], [NSDecimalNumber decimalNumberWithString:@"2" locale:locale], [NSNull null], [NSDecimalNumber decimalNumberWithString:@"3.45" locale:locale] ])]);
    
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"arrayEmpty" forceArrayObject:NO unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"arrayStringA" forceArrayObject:NO unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSNull null], [NSNull null], [NSNull null], [NSNull null] ])]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"arrayNumberA" forceArrayObject:NO unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSDecimalNumber decimalNumberWithString:@"5" locale:locale], [NSDecimalNumber decimalNumberWithString:@"8" locale:locale], [NSDecimalNumber decimalNumberWithString:@"-3" locale:locale], [NSDecimalNumber decimalNumberWithString:@"5.9999" locale:locale], [NSDecimalNumber decimalNumberWithString:@"4.2" locale:locale], [NSDecimalNumber decimalNumberWithString:@"0" locale:locale] ])]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"arrayMixA" forceArrayObject:NO unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSNull null], [NSDecimalNumber decimalNumberWithString:@"9" locale:locale], [NSNull null], [NSNull null], [NSDecimalNumber decimalNumberWithString:@"1" locale:locale], [NSDecimalNumber decimalNumberWithString:@"88" locale:locale], [NSDecimalNumber decimalNumberWithString:@"2" locale:locale], [NSNull null], [NSDecimalNumber decimalNumberWithString:@"3.45" locale:locale] ])]);
    
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"arrayEmpty" forceArrayObject:NO unconvertibleMarker:@777] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"arrayStringA" forceArrayObject:NO unconvertibleMarker:@777] isEqualToArray:(@[ @777, @777, @777, @777 ])]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"arrayNumberA" forceArrayObject:NO unconvertibleMarker:@777] isEqualToArray:(@[ [NSDecimalNumber decimalNumberWithString:@"5" locale:locale], [NSDecimalNumber decimalNumberWithString:@"8" locale:locale], [NSDecimalNumber decimalNumberWithString:@"-3" locale:locale], [NSDecimalNumber decimalNumberWithString:@"5.9999" locale:locale], [NSDecimalNumber decimalNumberWithString:@"4.2" locale:locale], [NSDecimalNumber decimalNumberWithString:@"0" locale:locale] ])]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"arrayMixA" forceArrayObject:NO unconvertibleMarker:@777] isEqualToArray:(@[ @777, [NSDecimalNumber decimalNumberWithString:@"9" locale:locale], @777, @777, [NSDecimalNumber decimalNumberWithString:@"1" locale:locale], [NSDecimalNumber decimalNumberWithString:@"88" locale:locale], [NSDecimalNumber decimalNumberWithString:@"2" locale:locale], @777, [NSDecimalNumber decimalNumberWithString:@"3.45" locale:locale] ])]);
    
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"dictionaryEmpty"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"dictionaryStringStringA"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"dictionaryStringNumberA"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"dictionaryNumberStringA"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"dictionaryMixMixA"]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"dictionaryMixMixA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"garbageA"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"garbageA" forceArrayObject:NO unconvertibleMarker:nil]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"garbageA" forceArrayObject:NO unconvertibleMarker:[NSNull null]]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"garbageA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"garbageA" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"garbageB"]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"garbageB" forceArrayObject:NO unconvertibleMarker:nil]);
    XCTAssertNil([extractor arrayOfDecimalNumbersForKey:@"garbageB" forceArrayObject:NO unconvertibleMarker:[NSNull null]]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"garbageB" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    XCTAssertTrue([[extractor arrayOfDecimalNumbersForKey:@"garbageB" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
}

- (void)testArrayOfArrays
{
    XCTAssertNil([self.emptyExtractor arrayOfArraysForKey:@"none"]);
    XCTAssertNil([self.emptyExtractor arrayOfArraysForKey:@"none" forceArrayObject:NO unconvertibleMarker:nil]);
    XCTAssertNil([self.emptyExtractor arrayOfArraysForKey:@"none" forceArrayObject:NO unconvertibleMarker:[NSNull null]]);
    XCTAssertTrue([[self.emptyExtractor arrayOfArraysForKey:@"none" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertTrue([[self.emptyExtractor arrayOfArraysForKey:@"none" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    XCTAssertNil([self.extractor arrayOfArraysForKey:@"none"]);
    XCTAssertNil([self.extractor arrayOfArraysForKey:@"none" forceArrayObject:NO unconvertibleMarker:nil]);
    XCTAssertNil([self.extractor arrayOfArraysForKey:@"none" forceArrayObject:NO unconvertibleMarker:[NSNull null]]);
    XCTAssertTrue([[self.extractor arrayOfArraysForKey:@"none" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertTrue([[self.extractor arrayOfArraysForKey:@"none" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    {
        PPExtractor *extractor = self.extractor;
        
        XCTAssertNil([extractor arrayOfArraysForKey:@"boolA"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"boolB"]);
        XCTAssertTrue([[extractor arrayOfArraysForKey:@"boolB" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
        
        XCTAssertNil([extractor arrayOfArraysForKey:@"numberA"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"numberB"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"numberC"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"numberD"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"numberE"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"numberF"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"numberG"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"numberH"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"numberI"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"numberJ"]);
        XCTAssertTrue([[extractor arrayOfArraysForKey:@"numberJ" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
        
        XCTAssertNil([extractor arrayOfArraysForKey:@"decimalA"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"decimalB"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"decimalC"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"decimalD"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"decimalE"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"decimalF"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"decimalG"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"decimalH"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"decimalI"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"decimalJ"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"decimalK"]);
        XCTAssertTrue([[extractor arrayOfArraysForKey:@"decimalK" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
        
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringA"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringB"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringC"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringD"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringE"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringF"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringG"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringH"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringI"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringJ"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringK"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringL"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringM"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringN"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringO"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringP"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringQ"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringR"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringS"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringT"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringU"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringV"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringW"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringX"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringY"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"stringZ"]);
        XCTAssertTrue([[extractor arrayOfArraysForKey:@"stringZ" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
        
        XCTAssertNil([extractor arrayOfArraysForKey:@"dateA"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"dateB"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"dateC"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"dateD"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"dateE"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"dateF"]);
        XCTAssertTrue([[extractor arrayOfArraysForKey:@"dateF" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
        
        XCTAssertNil([extractor arrayOfArraysForKey:@"nullA"]);
        XCTAssertTrue([[extractor arrayOfArraysForKey:@"nullA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
        
        XCTAssertTrue([[extractor arrayOfArraysForKey:@"arrayEmpty"] isEqualToArray:@[]]);
        XCTAssertTrue([[extractor arrayOfArraysForKey:@"arrayStringA"] isEqualToArray:@[]]);
        XCTAssertTrue([[extractor arrayOfArraysForKey:@"arrayNumberA"] isEqualToArray:@[]]);
        XCTAssertTrue([[extractor arrayOfArraysForKey:@"arrayMixA"] isEqualToArray:@[]]);
        
        XCTAssertTrue([[extractor arrayOfArraysForKey:@"arrayEmpty" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
        XCTAssertTrue([[extractor arrayOfArraysForKey:@"arrayStringA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSNull null], [NSNull null], [NSNull null], [NSNull null] ])]);
        XCTAssertTrue([[extractor arrayOfArraysForKey:@"arrayNumberA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null] ])]);
        XCTAssertTrue([[extractor arrayOfArraysForKey:@"arrayMixA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null] ])]);
        
        XCTAssertNil([extractor arrayOfArraysForKey:@"dictionaryEmpty"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"dictionaryStringStringA"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"dictionaryStringNumberA"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"dictionaryNumberStringA"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"dictionaryMixMixA"]);
        XCTAssertTrue([[extractor arrayOfArraysForKey:@"dictionaryMixMixA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
        
        XCTAssertNil([extractor arrayOfArraysForKey:@"garbageA"]);
        XCTAssertNil([extractor arrayOfArraysForKey:@"garbageB"]);
        XCTAssertTrue([[extractor arrayOfArraysForKey:@"garbageB" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    }
    
    {
        NSArray *oneToThreeArray = @[ @1, @2, @3 ];
        NSArray *abcdArray = @[ @"a", @"b", @"c", @"d" ];
        NSArray *wxyzArray = @[ @"w", @"x", @"y", @"z" ];
        
        NSArray *arrayOfArraysA = @[ oneToThreeArray, abcdArray ];
        NSArray *arrayOfMixedA = @[ @99, wxyzArray, [NSNull null], @{ @"test" : @"case" } ];
        
        NSDictionary *dictionary = @{
                                     @"arrayOfArraysA" : arrayOfArraysA,
                                     @"arrayOfMixedA" : arrayOfMixedA
                                     };
        PPExtractor *extractor = [PPExtractor extractorWithDictionary:dictionary];
        
        XCTAssertTrue([[extractor arrayOfArraysForKey:@"arrayOfArraysA"] isEqualToArray:arrayOfArraysA]);
        XCTAssertTrue([[extractor arrayOfArraysForKey:@"arrayOfMixedA"] isEqualToArray:@[ wxyzArray ]]);
        
        NSArray *tArray = @[ @"T" ];
        XCTAssertTrue([[extractor arrayOfArraysForKey:@"arrayOfArraysA" forceArrayObject:NO unconvertibleMarker:tArray] isEqualToArray:arrayOfArraysA]);
        XCTAssertTrue([[extractor arrayOfArraysForKey:@"arrayOfMixedA" forceArrayObject:NO unconvertibleMarker:tArray] isEqualToArray:(@[ tArray, wxyzArray, tArray, tArray ])]);
        
        XCTAssertTrue([[extractor arrayOfArraysForKey:@"arrayOfArraysA" forceArrayObject:YES unconvertibleMarker:tArray] isEqualToArray:arrayOfArraysA]);
        XCTAssertTrue([[extractor arrayOfArraysForKey:@"arrayOfMixedA" forceArrayObject:YES unconvertibleMarker:tArray] isEqualToArray:(@[ tArray, wxyzArray, tArray, tArray ])]);
        
        XCTAssertTrue([[extractor arrayOfArraysForKey:@"arrayOfArraysA" forceArrayObject:NO unconvertibleMarker:[NSNull null]] isEqualToArray:arrayOfArraysA]);
        XCTAssertTrue([[extractor arrayOfArraysForKey:@"arrayOfMixedA" forceArrayObject:NO unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSNull null], wxyzArray, [NSNull null], [NSNull null] ])]);
    }
}

- (void)testArrayOfDictionaries
{
    XCTAssertNil([self.emptyExtractor arrayOfDictionariesForKey:@"none"]);
    XCTAssertNil([self.emptyExtractor arrayOfDictionariesForKey:@"none" forceArrayObject:NO unconvertibleMarker:nil]);
    XCTAssertNil([self.emptyExtractor arrayOfDictionariesForKey:@"none" forceArrayObject:NO unconvertibleMarker:[NSNull null]]);
    XCTAssertTrue([[self.emptyExtractor arrayOfDictionariesForKey:@"none" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertTrue([[self.emptyExtractor arrayOfDictionariesForKey:@"none" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    XCTAssertNil([self.extractor arrayOfDictionariesForKey:@"none"]);
    XCTAssertNil([self.extractor arrayOfDictionariesForKey:@"none" forceArrayObject:NO unconvertibleMarker:nil]);
    XCTAssertNil([self.extractor arrayOfDictionariesForKey:@"none" forceArrayObject:NO unconvertibleMarker:[NSNull null]]);
    XCTAssertTrue([[self.extractor arrayOfDictionariesForKey:@"none" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertTrue([[self.extractor arrayOfDictionariesForKey:@"none" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    {
        PPExtractor *extractor = self.extractor;
        
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"boolA"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"boolB"]);
        XCTAssertTrue([[extractor arrayOfDictionariesForKey:@"boolB" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
        
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"numberA"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"numberB"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"numberC"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"numberD"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"numberE"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"numberF"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"numberG"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"numberH"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"numberI"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"numberJ"]);
        XCTAssertTrue([[extractor arrayOfDictionariesForKey:@"numberJ" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
        
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"decimalA"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"decimalB"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"decimalC"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"decimalD"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"decimalE"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"decimalF"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"decimalG"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"decimalH"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"decimalI"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"decimalJ"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"decimalK"]);
        XCTAssertTrue([[extractor arrayOfDictionariesForKey:@"decimalK" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
        
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringA"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringB"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringC"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringD"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringE"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringF"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringG"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringH"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringI"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringJ"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringK"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringL"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringM"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringN"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringO"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringP"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringQ"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringR"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringS"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringT"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringU"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringV"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringW"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringX"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringY"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"stringZ"]);
        XCTAssertTrue([[extractor arrayOfDictionariesForKey:@"stringZ" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
        
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"dateA"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"dateB"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"dateC"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"dateD"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"dateE"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"dateF"]);
        XCTAssertTrue([[extractor arrayOfDictionariesForKey:@"dateF" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
        
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"nullA"]);
        XCTAssertTrue([[extractor arrayOfDictionariesForKey:@"nullA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
        
        XCTAssertTrue([[extractor arrayOfDictionariesForKey:@"arrayEmpty"] isEqualToArray:@[]]);
        XCTAssertTrue([[extractor arrayOfDictionariesForKey:@"arrayStringA"] isEqualToArray:@[]]);
        XCTAssertTrue([[extractor arrayOfDictionariesForKey:@"arrayNumberA"] isEqualToArray:@[]]);
        XCTAssertTrue([[extractor arrayOfDictionariesForKey:@"arrayMixA"] isEqualToArray:@[]]);
        
        XCTAssertTrue([[extractor arrayOfDictionariesForKey:@"arrayEmpty" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
        XCTAssertTrue([[extractor arrayOfDictionariesForKey:@"arrayStringA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSNull null], [NSNull null], [NSNull null], [NSNull null] ])]);
        XCTAssertTrue([[extractor arrayOfDictionariesForKey:@"arrayNumberA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null] ])]);
        XCTAssertTrue([[extractor arrayOfDictionariesForKey:@"arrayMixA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null] ])]);
        
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"dictionaryEmpty"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"dictionaryStringStringA"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"dictionaryStringNumberA"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"dictionaryNumberStringA"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"dictionaryMixMixA"]);
        XCTAssertTrue([[extractor arrayOfDictionariesForKey:@"dictionaryMixMixA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
        
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"garbageA"]);
        XCTAssertNil([extractor arrayOfDictionariesForKey:@"garbageB"]);
        XCTAssertTrue([[extractor arrayOfDictionariesForKey:@"garbageB" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    }
    
    {
        NSDictionary *oneToThreeFourDictionary = @{ @"one" : @"two", @"three" : @"four" };
        NSDictionary *abcdDictionary = @{ @"a" : @"b", @"c" : @"d" };
        NSDictionary *wxyzDictionary = @{ @"w" : @"x", @"y" : @"z" };
        
        NSArray *arrayOfDictionariesA = @[ oneToThreeFourDictionary, abcdDictionary ];
        NSArray *arrayOfMixedA = @[ @99, wxyzDictionary, [NSNull null], @[ @1, @2, @3 ] ];
        
        NSDictionary *dictionary = @{
                                     @"arrayOfDictionariesA" : arrayOfDictionariesA,
                                     @"arrayOfMixedA" : arrayOfMixedA
                                     };
        PPExtractor *extractor = [PPExtractor extractorWithDictionary:dictionary];
        
        XCTAssertTrue([[extractor arrayOfDictionariesForKey:@"arrayOfDictionariesA"] isEqualToArray:arrayOfDictionariesA]);
        XCTAssertTrue([[extractor arrayOfDictionariesForKey:@"arrayOfMixedA"] isEqualToArray:@[ wxyzDictionary ]]);
        
        NSDictionary *tDictionary = @{ @"T" : @"t" };
        XCTAssertTrue([[extractor arrayOfDictionariesForKey:@"arrayOfDictionariesA" forceArrayObject:NO unconvertibleMarker:tDictionary] isEqualToArray:arrayOfDictionariesA]);
        XCTAssertTrue([[extractor arrayOfDictionariesForKey:@"arrayOfMixedA" forceArrayObject:NO unconvertibleMarker:tDictionary] isEqualToArray:(@[ tDictionary, wxyzDictionary, tDictionary, tDictionary ])]);
        
        XCTAssertTrue([[extractor arrayOfDictionariesForKey:@"arrayOfDictionariesA" forceArrayObject:YES unconvertibleMarker:tDictionary] isEqualToArray:arrayOfDictionariesA]);
        XCTAssertTrue([[extractor arrayOfDictionariesForKey:@"arrayOfMixedA" forceArrayObject:YES unconvertibleMarker:tDictionary] isEqualToArray:(@[ tDictionary, wxyzDictionary, tDictionary, tDictionary ])]);
        
        XCTAssertTrue([[extractor arrayOfDictionariesForKey:@"arrayOfDictionariesA" forceArrayObject:NO unconvertibleMarker:[NSNull null]] isEqualToArray:arrayOfDictionariesA]);
        XCTAssertTrue([[extractor arrayOfDictionariesForKey:@"arrayOfMixedA" forceArrayObject:NO unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSNull null], wxyzDictionary, [NSNull null], [NSNull null] ])]);
    }
}

- (void)testArrayOfExtractors
{
    XCTAssertNil([self.emptyExtractor arrayOfExtractorsForKey:@"none"]);
    XCTAssertNil([self.emptyExtractor arrayOfExtractorsForKey:@"none" forceArrayObject:NO unconvertibleMarker:nil]);
    XCTAssertNil([self.emptyExtractor arrayOfExtractorsForKey:@"none" forceArrayObject:NO unconvertibleMarker:[NSNull null]]);
    XCTAssertTrue([[self.emptyExtractor arrayOfExtractorsForKey:@"none" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertTrue([[self.emptyExtractor arrayOfExtractorsForKey:@"none" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    XCTAssertNil([self.extractor arrayOfExtractorsForKey:@"none"]);
    XCTAssertNil([self.extractor arrayOfExtractorsForKey:@"none" forceArrayObject:NO unconvertibleMarker:nil]);
    XCTAssertNil([self.extractor arrayOfExtractorsForKey:@"none" forceArrayObject:NO unconvertibleMarker:[NSNull null]]);
    XCTAssertTrue([[self.extractor arrayOfExtractorsForKey:@"none" forceArrayObject:YES unconvertibleMarker:nil] isEqualToArray:@[]]);
    XCTAssertTrue([[self.extractor arrayOfExtractorsForKey:@"none" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    
    {
        PPExtractor *extractor = self.extractor;
        
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"boolA"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"boolB"]);
        XCTAssertTrue([[extractor arrayOfExtractorsForKey:@"boolB" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
        
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"numberA"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"numberB"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"numberC"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"numberD"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"numberE"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"numberF"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"numberG"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"numberH"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"numberI"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"numberJ"]);
        XCTAssertTrue([[extractor arrayOfExtractorsForKey:@"numberJ" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
        
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"decimalA"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"decimalB"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"decimalC"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"decimalD"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"decimalE"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"decimalF"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"decimalG"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"decimalH"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"decimalI"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"decimalJ"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"decimalK"]);
        XCTAssertTrue([[extractor arrayOfExtractorsForKey:@"decimalK" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
        
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringA"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringB"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringC"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringD"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringE"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringF"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringG"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringH"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringI"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringJ"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringK"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringL"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringM"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringN"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringO"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringP"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringQ"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringR"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringS"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringT"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringU"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringV"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringW"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringX"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringY"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"stringZ"]);
        XCTAssertTrue([[extractor arrayOfExtractorsForKey:@"stringZ" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
        
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"dateA"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"dateB"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"dateC"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"dateD"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"dateE"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"dateF"]);
        XCTAssertTrue([[extractor arrayOfExtractorsForKey:@"dateF" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
        
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"nullA"]);
        XCTAssertTrue([[extractor arrayOfExtractorsForKey:@"nullA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
        
        XCTAssertTrue([[extractor arrayOfExtractorsForKey:@"arrayEmpty"] isEqualToArray:@[]]);
        XCTAssertTrue([[extractor arrayOfExtractorsForKey:@"arrayStringA"] isEqualToArray:@[]]);
        XCTAssertTrue([[extractor arrayOfExtractorsForKey:@"arrayNumberA"] isEqualToArray:@[]]);
        XCTAssertTrue([[extractor arrayOfExtractorsForKey:@"arrayMixA"] isEqualToArray:@[]]);
        
        XCTAssertTrue([[extractor arrayOfExtractorsForKey:@"arrayEmpty" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
        XCTAssertTrue([[extractor arrayOfExtractorsForKey:@"arrayStringA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSNull null], [NSNull null], [NSNull null], [NSNull null] ])]);
        XCTAssertTrue([[extractor arrayOfExtractorsForKey:@"arrayNumberA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null] ])]);
        XCTAssertTrue([[extractor arrayOfExtractorsForKey:@"arrayMixA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:(@[ [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null] ])]);
        
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"dictionaryEmpty"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"dictionaryStringStringA"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"dictionaryStringNumberA"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"dictionaryNumberStringA"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"dictionaryMixMixA"]);
        XCTAssertTrue([[extractor arrayOfExtractorsForKey:@"dictionaryMixMixA" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
        
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"garbageA"]);
        XCTAssertNil([extractor arrayOfExtractorsForKey:@"garbageB"]);
        XCTAssertTrue([[extractor arrayOfExtractorsForKey:@"garbageB" forceArrayObject:YES unconvertibleMarker:[NSNull null]] isEqualToArray:@[]]);
    }
    
    {
        NSDictionary *oneTwoThreeFourDictionary = @{ @"one" : @"two", @"three" : @"four" };
        NSDictionary *abcdDictionary = @{ @"a" : @"b", @"c" : @"d" };
        NSDictionary *wxyzDictionary = @{ @"w" : @"x", @"y" : @"z" };
        
        NSArray *arrayOfDictionariesA = @[ oneTwoThreeFourDictionary, abcdDictionary ];
        NSArray *arrayOfMixedA = @[ @99, wxyzDictionary, [NSNull null], @[ @1, @2, @3 ] ];
        
        NSDictionary *dictionary = @{
                                     @"arrayOfDictionariesA" : arrayOfDictionariesA,
                                     @"arrayOfMixedA" : arrayOfMixedA
                                     };
        PPExtractor *extractor = [PPExtractor extractorWithDictionary:dictionary];
        
        {
            NSArray *arrayOfExtractors_dictionariesA = [extractor arrayOfExtractorsForKey:@"arrayOfDictionariesA"];
            
            XCTAssertEqual(arrayOfExtractors_dictionariesA.count, 2);
            
            PPExtractor *firstExtractor = arrayOfExtractors_dictionariesA[0];
            XCTAssertTrue([firstExtractor.dictionary isEqualToDictionary:oneTwoThreeFourDictionary]);
            XCTAssertEqualObjects([firstExtractor stringForKey:@"one"], @"two");
            
            PPExtractor *secondExtractor = arrayOfExtractors_dictionariesA[1];
            XCTAssertTrue([secondExtractor.dictionary isEqualToDictionary:abcdDictionary]);
            XCTAssertEqualObjects([secondExtractor stringForKey:@"a"], @"b");
        }
        
        {
            NSArray *arrayOfExtractors_dictionariesA = [extractor arrayOfExtractorsForKey:@"arrayOfDictionariesA" forceArrayObject:NO unconvertibleMarker:nil];
            
            XCTAssertEqual(arrayOfExtractors_dictionariesA.count, 2);
            
            PPExtractor *firstExtractor = arrayOfExtractors_dictionariesA[0];
            XCTAssertTrue([firstExtractor.dictionary isEqualToDictionary:oneTwoThreeFourDictionary]);
            XCTAssertEqualObjects([firstExtractor stringForKey:@"one"], @"two");
            
            PPExtractor *secondExtractor = arrayOfExtractors_dictionariesA[1];
            XCTAssertTrue([secondExtractor.dictionary isEqualToDictionary:abcdDictionary]);
            XCTAssertEqualObjects([secondExtractor stringForKey:@"a"], @"b");
        }
        
        {
            NSArray *arrayOfExtractors_dictionariesA = [extractor arrayOfExtractorsForKey:@"arrayOfDictionariesA" forceArrayObject:YES unconvertibleMarker:nil];
            
            XCTAssertEqual(arrayOfExtractors_dictionariesA.count, 2);
            
            PPExtractor *firstExtractor = arrayOfExtractors_dictionariesA[0];
            XCTAssertTrue([firstExtractor.dictionary isEqualToDictionary:oneTwoThreeFourDictionary]);
            XCTAssertEqualObjects([firstExtractor stringForKey:@"one"], @"two");
            
            PPExtractor *secondExtractor = arrayOfExtractors_dictionariesA[1];
            XCTAssertTrue([secondExtractor.dictionary isEqualToDictionary:abcdDictionary]);
            XCTAssertEqualObjects([secondExtractor stringForKey:@"a"], @"b");
        }
        
        {
            NSArray *arrayOfExtractors_mixedA = [extractor arrayOfExtractorsForKey:@"arrayOfMixedA"];
            
            XCTAssertEqual(arrayOfExtractors_mixedA.count, 1);
            
            PPExtractor *firstExtractor = arrayOfExtractors_mixedA[0];
            XCTAssertTrue([firstExtractor.dictionary isEqualToDictionary:wxyzDictionary]);
            XCTAssertEqualObjects([firstExtractor stringForKey:@"w"], @"x");
        }
        
        {
            NSArray *arrayOfExtractors_mixedA = [extractor arrayOfExtractorsForKey:@"arrayOfMixedA" forceArrayObject:YES unconvertibleMarker:[NSNull null]];
            
            XCTAssertEqual(arrayOfExtractors_mixedA.count, 4);
            
            XCTAssertEqualObjects(arrayOfExtractors_mixedA[0], [NSNull null]);
            
            PPExtractor *firstExtractor = arrayOfExtractors_mixedA[1];
            XCTAssertTrue([firstExtractor.dictionary isEqualToDictionary:wxyzDictionary]);
            XCTAssertEqualObjects([firstExtractor stringForKey:@"w"], @"x");
            
            XCTAssertEqualObjects(arrayOfExtractors_mixedA[2], [NSNull null]);
            XCTAssertEqualObjects(arrayOfExtractors_mixedA[3], [NSNull null]);
        }
    }
}

@end
