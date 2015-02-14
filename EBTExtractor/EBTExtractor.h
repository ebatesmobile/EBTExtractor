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

- (NSArray *)arrayOfNumbersForKey:(NSString *)key;
- (NSArray *)arrayOfStringsForKey:(NSString *)key;
- (NSArray *)arrayOfUnixDatesForKey:(NSString *)key;
- (NSArray *)arrayOfDecimalNumbersForKey:(NSString *)key;
- (NSArray *)arrayOfArraysForKey:(NSString *)key;
- (NSArray *)arrayOfDictionariesForKey:(NSString *)key;
- (NSArray *)arrayOfExtractorsForKey:(NSString *)key;

@end

@interface EBTExtractor (ForcedObjects)

- (NSNumber *)numberForKey:(NSString *)key forceObject:(BOOL)forceObject; // truncated to integer representation
- (NSString *)stringForKey:(NSString *)key forceObject:(BOOL)forceObject;
- (NSDate *)unixDateForKey:(NSString *)key forceObject:(BOOL)forceObject;
- (NSDecimalNumber *)decimalNumberForKey:(NSString *)key forceObject:(BOOL)forceObject; // may return NaN, but only when forceObject = YES
- (NSArray *)arrayForKey:(NSString *)key forceObject:(BOOL)forceObject;
- (NSDictionary *)dictionaryForKey:(NSString *)key forceObject:(BOOL)forceObject;
- (EBTExtractor *)extractorForKey:(NSString *)key forceObject:(BOOL)forceObject;

- (NSArray *)arrayOfNumbersForKey:(NSString *)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(NSObject *)unconvertibleMarker;
- (NSArray *)arrayOfStringsForKey:(NSString *)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(NSObject *)unconvertibleMarker;
- (NSArray *)arrayOfUnixDatesForKey:(NSString *)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(NSObject *)unconvertibleMarker;
- (NSArray *)arrayOfDecimalNumbersForKey:(NSString *)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(NSObject *)unconvertibleMarker;
- (NSArray *)arrayOfArraysForKey:(NSString *)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(NSObject *)unconvertibleMarker;
- (NSArray *)arrayOfDictionariesForKey:(NSString *)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(NSObject *)unconvertibleMarker;
- (NSArray *)arrayOfExtractorsForKey:(NSString *)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(NSObject *)unconvertibleMarker;

@end
