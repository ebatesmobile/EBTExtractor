//
//  EBTExtractor.h
//
//  Created by Neil Daniels
//  Copyright (c) 2015 Ebates Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBTExtractor : NSObject

+ (EBTExtractor *)extractorWithDictionary:(NSDictionary *)dictionary;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

@property (nonatomic, copy, readonly) NSDictionary *dictionary;

// Primitives

- (BOOL)boolForKey:(id)key;
- (NSInteger)integerForKey:(id)key;
- (NSUInteger)unsignedIntegerForKey:(id)key;

// Objects

- (NSNumber *)numberForKey:(id)key; // truncated to integer representation
- (NSString *)stringForKey:(id)key;
- (NSDate *)unixDateForKey:(id)key;
- (NSDecimalNumber *)decimalNumberForKey:(id)key; // never returns NaN
- (NSArray *)arrayForKey:(id)key;
- (NSDictionary *)dictionaryForKey:(id)key;
- (EBTExtractor *)extractorForKey:(id)key;

// Typed Arrays

- (NSArray *)arrayOfNumbersForKey:(id)key; // values truncated to integer representation
- (NSArray *)arrayOfStringsForKey:(id)key;
- (NSArray *)arrayOfUnixDatesForKey:(id)key;
- (NSArray *)arrayOfDecimalNumbersForKey:(id)key; // values will never be NaN
- (NSArray *)arrayOfArraysForKey:(id)key;
- (NSArray *)arrayOfDictionariesForKey:(id)key;
- (NSArray *)arrayOfExtractorsForKey:(id)key;

- (NSArray *)arrayOfNumbersForKey:(id)key unconvertibleMarker:(NSObject *)unconvertibleMarker; // values truncated to integer representation
- (NSArray *)arrayOfStringsForKey:(id)key unconvertibleMarker:(NSObject *)unconvertibleMarker;
- (NSArray *)arrayOfUnixDatesForKey:(id)key unconvertibleMarker:(NSObject *)unconvertibleMarker;
- (NSArray *)arrayOfDecimalNumbersForKey:(id)key unconvertibleMarker:(NSObject *)unconvertibleMarker; // values will never be NaN
- (NSArray *)arrayOfArraysForKey:(id)key unconvertibleMarker:(NSObject *)unconvertibleMarker;
- (NSArray *)arrayOfDictionariesForKey:(id)key unconvertibleMarker:(NSObject *)unconvertibleMarker;
- (NSArray *)arrayOfExtractorsForKey:(id)key unconvertibleMarker:(NSObject *)unconvertibleMarker;

// Forced Objects

- (NSNumber *)forcedNumberForKey:(id)key; // truncated to integer representation
- (NSString *)forcedStringForKey:(id)key;
- (NSDate *)forcedUnixDateForKey:(id)key;
- (NSDecimalNumber *)forcedDecimalNumberForKey:(id)key; // may return NaN
- (NSArray *)forcedArrayForKey:(id)key;
- (NSDictionary *)forcedDictionaryForKey:(id)key;
- (EBTExtractor *)forcedExtractorForKey:(id)key;

// Forced Typed Arrays

- (NSArray *)forcedArrayOfNumbersForKey:(id)key unconvertibleMarker:(NSObject *)unconvertibleMarker; // values truncated to integer representation
- (NSArray *)forcedArrayOfStringsForKey:(id)key unconvertibleMarker:(NSObject *)unconvertibleMarker;
- (NSArray *)forcedArrayOfUnixDatesForKey:(id)key unconvertibleMarker:(NSObject *)unconvertibleMarker;
- (NSArray *)forcedArrayOfDecimalNumbersForKey:(id)key unconvertibleMarker:(NSObject *)unconvertibleMarker;  // values will never be NaN
- (NSArray *)forcedArrayOfArraysForKey:(id)key unconvertibleMarker:(NSObject *)unconvertibleMarker;
- (NSArray *)forcedArrayOfDictionariesForKey:(id)key unconvertibleMarker:(NSObject *)unconvertibleMarker;
- (NSArray *)forcedArrayOfExtractorsForKey:(id)key unconvertibleMarker:(NSObject *)unconvertibleMarker;

@end
