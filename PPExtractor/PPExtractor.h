//
//  PPExtractor.h
//
//  Created by Neil Daniels
//  Copyright (c) 2015 Ebates Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPExtractor : NSObject

+ (PPExtractor *)extractorWithDictionary:(NSDictionary *)dictionary;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

@property (nonatomic, copy, readonly) NSDictionary *dictionary;

// Primitives

- (BOOL)boolForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (NSUInteger)unsignedIntegerForKey:(NSString *)key;

// Objects

- (NSDate *)dateForKey:(NSString *)key;
- (NSDate *)dateForKey:(NSString *)key forceObject:(BOOL)forceObject;

- (NSNumber *)numberForKey:(NSString *)key; // truncated to integer representation
- (NSNumber *)numberForKey:(NSString *)key forceObject:(BOOL)forceObject; // truncated to integer representation

- (NSString *)stringForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key forceObject:(BOOL)forceObject;

- (NSDecimalNumber *)decimalNumberForKey:(NSString *)key; // never returns NaN
- (NSDecimalNumber *)decimalNumberForKey:(NSString *)key forceObject:(BOOL)forceObject; // may return NaN, but only when forceObject = YES

- (NSArray *)arrayForKey:(NSString *)key;
- (NSArray *)arrayForKey:(NSString *)key forceObject:(BOOL)forceObject;

- (NSDictionary *)dictionaryForKey:(NSString *)key;
- (NSDictionary *)dictionaryForKey:(NSString *)key forceObject:(BOOL)forceObject;

- (PPExtractor *)extractorForKey:(NSString *)key;
- (PPExtractor *)extractorForKey:(NSString *)key forceObject:(BOOL)forceObject;

// Typed Arrays

- (NSArray *)arrayOfDatesForKey:(NSString *)key;
- (NSArray *)arrayOfDatesForKey:(NSString *)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(NSObject *)unconvertibleMarker;

- (NSArray *)arrayOfNumbersForKey:(NSString *)key;
- (NSArray *)arrayOfNumbersForKey:(NSString *)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(NSObject *)unconvertibleMarker;

- (NSArray *)arrayOfStringsForKey:(NSString *)key;
- (NSArray *)arrayOfStringsForKey:(NSString *)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(NSObject *)unconvertibleMarker;

- (NSArray *)arrayOfDecimalNumbersForKey:(NSString *)key;
- (NSArray *)arrayOfDecimalNumbersForKey:(NSString *)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(NSObject *)unconvertibleMarker;

- (NSArray *)arrayOfArraysForKey:(NSString *)key;
- (NSArray *)arrayOfArraysForKey:(NSString *)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(NSObject *)unconvertibleMarker;

- (NSArray *)arrayOfDictionariesForKey:(NSString *)key;
- (NSArray *)arrayOfDictionariesForKey:(NSString *)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(NSObject *)unconvertibleMarker;

- (NSArray *)arrayOfExtractorsForKey:(NSString *)key;
- (NSArray *)arrayOfExtractorsForKey:(NSString *)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(NSObject *)unconvertibleMarker;

@end
