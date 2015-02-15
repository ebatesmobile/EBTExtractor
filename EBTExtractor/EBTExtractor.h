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

- (BOOL)boolForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (NSUInteger)unsignedIntegerForKey:(NSString *)key;

// Objects

- (NSNumber *)numberForKey:(NSString *)key; // truncated to integer representation
- (NSString *)stringForKey:(NSString *)key;
- (NSDate *)unixDateForKey:(NSString *)key;
- (NSDecimalNumber *)decimalNumberForKey:(NSString *)key; // never returns NaN
- (NSArray *)arrayForKey:(NSString *)key;
- (NSDictionary *)dictionaryForKey:(NSString *)key;
- (EBTExtractor *)extractorForKey:(NSString *)key;

// Typed Arrays

- (NSArray *)arrayOfNumbersForKey:(NSString *)key; // values truncated to integer representation
- (NSArray *)arrayOfStringsForKey:(NSString *)key;
- (NSArray *)arrayOfUnixDatesForKey:(NSString *)key;
- (NSArray *)arrayOfDecimalNumbersForKey:(NSString *)key; // values will never be NaN
- (NSArray *)arrayOfArraysForKey:(NSString *)key;
- (NSArray *)arrayOfDictionariesForKey:(NSString *)key;
- (NSArray *)arrayOfExtractorsForKey:(NSString *)key;

- (NSArray *)arrayOfNumbersForKey:(NSString *)key unconvertibleMarker:(NSObject *)unconvertibleMarker; // values truncated to integer representation
- (NSArray *)arrayOfStringsForKey:(NSString *)key unconvertibleMarker:(NSObject *)unconvertibleMarker;
- (NSArray *)arrayOfUnixDatesForKey:(NSString *)key unconvertibleMarker:(NSObject *)unconvertibleMarker;
- (NSArray *)arrayOfDecimalNumbersForKey:(NSString *)key unconvertibleMarker:(NSObject *)unconvertibleMarker; // values will never be NaN
- (NSArray *)arrayOfArraysForKey:(NSString *)key unconvertibleMarker:(NSObject *)unconvertibleMarker;
- (NSArray *)arrayOfDictionariesForKey:(NSString *)key unconvertibleMarker:(NSObject *)unconvertibleMarker;
- (NSArray *)arrayOfExtractorsForKey:(NSString *)key unconvertibleMarker:(NSObject *)unconvertibleMarker;

// Forced Objects

- (NSNumber *)forcedNumberForKey:(NSString *)key; // truncated to integer representation
- (NSString *)forcedStringForKey:(NSString *)key;
- (NSDate *)forcedUnixDateForKey:(NSString *)key;
- (NSDecimalNumber *)forcedDecimalNumberForKey:(NSString *)key; // may return NaN
- (NSArray *)forcedArrayForKey:(NSString *)key;
- (NSDictionary *)forcedDictionaryForKey:(NSString *)key;
- (EBTExtractor *)forcedExtractorForKey:(NSString *)key;

// Forced Typed Arrays

- (NSArray *)forcedArrayOfNumbersForKey:(NSString *)key unconvertibleMarker:(NSObject *)unconvertibleMarker; // values truncated to integer representation
- (NSArray *)forcedArrayOfStringsForKey:(NSString *)key unconvertibleMarker:(NSObject *)unconvertibleMarker;
- (NSArray *)forcedArrayOfUnixDatesForKey:(NSString *)key unconvertibleMarker:(NSObject *)unconvertibleMarker;
- (NSArray *)forcedArrayOfDecimalNumbersForKey:(NSString *)key unconvertibleMarker:(NSObject *)unconvertibleMarker;  // values will never be NaN
- (NSArray *)forcedArrayOfArraysForKey:(NSString *)key unconvertibleMarker:(NSObject *)unconvertibleMarker;
- (NSArray *)forcedArrayOfDictionariesForKey:(NSString *)key unconvertibleMarker:(NSObject *)unconvertibleMarker;
- (NSArray *)forcedArrayOfExtractorsForKey:(NSString *)key unconvertibleMarker:(NSObject *)unconvertibleMarker;

@end
