//
//  PPExtractor.m
//
//  Created by Neil Daniels
//  Copyright (c) 2015 Ebates Inc. All rights reserved.
//

#import "PPExtractor.h"

@implementation PPExtractor

#pragma mark - Init

+ (PPExtractor *)extractorWithDictionary:(NSDictionary *)dictionary
{
    return [[PPExtractor alloc] initWithDictionary:dictionary];
}

- (instancetype)init
{
    return [self initWithDictionary:nil];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _dictionary = [dictionary copy];
    }
    return self;
}

#pragma mark - PPExtractor

#pragma mark Primitives

- (BOOL)boolForKey:(NSString *)key
{
    return [[self numberForKey:key forceObject:NO] boolValue];
}

- (NSInteger)integerForKey:(NSString *)key
{
    return [[self numberForKey:key forceObject:NO] integerValue];
}

- (NSUInteger)unsignedIntegerForKey:(NSString *)key
{
    return [[self numberForKey:key forceObject:NO] unsignedIntegerValue];
}

#pragma mark Objects

- (NSDate *)dateForKey:(NSString *)key {return [self dateForKey:key forceObject:NO];}
- (NSDate *)dateForKey:(NSString *)key forceObject:(BOOL)forceObject
{
    return [self _objectForKey:key expectedClass:[NSDate class] forceObject:forceObject];
}

- (NSNumber *)numberForKey:(NSString *)key {return [self numberForKey:key forceObject:NO];}
- (NSNumber *)numberForKey:(NSString *)key forceObject:(BOOL)forceObject
{
    return [self _objectForKey:key expectedClass:[NSNumber class] forceObject:forceObject];
}

- (NSString *)stringForKey:(NSString *)key {return [self stringForKey:key forceObject:NO];}
- (NSString *)stringForKey:(NSString *)key forceObject:(BOOL)forceObject
{
    return [self _objectForKey:key expectedClass:[NSString class] forceObject:forceObject];
}

- (NSDecimalNumber *)decimalNumberForKey:(NSString *)key {return [self decimalNumberForKey:key forceObject:NO];}
- (NSDecimalNumber *)decimalNumberForKey:(NSString *)key forceObject:(BOOL)forceObject
{
    return [self _objectForKey:key expectedClass:[NSDecimalNumber class] forceObject:forceObject];
}

- (NSArray *)arrayForKey:(NSString *)key {return [self arrayForKey:key forceObject:NO];}
- (NSArray *)arrayForKey:(NSString *)key forceObject:(BOOL)forceObject
{
    return [self _objectForKey:key expectedClass:[NSArray class] forceObject:forceObject];
}

- (NSDictionary *)dictionaryForKey:(NSString *)key {return [self dictionaryForKey:key forceObject:NO];}
- (NSDictionary *)dictionaryForKey:(NSString *)key forceObject:(BOOL)forceObject
{
    return [self _objectForKey:key expectedClass:[NSDictionary class] forceObject:forceObject];
}

- (PPExtractor *)extractorForKey:(NSString *)key {return [self extractorForKey:key forceObject:NO];}
- (PPExtractor *)extractorForKey:(NSString *)key forceObject:(BOOL)forceObject
{
    return [self _objectForKey:key expectedClass:[PPExtractor class] forceObject:forceObject];
}

#pragma mark Typed Extraction

- (NSArray *)arrayOfDatesForKey:(NSString *)key {return [self arrayOfDatesForKey:key forceArrayObject:NO unconvertibleMarker:nil];}
- (NSArray *)arrayOfDatesForKey:(NSString *)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(NSObject *)unconvertibleMarker
{
    return [self _arrayForKey:key contentsTranformedToClass:[NSDate class] forceArrayObject:forceArrayObject unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)arrayOfNumbersForKey:(NSString *)key {return [self arrayOfNumbersForKey:key forceArrayObject:NO unconvertibleMarker:nil];}
- (NSArray *)arrayOfNumbersForKey:(NSString *)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(NSObject *)unconvertibleMarker
{
    return [self _arrayForKey:key contentsTranformedToClass:[NSNumber class] forceArrayObject:forceArrayObject unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)arrayOfStringsForKey:(NSString *)key {return [self arrayOfStringsForKey:key forceArrayObject:NO unconvertibleMarker:nil];}
- (NSArray *)arrayOfStringsForKey:(NSString *)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(NSObject *)unconvertibleMarker
{
    return [self _arrayForKey:key contentsTranformedToClass:[NSString class] forceArrayObject:forceArrayObject unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)arrayOfDecimalNumbersForKey:(NSString *)key {return [self arrayOfDecimalNumbersForKey:key forceArrayObject:NO unconvertibleMarker:nil];}
- (NSArray *)arrayOfDecimalNumbersForKey:(NSString *)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(NSObject *)unconvertibleMarker
{
    return [self _arrayForKey:key contentsTranformedToClass:[NSDecimalNumber class] forceArrayObject:forceArrayObject unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)arrayOfArraysForKey:(NSString *)key {return [self arrayOfArraysForKey:key forceArrayObject:NO unconvertibleMarker:nil];}
- (NSArray *)arrayOfArraysForKey:(NSString *)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(NSObject *)unconvertibleMarker
{
    return [self _arrayForKey:key contentsTranformedToClass:[NSArray class] forceArrayObject:forceArrayObject unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)arrayOfDictionariesForKey:(NSString *)key {return [self arrayOfDictionariesForKey:key forceArrayObject:NO unconvertibleMarker:nil];}
- (NSArray *)arrayOfDictionariesForKey:(NSString *)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(NSObject *)unconvertibleMarker
{
    return [self _arrayForKey:key contentsTranformedToClass:[NSDictionary class] forceArrayObject:forceArrayObject unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)arrayOfExtractorsForKey:(NSString *)key {return [self arrayOfExtractorsForKey:key forceArrayObject:NO unconvertibleMarker:nil];}
- (NSArray *)arrayOfExtractorsForKey:(NSString *)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(NSObject *)unconvertibleMarker
{
    return [self _arrayForKey:key contentsTranformedToClass:[PPExtractor class] forceArrayObject:forceArrayObject unconvertibleMarker:unconvertibleMarker];
}

#pragma mark Type Enforcement Helpers

- (id)_objectForKey:(NSString *)key expectedClass:(Class)theClass forceObject:(BOOL)forceObject
{
    return [self.class _transformObject:self.dictionary[key] toClass:theClass forceObject:forceObject];
}

- (NSArray *)_arrayForKey:(NSString *)key contentsTranformedToClass:(Class)class forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(NSObject *)unconvertibleMarker
{
    NSArray *array = [self arrayForKey:key forceObject:forceArrayObject];
    if (array && class) {
        array = [self.class _transformArray:array toArrayOfClass:class unconvertibleMarker:unconvertibleMarker];
    }
    return array;
}

+ (id)_transformObject:(id)fromObject toClass:(Class)theClass forceObject:(BOOL)forceObject
{
    BOOL didFail = !fromObject || !theClass || (fromObject == [NSNull null]);
    
    if (theClass == [NSDate class]) {
        NSDecimalNumber *dateTimestamp = [self _transformObject:fromObject toClass:[NSDecimalNumber class] forceObject:forceObject];
        
        if ([dateTimestamp isEqualToNumber:[NSDecimalNumber notANumber]]) {
            dateTimestamp = nil;
        }
        
        if (!forceObject && [dateTimestamp isEqualToNumber:[NSDecimalNumber zero]]) {
            return nil;
        }
        
        if (dateTimestamp || forceObject) {
            return [NSDate dateWithTimeIntervalSince1970:[dateTimestamp doubleValue]];
        }
        
        return dateTimestamp;
    }
    else if (theClass == [PPExtractor class]) {
        NSDictionary *dictionary = [self _transformObject:fromObject toClass:[NSDictionary class] forceObject:forceObject];
        if (dictionary) {
            return [PPExtractor extractorWithDictionary:dictionary];
        }
        else if (forceObject) {
            return [PPExtractor extractorWithDictionary:@{}];
        }
        return nil;
    }
    
    if (!didFail) {
        fromObject = [self _straightforwardTransformObject:fromObject toClass:theClass];
        if (fromObject) {
            if (!forceObject && [fromObject isKindOfClass:[NSDecimalNumber class]] && [fromObject isEqualToNumber:[NSDecimalNumber notANumber]]) {
                return nil;
            }
            return fromObject;
        }
    }
    
    if (forceObject) {
        if ([theClass isSubclassOfClass:[NSObject class]]) {
            fromObject = [[theClass alloc] init];
            if (!fromObject && [theClass isSubclassOfClass:[NSNumber class]]) {
                // [[NSNumber alloc] init] gives nil instead of an actual object
                fromObject = [[theClass alloc] initWithInteger:0];
            }
            return fromObject;
        }
    }
    
    return nil;
}

+ (id)_straightforwardTransformObject:(NSObject *)fromObject toClass:(Class)toClass
{
    if ([fromObject isKindOfClass:[NSString class]]) {
        if (toClass == [NSNumber class] || toClass == [NSDecimalNumber class]) {
            static NSCharacterSet *stringToNumberTrimmingCharacterSet;
            
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                NSMutableCharacterSet *mutableStringToNumberTrimmingCharacterSet = [NSMutableCharacterSet decimalDigitCharacterSet];
                [mutableStringToNumberTrimmingCharacterSet addCharactersInString:@".-"];
                [mutableStringToNumberTrimmingCharacterSet invert];
                stringToNumberTrimmingCharacterSet = [mutableStringToNumberTrimmingCharacterSet copy];
            });
            
            fromObject = [(NSString *)fromObject stringByTrimmingCharactersInSet:stringToNumberTrimmingCharacterSet];
            
            if ([(NSString *)fromObject rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location == NSNotFound) {
                fromObject = nil;
            }
        }
        
        if (toClass == [NSNumber class]) {
            return [(NSString *)fromObject length] ? @([(NSString *)fromObject integerValue]) : nil;
        }
        else if (toClass == [NSDecimalNumber class]) {
            NSDecimalNumber *decimalNumber;
            if ([(NSString *)fromObject length]) {
                decimalNumber = [[NSDecimalNumber alloc] initWithString:((NSString *)fromObject) locale:[NSLocale systemLocale]];
            }
            return decimalNumber;
        }
    }
    else if ([fromObject isKindOfClass:[NSNumber class]]) {
        if ([fromObject isKindOfClass:[NSDecimalNumber class]]) {
            if (toClass == [NSNumber class]) {
                if ([(NSDecimalNumber *)fromObject isEqualToNumber:[NSDecimalNumber notANumber]]) {
                    // 32-bit devices do not return 0 when requesting primitive form of NaN
                    return @0;
                }
                else if (sizeof(NSInteger) == sizeof(int)) {
                    // iOS 8 Bug on 32-bit Devices Occasionally Does Not Return Accurate integerValues
                    // filed rdar://19658050 ; duplicate of rdar://18257823
                    // Using long long instead for these devices
                    long long value = [(NSDecimalNumber *)fromObject longLongValue];
                    NSInteger integerValue = (NSInteger)value;
                    return @(integerValue);
                }
                else {
                    return @([(NSDecimalNumber *)fromObject integerValue]);
                }
            }
            else if (toClass == [NSString class]) {
                return [(NSDecimalNumber *)fromObject stringValue];
            }
        }
        
        if (toClass == [NSNumber class]) {
            return @([(NSNumber *)fromObject integerValue]);
        }
        else if (toClass == [NSDecimalNumber class]) {
            return [NSDecimalNumber decimalNumberWithDecimal:[(NSNumber *)fromObject decimalValue]];
        }
        else if (toClass == [NSString class]) {
            return [(NSNumber *)fromObject stringValue];
        }
    }
    
    if ([fromObject isKindOfClass:toClass]) {
        return fromObject;
    }
    
    return nil;
}

+ (NSArray *)_transformArray:(NSArray *)originalArray toArrayOfClass:(Class)toClass unconvertibleMarker:(NSObject *)unconvertibleMarker
{
    if (!originalArray) {
        return nil;
    }
    
    NSMutableArray *convertedObjects = [NSMutableArray arrayWithCapacity:originalArray.count];
    for (id originalObject in originalArray) {
        id convertedObject = [self.class _transformObject:originalObject toClass:toClass forceObject:NO];
        if (convertedObject) {
            [convertedObjects addObject:convertedObject];
        }
        else if (unconvertibleMarker) {
            [convertedObjects addObject:unconvertibleMarker];
        }
    }
    return convertedObjects;
}

@end
