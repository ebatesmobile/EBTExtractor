//
// EBTExtractorSubclassingTests.m
//
// Copyright (c) 2015 Ebates Inc. <http://www.ebates.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <XCTest/XCTest.h>

#import "EBTExtractor.h"

// The subclass below is shown for illustraton purposes.
// Adding a category on EBTExtractor is likely an easier alternative to subclassing.

@interface ESTSubclassedTestExtractor : EBTExtractor
- (NSTimeZone *)timeZoneForKey:(id)key;
@end

@interface EBTExtractorSubclassingTests : XCTestCase

@property (nonatomic, strong) ESTSubclassedTestExtractor *timeZoneExtractor;

@end

@implementation EBTExtractorSubclassingTests

- (void)setUp
{
    [super setUp];
    
    NSDictionary *dictionary = @{
                                 @"california" : @"America/Los_Angeles",
                                 @"italy" : @"Europe/Rome",
                                 @"other places" : @{
                                         @"norway" : @"Arctic/Longyearbyen",
                                         @"fiji" : @"Pacific/Fiji",
                                         },
                                 @"states" : @[
                                         @{ @"partA" : @"America/North_Dakota/New_Salem" },
                                         @{ @"partB" : @"America/Kentucky/Louisville" },
                                         @"nonsense",
                                         @{ @"partD" : @"America/Indiana/Indianapolis" },
                                         ],
                                 @"cat" : @"meow",
                                 };
    self.timeZoneExtractor = [ESTSubclassedTestExtractor extractorWithDictionary:dictionary];
}

- (void)tearDown
{
    self.timeZoneExtractor = nil;
    
    [super tearDown];
}

- (void)testSubclassExtractor
{
    XCTAssertEqualObjects([self.timeZoneExtractor timeZoneForKey:@"california"], [NSTimeZone timeZoneWithName:@"America/Los_Angeles"]);
    
    ESTSubclassedTestExtractor *subExtractor = [self.timeZoneExtractor extractorForKey:@"other places"];
    XCTAssertTrue([subExtractor isMemberOfClass:[ESTSubclassedTestExtractor class]]);
    XCTAssertEqualObjects([subExtractor timeZoneForKey:@"fiji"], [NSTimeZone timeZoneWithName:@"Pacific/Fiji"]);
    
    ESTSubclassedTestExtractor *forcedSubExtractor = [self.timeZoneExtractor forcedExtractorForKey:@"fail"];
    XCTAssertTrue([forcedSubExtractor isMemberOfClass:[ESTSubclassedTestExtractor class]]);
    
    XCTAssertNil([self.timeZoneExtractor extractorForKey:@"nothing"]);

    XCTAssertNil([self.timeZoneExtractor timeZoneForKey:@"cat"]);
    
    NSArray *arrayOfExtractors = [self.timeZoneExtractor arrayOfExtractorsForKey:@"states"];
    XCTAssertEqual(arrayOfExtractors.count, 3u);
    XCTAssertEqualObjects([arrayOfExtractors[0] timeZoneForKey:@"partA"], [NSTimeZone timeZoneWithName:@"America/North_Dakota/New_Salem"]);
    XCTAssertEqualObjects([arrayOfExtractors[1] timeZoneForKey:@"partB"], [NSTimeZone timeZoneWithName:@"America/Kentucky/Louisville"]);
    XCTAssertEqualObjects([arrayOfExtractors[2] timeZoneForKey:@"partD"], [NSTimeZone timeZoneWithName:@"America/Indiana/Indianapolis"]);
    
    NSArray *arrayOfExtractorsWithFallback = [self.timeZoneExtractor arrayOfExtractorsForKey:@"states" unconvertibleMarker:[EBTExtractor extractorWithDictionary:@{}]];
    XCTAssertEqual(arrayOfExtractorsWithFallback.count, 4u);
    XCTAssertEqualObjects([arrayOfExtractorsWithFallback[0] timeZoneForKey:@"partA"], [NSTimeZone timeZoneWithName:@"America/North_Dakota/New_Salem"]);
    XCTAssertEqualObjects([arrayOfExtractorsWithFallback[1] timeZoneForKey:@"partB"], [NSTimeZone timeZoneWithName:@"America/Kentucky/Louisville"]);
    XCTAssertTrue([arrayOfExtractorsWithFallback[2] isMemberOfClass:[EBTExtractor class]]);
    XCTAssertEqualObjects([arrayOfExtractorsWithFallback[3] timeZoneForKey:@"partD"], [NSTimeZone timeZoneWithName:@"America/Indiana/Indianapolis"]);
}

@end

@implementation ESTSubclassedTestExtractor

- (NSTimeZone *)timeZoneForKey:(id)key
{
    NSString *timeZoneName = [self stringForKey:key];
    if (timeZoneName.length && [[NSTimeZone knownTimeZoneNames] containsObject:timeZoneName]) {
        return [NSTimeZone timeZoneWithName:timeZoneName];
    }
    return nil;
}

@end
