//
// EBTExtractor.h
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

#import <Foundation/Foundation.h>

@interface EBTExtractor : NSObject

+ (instancetype)extractorWithDictionary:(NSDictionary *)dictionary;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

@property (nonatomic, copy, readonly) NSDictionary *dictionary;

// Primitives

- (BOOL)boolForKey:(id)key;
- (NSInteger)integerForKey:(id)key;
- (NSUInteger)unsignedIntegerForKey:(id)key; // negative values will return 0

// Objects

- (NSNumber *)numberForKey:(id)key; // truncated to integer representation
- (NSString *)stringForKey:(id)key;
- (NSDate *)unixDateForKey:(id)key;
- (NSDecimalNumber *)decimalNumberForKey:(id)key; // never returns NaN
- (NSArray *)arrayForKey:(id)key;
- (NSDictionary *)dictionaryForKey:(id)key;
- (instancetype)extractorForKey:(id)key;

// Typed Arrays

- (NSArray *)arrayOfNumbersForKey:(id)key; // values truncated to integer representation
- (NSArray *)arrayOfStringsForKey:(id)key;
- (NSArray *)arrayOfUnixDatesForKey:(id)key;
- (NSArray *)arrayOfDecimalNumbersForKey:(id)key; // values will never be NaN
- (NSArray *)arrayOfArraysForKey:(id)key;
- (NSArray *)arrayOfDictionariesForKey:(id)key;
- (NSArray *)arrayOfExtractorsForKey:(id)key;

- (NSArray *)arrayOfNumbersForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker; // values truncated to integer representation
- (NSArray *)arrayOfStringsForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker;
- (NSArray *)arrayOfUnixDatesForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker;
- (NSArray *)arrayOfDecimalNumbersForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker; // values will never be NaN
- (NSArray *)arrayOfArraysForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker;
- (NSArray *)arrayOfDictionariesForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker;
- (NSArray *)arrayOfExtractorsForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker;

// Forced Objects

- (NSNumber *)forcedNumberForKey:(id)key; // truncated to integer representation
- (NSString *)forcedStringForKey:(id)key;
- (NSDate *)forcedUnixDateForKey:(id)key;
- (NSDecimalNumber *)forcedDecimalNumberForKey:(id)key; // may return NaN
- (NSArray *)forcedArrayForKey:(id)key;
- (NSDictionary *)forcedDictionaryForKey:(id)key;
- (instancetype)forcedExtractorForKey:(id)key;

// Forced Typed Arrays

- (NSArray *)forcedArrayOfNumbersForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker; // values truncated to integer representation
- (NSArray *)forcedArrayOfStringsForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker;
- (NSArray *)forcedArrayOfUnixDatesForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker;
- (NSArray *)forcedArrayOfDecimalNumbersForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker;  // values will never be NaN
- (NSArray *)forcedArrayOfArraysForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker;
- (NSArray *)forcedArrayOfDictionariesForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker;
- (NSArray *)forcedArrayOfExtractorsForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker;

@end
