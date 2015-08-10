//
// EBTExtractor.m
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

#import "EBTExtractor.h"

@implementation EBTExtractor

#pragma mark - Init

+ (instancetype)extractorWithDictionary:(NSDictionary *)dictionary
{
    return [(EBTExtractor *)[self alloc] initWithDictionary:dictionary];
}

- (instancetype)init
{
    return [self initWithDictionary:nil];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _dictionary = [dictionary copy];
    }
    return self;
}

#pragma mark - EBTExtractor

#pragma mark Primitives

- (BOOL)boolForKey:(id)key
{
    return [self.class boolFromObject:self.dictionary[key]];
}

+ (BOOL)boolFromObject:(id)object
{
    return [[self numberFromObject:object] boolValue];
}

- (NSInteger)integerForKey:(id)key
{
    return [self.class integerFromObject:self.dictionary[key]];
}

+ (NSInteger)integerFromObject:(id)object
{
    return [[self numberFromObject:object] integerValue];
}

- (NSUInteger)unsignedIntegerForKey:(id)key
{
    return [self.class unsignedIntegerFromObject:self.dictionary[key]];
}

+ (NSUInteger)unsignedIntegerFromObject:(id)object
{
    if ([[self numberFromObject:object] integerValue] <= 0) {
        return 0;
    }
    return [[self numberFromObject:object] unsignedIntegerValue];
}

#pragma mark Objects

#pragma mark Number Extraction

- (NSNumber *)numberForKey:(id)key
{
    return [self.class numberFromObject:self.dictionary[key]];
}

- (NSNumber *)forcedNumberForKey:(id)key
{
    return [self.class numberFromObject:self.dictionary[key]] ?: @0;
}

+ (NSNumber *)numberFromObject:(id)object
{
    return [self.class _transformObject:object toClass:[NSNumber class]];
}

#pragma mark String Extraction

- (NSString *)stringForKey:(id)key
{
    return [self.class stringFromObject:self.dictionary[key]];
}

- (NSString *)forcedStringForKey:(id)key
{
    return [self.class stringFromObject:self.dictionary[key]] ?: @"";
}

+ (NSString *)stringFromObject:(id)object
{
    return [self.class _transformObject:object toClass:[NSString class]];
}

#pragma mark Unix Date Extraction

- (NSDate *)unixDateForKey:(id)key
{
    return [self.class unixDateFromObject:self.dictionary[key]];
}

- (NSDate *)forcedUnixDateForKey:(id)key
{
    return [self.class unixDateFromObject:self.dictionary[key]] ?: [NSDate dateWithTimeIntervalSince1970:0];
}

+ (NSDate *)unixDateFromObject:(id)object
{
    return [self _transformObject:object toClass:[NSDate class]];
}

#pragma mark Decimal Number Extraction

- (NSDecimalNumber *)decimalNumberForKey:(id)key
{
    return [self.class decimalNumberFromObject:self.dictionary[key]];
}

- (NSDecimalNumber *)forcedDecimalNumberForKey:(id)key
{
    return [self.class decimalNumberFromObject:self.dictionary[key]] ?: [NSDecimalNumber notANumber];
}

+ (NSDecimalNumber *)decimalNumberFromObject:(id)object
{
    return [self _transformObject:object toClass:[NSDecimalNumber class]];
}

#pragma mark Array Extraction

- (NSArray *)arrayForKey:(id)key
{
    return [self.class arrayFromObject:self.dictionary[key]];
}

- (NSArray *)forcedArrayForKey:(id)key
{
    return [self.class arrayFromObject:self.dictionary[key]] ?: @[];
}

+ (NSArray *)arrayFromObject:(id)object
{
    return [self _transformObject:object toClass:[NSArray class]];
}

#pragma mark Dictionary Extraction

- (NSDictionary *)dictionaryForKey:(id)key
{
    return [self.class dictionaryFromObject:self.dictionary[key]];
}

- (NSDictionary *)forcedDictionaryForKey:(id)key
{
    return [self.class dictionaryFromObject:self.dictionary[key]] ?: @{};
}

+ (NSDictionary *)dictionaryFromObject:(id)object
{
    return [self _transformObject:object toClass:[NSDictionary class]];
}

#pragma mark Extractor Extraction

- (instancetype)extractorForKey:(id)key
{
    return [self.class extractorFromObject:self.dictionary[key]];
}

- (instancetype)forcedExtractorForKey:(id)key
{
    return [self.class extractorFromObject:self.dictionary[key]] ?: [self.class extractorWithDictionary:@{}];
}

+ (instancetype)extractorFromObject:(id)object
{
    return [self _transformObject:object toClass:[self class]];
}

#pragma mark Typed Arrays Extraction

#pragma mark Array of Numbers Extraction

- (NSArray *)arrayOfNumbersForKey:(id)key
{
    return [self.class arrayOfNumbersFromObject:self.dictionary[key]];
}

- (NSArray *)arrayOfNumbersForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self.class arrayOfNumbersFromObject:self.dictionary[key] unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)forcedArrayOfNumbersForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self.class arrayOfNumbersFromObject:self.dictionary[key] unconvertibleMarker:unconvertibleMarker] ?: @[];
}

+ (NSArray *)arrayOfNumbersFromObject:(id)object
{
    return [self arrayOfNumbersFromObject:object unconvertibleMarker:nil];
}

+ (NSArray *)arrayOfNumbersFromObject:(id)object unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayFromObject:object contentsTranformedToClass:[NSNumber class] unconvertibleMarker:unconvertibleMarker];
}

#pragma mark Array of Strings Extraction

- (NSArray *)arrayOfStringsForKey:(id)key
{
    return [self.class arrayOfStringsFromObject:self.dictionary[key]];
}

- (NSArray *)arrayOfStringsForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self.class arrayOfStringsFromObject:self.dictionary[key] unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)forcedArrayOfStringsForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self.class arrayOfStringsFromObject:self.dictionary[key] unconvertibleMarker:unconvertibleMarker] ?: @[];
}

+ (NSArray *)arrayOfStringsFromObject:(id)object
{
    return [self arrayOfStringsFromObject:object unconvertibleMarker:nil];
}

+ (NSArray *)arrayOfStringsFromObject:(id)object unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayFromObject:object contentsTranformedToClass:[NSString class] unconvertibleMarker:unconvertibleMarker];
}

#pragma mark Array of Unix Dates Extraction

- (NSArray *)arrayOfUnixDatesForKey:(id)key
{
    return [self.class arrayOfUnixDatesFromObject:self.dictionary[key]];
}

- (NSArray *)arrayOfUnixDatesForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self.class arrayOfUnixDatesFromObject:self.dictionary[key] unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)forcedArrayOfUnixDatesForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self.class arrayOfUnixDatesFromObject:self.dictionary[key] unconvertibleMarker:unconvertibleMarker] ?: @[];
}

+ (NSArray *)arrayOfUnixDatesFromObject:(id)object
{
    return [self arrayOfUnixDatesFromObject:object unconvertibleMarker:nil];
}

+ (NSArray *)arrayOfUnixDatesFromObject:(id)object unconvertibleMarker:(id)unconvertibleMarker
{
    return [self.class _arrayFromObject:object contentsTranformedToClass:[NSDate class] unconvertibleMarker:unconvertibleMarker];
}

#pragma mark Array of Decimal Numbers Extraction

- (NSArray *)arrayOfDecimalNumbersForKey:(id)key
{
    return [self.class arrayOfDecimalNumbersFromObject:self.dictionary[key]];
}

- (NSArray *)arrayOfDecimalNumbersForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self.class arrayOfDecimalNumbersFromObject:self.dictionary[key] unconvertibileMarker:unconvertibleMarker];
}

- (NSArray *)forcedArrayOfDecimalNumbersForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self.class arrayOfDecimalNumbersFromObject:self.dictionary[key] unconvertibileMarker:unconvertibleMarker] ?: @[];
}

+ (NSArray *)arrayOfDecimalNumbersFromObject:(id)object
{
    return [self arrayOfDecimalNumbersFromObject:object unconvertibileMarker:nil];
}

+ (NSArray *)arrayOfDecimalNumbersFromObject:(id)object unconvertibileMarker:(id)unconvertibileMarker
{
    return [self _arrayFromObject:object contentsTranformedToClass:[NSDecimalNumber class] unconvertibleMarker:unconvertibileMarker];
}

#pragma mark Array of Arrays Extraction

- (NSArray *)arrayOfArraysForKey:(id)key
{
    return [self.class arrayOfArraysFromObject:self.dictionary[key]];
}

- (NSArray *)arrayOfArraysForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self.class arrayOfArraysFromObject:self.dictionary[key] unconvertibileMarker:unconvertibleMarker];
}

- (NSArray *)forcedArrayOfArraysForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self.class arrayOfArraysFromObject:self.dictionary[key] unconvertibileMarker:unconvertibleMarker] ?: @[];
}

+ (NSArray *)arrayOfArraysFromObject:(id)object
{
    return [self arrayOfArraysFromObject:object unconvertibileMarker:nil];
}

+ (NSArray *)arrayOfArraysFromObject:(id)object unconvertibileMarker:(id)unconvertibleMarker
{
    return [self _arrayFromObject:object contentsTranformedToClass:[NSArray class] unconvertibleMarker:unconvertibleMarker];
}

#pragma mark Array of Dictionaries Extraction

- (NSArray *)arrayOfDictionariesForKey:(id)key
{
    return [self.class arrayOfDictionariesFromObject:self.dictionary[key]];
}

- (NSArray *)arrayOfDictionariesForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self.class arrayOfDictionariesFromObject:self.dictionary[key] unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)forcedArrayOfDictionariesForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self.class arrayOfDictionariesFromObject:self.dictionary[key] unconvertibleMarker:unconvertibleMarker] ?: @[];
}

+ (NSArray *)arrayOfDictionariesFromObject:(id)object
{
    return [self.class arrayOfDictionariesFromObject:object unconvertibleMarker:nil];
}

+ (NSArray *)arrayOfDictionariesFromObject:(id)object unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayFromObject:object contentsTranformedToClass:[NSDictionary class] unconvertibleMarker:unconvertibleMarker];
}

#pragma mark Array of Extractors Extraction

- (NSArray *)arrayOfExtractorsForKey:(id)key
{
    return [self.class arrayOfExtractorsFromObject:self.dictionary[key]];
}

- (NSArray *)arrayOfExtractorsForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self.class arrayOfExtractorsFromObject:self.dictionary[key] unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)forcedArrayOfExtractorsForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self.class arrayOfExtractorsFromObject:self.dictionary[key] unconvertibleMarker:unconvertibleMarker] ?: @[];
}

+ (NSArray *)arrayOfExtractorsFromObject:(id)object
{
    return [self arrayOfExtractorsFromObject:object unconvertibleMarker:nil];
}

+ (NSArray *)arrayOfExtractorsFromObject:(id)object unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayFromObject:object contentsTranformedToClass:[self class] unconvertibleMarker:unconvertibleMarker];
}

#pragma mark Type Enforcement Helpers

+ (NSArray *)_arrayFromObject:(id)object contentsTranformedToClass:(Class)class unconvertibleMarker:(id)unconvertibleMarker
{
    NSArray *array = [self arrayFromObject:object];
    if (array && class) {
        array = [self.class _transformArray:array toArrayOfClass:class unconvertibleMarker:unconvertibleMarker];
    }
    return array;
}

+ (id)_transformObject:(id)fromObject toClass:(Class)theClass
{
    BOOL didFail = !fromObject || !theClass || (fromObject == [NSNull null]);
    
    if (theClass == [NSDate class]) {
        NSDecimalNumber *dateTimestamp = [self _transformObject:fromObject toClass:[NSDecimalNumber class]];
        
        if ([dateTimestamp isEqualToNumber:[NSDecimalNumber notANumber]]) {
            dateTimestamp = nil;
        }
        
        if ([dateTimestamp isEqualToNumber:[NSDecimalNumber zero]]) {
            return nil;
        }
        
        if (dateTimestamp) {
            return [NSDate dateWithTimeIntervalSince1970:[dateTimestamp doubleValue]];
        }
        
        return dateTimestamp;
    }
    else if (theClass == [self class]) {
        NSDictionary *dictionary = [self _transformObject:fromObject toClass:[NSDictionary class]];
        if (dictionary) {
            return [self extractorWithDictionary:dictionary];
        }
        return nil;
    }
    
    if (!didFail) {
        fromObject = [self _straightforwardTransformObject:fromObject toClass:theClass];
        if (fromObject) {
            if ([fromObject isKindOfClass:[NSDecimalNumber class]] && [fromObject isEqualToNumber:[NSDecimalNumber notANumber]]) {
                return nil;
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
                    // Flooring/ceiling double instead for these devices
                    double doubleValue = [(NSDecimalNumber *)fromObject doubleValue];
                    NSInteger truncatedValue = doubleValue < 0.0 ? (NSInteger)ceil(doubleValue) : (NSInteger)floor(doubleValue);
                    return @(truncatedValue);
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

+ (NSArray *)_transformArray:(NSArray *)originalArray toArrayOfClass:(Class)toClass unconvertibleMarker:(id)unconvertibleMarker
{
    if (!originalArray) {
        return nil;
    }
    
    NSMutableArray *convertedObjects = [NSMutableArray arrayWithCapacity:originalArray.count];
    for (id originalObject in originalArray) {
        id convertedObject = [self.class _transformObject:originalObject toClass:toClass];
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
