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
    return [[self alloc] initWithDictionary:dictionary];
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
    return [[self numberForKey:key] boolValue];
}

- (NSInteger)integerForKey:(id)key
{
    return [[self numberForKey:key] integerValue];
}

- (NSUInteger)unsignedIntegerForKey:(id)key
{
    if ([[self numberForKey:key] integerValue] <= 0) {
        return 0;
    }
    return [[self numberForKey:key] unsignedIntegerValue];
}

#pragma mark Objects

#pragma mark Number Extraction

- (NSNumber *)numberForKey:(id)key
{
    return [self _numberForKey:key forceObject:NO];
}

- (NSNumber *)forcedNumberForKey:(id)key
{
    return [self _numberForKey:key forceObject:YES];
}

- (NSNumber *)_numberForKey:(id)key forceObject:(BOOL)forceObject
{
    return [self _objectForKey:key expectedClass:[NSNumber class] forceObject:forceObject];
}

#pragma mark String Extraction

- (NSString *)stringForKey:(id)key
{
    return [self _stringForKey:key forceObject:NO];
}

- (NSString *)forcedStringForKey:(id)key
{
    return [self _stringForKey:key forceObject:YES];
}

- (NSString *)_stringForKey:(id)key forceObject:(BOOL)forceObject
{
    return [self _objectForKey:key expectedClass:[NSString class] forceObject:forceObject];
}

#pragma mark Unix Date Extraction

- (NSDate *)unixDateForKey:(id)key
{
    return [self _unixDateForKey:key forceObject:NO];
}

- (NSDate *)forcedUnixDateForKey:(id)key
{
    return [self _unixDateForKey:key forceObject:YES];
}

- (NSDate *)_unixDateForKey:(id)key forceObject:(BOOL)forceObject
{
    return [self _objectForKey:key expectedClass:[NSDate class] forceObject:forceObject];
}

#pragma mark Decimal Number Extraction

- (NSDecimalNumber *)decimalNumberForKey:(id)key
{
    return [self _decimalNumberForKey:key forceObject:NO];
}

- (NSDecimalNumber *)forcedDecimalNumberForKey:(id)key
{
    return [self _decimalNumberForKey:key forceObject:YES];
}

- (NSDecimalNumber *)_decimalNumberForKey:(id)key forceObject:(BOOL)forceObject
{
    return [self _objectForKey:key expectedClass:[NSDecimalNumber class] forceObject:forceObject];
}

#pragma mark Array Extraction

- (NSArray *)arrayForKey:(id)key
{
    return [self _arrayForKey:key forceObject:NO];
}

- (NSArray *)forcedArrayForKey:(id)key
{
    return [self _arrayForKey:key forceObject:YES];
}

- (NSArray *)_arrayForKey:(id)key forceObject:(BOOL)forceObject
{
    return [self _objectForKey:key expectedClass:[NSArray class] forceObject:forceObject];
}

#pragma mark Dictionary Extraction

- (NSDictionary *)dictionaryForKey:(id)key
{
    return [self _dictionaryForKey:key forceObject:NO];
}

- (NSDictionary *)forcedDictionaryForKey:(id)key
{
    return [self _dictionaryForKey:key forceObject:YES];
}

- (NSDictionary *)_dictionaryForKey:(id)key forceObject:(BOOL)forceObject
{
    return [self _objectForKey:key expectedClass:[NSDictionary class] forceObject:forceObject];
}

#pragma mark Extractor Extraction

- (instancetype)extractorForKey:(id)key
{
    return [self _extractorForKey:key forceObject:NO];
}

- (instancetype)forcedExtractorForKey:(id)key
{
    return [self _extractorForKey:key forceObject:YES];
}

- (instancetype)_extractorForKey:(id)key forceObject:(BOOL)forceObject
{
    return [self _objectForKey:key expectedClass:[self class] forceObject:forceObject];
}

#pragma mark Typed Arrays Extraction

#pragma mark Array of Numbers Extraction

- (NSArray *)arrayOfNumbersForKey:(id)key
{
    return [self _arrayOfNumbersForKey:key forceArrayObject:NO unconvertibleMarker:nil];
}

- (NSArray *)arrayOfNumbersForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayOfNumbersForKey:key forceArrayObject:NO unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)forcedArrayOfNumbersForKey:(id)key
{
    return [self _arrayOfNumbersForKey:key forceArrayObject:YES unconvertibleMarker:nil];
}

- (NSArray *)forcedArrayOfNumbersForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayOfNumbersForKey:key forceArrayObject:YES unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)_arrayOfNumbersForKey:(id)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayForKey:key contentsTranformedToClass:[NSNumber class] forceArrayObject:forceArrayObject unconvertibleMarker:unconvertibleMarker];
}

#pragma mark Array of Strings Extraction

- (NSArray *)arrayOfStringsForKey:(id)key
{
    return [self _arrayOfStringsForKey:key forceArrayObject:NO unconvertibleMarker:nil];
}

- (NSArray *)arrayOfStringsForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayOfStringsForKey:key forceArrayObject:NO unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)forcedArrayOfStringsForKey:(id)key
{
    return [self _arrayOfStringsForKey:key forceArrayObject:YES unconvertibleMarker:nil];
}

- (NSArray *)forcedArrayOfStringsForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayOfStringsForKey:key forceArrayObject:YES unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)_arrayOfStringsForKey:(id)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayForKey:key contentsTranformedToClass:[NSString class] forceArrayObject:forceArrayObject unconvertibleMarker:unconvertibleMarker];
}

#pragma mark Array of Unix Dates Extraction

- (NSArray *)arrayOfUnixDatesForKey:(id)key
{
    return [self _arrayOfUnixDatesForKey:key forceArrayObject:NO unconvertibleMarker:nil];
}

- (NSArray *)arrayOfUnixDatesForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayOfUnixDatesForKey:key forceArrayObject:NO unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)forcedArrayOfUnixDatesForKey:(id)key
{
    return [self _arrayOfUnixDatesForKey:key forceArrayObject:YES unconvertibleMarker:nil];
}

- (NSArray *)forcedArrayOfUnixDatesForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayOfUnixDatesForKey:key forceArrayObject:YES unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)_arrayOfUnixDatesForKey:(id)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayForKey:key contentsTranformedToClass:[NSDate class] forceArrayObject:forceArrayObject unconvertibleMarker:unconvertibleMarker];
}

#pragma mark Array of Decimal Numbers Extraction

- (NSArray *)arrayOfDecimalNumbersForKey:(id)key
{
    return [self _arrayOfDecimalNumbersForKey:key forceArrayObject:NO unconvertibleMarker:nil];
}

- (NSArray *)arrayOfDecimalNumbersForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayOfDecimalNumbersForKey:key forceArrayObject:NO unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)forcedArrayOfDecimalNumbersForKey:(id)key
{
    return [self _arrayOfDecimalNumbersForKey:key forceArrayObject:YES unconvertibleMarker:nil];
}

- (NSArray *)forcedArrayOfDecimalNumbersForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayOfDecimalNumbersForKey:key forceArrayObject:YES unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)_arrayOfDecimalNumbersForKey:(id)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayForKey:key contentsTranformedToClass:[NSDecimalNumber class] forceArrayObject:forceArrayObject unconvertibleMarker:unconvertibleMarker];
}

#pragma mark Array of Arrays Extraction

- (NSArray *)arrayOfArraysForKey:(id)key
{
    return [self _arrayOfArraysForKey:key forceArrayObject:NO unconvertibleMarker:nil];
}

- (NSArray *)arrayOfArraysForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayOfArraysForKey:key forceArrayObject:NO unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)forcedArrayOfArraysForKey:(id)key
{
    return [self _arrayOfArraysForKey:key forceArrayObject:YES unconvertibleMarker:nil];
}

- (NSArray *)forcedArrayOfArraysForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayOfArraysForKey:key forceArrayObject:YES unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)_arrayOfArraysForKey:(id)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayForKey:key contentsTranformedToClass:[NSArray class] forceArrayObject:forceArrayObject unconvertibleMarker:unconvertibleMarker];
}

#pragma mark Array of Dictionaries Extraction

- (NSArray *)arrayOfDictionariesForKey:(id)key
{
    return [self _arrayOfDictionariesForKey:key forceArrayObject:NO unconvertibleMarker:nil];
}

- (NSArray *)arrayOfDictionariesForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayOfDictionariesForKey:key forceArrayObject:NO unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)forcedArrayOfDictionariesForKey:(id)key
{
    return [self _arrayOfDictionariesForKey:key forceArrayObject:YES unconvertibleMarker:nil];
}

- (NSArray *)forcedArrayOfDictionariesForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayOfDictionariesForKey:key forceArrayObject:YES unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)_arrayOfDictionariesForKey:(id)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayForKey:key contentsTranformedToClass:[NSDictionary class] forceArrayObject:forceArrayObject unconvertibleMarker:unconvertibleMarker];
}

#pragma mark Array of Extractors Extraction

- (NSArray *)arrayOfExtractorsForKey:(id)key
{
    return [self _arrayOfExtractorsForKey:key forceArrayObject:NO unconvertibleMarker:nil];
}

- (NSArray *)arrayOfExtractorsForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayOfExtractorsForKey:key forceArrayObject:NO unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)forcedArrayOfExtractorsForKey:(id)key
{
    return [self _arrayOfExtractorsForKey:key forceArrayObject:YES unconvertibleMarker:nil];
}

- (NSArray *)forcedArrayOfExtractorsForKey:(id)key unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayOfExtractorsForKey:key forceArrayObject:YES unconvertibleMarker:unconvertibleMarker];
}

- (NSArray *)_arrayOfExtractorsForKey:(id)key forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(id)unconvertibleMarker
{
    return [self _arrayForKey:key contentsTranformedToClass:[self class] forceArrayObject:forceArrayObject unconvertibleMarker:unconvertibleMarker];
}

#pragma mark Type Enforcement Helpers

- (id)_objectForKey:(id)key expectedClass:(Class)theClass forceObject:(BOOL)forceObject
{
    return [self.class _transformObject:self.dictionary[key] toClass:theClass forceObject:forceObject];
}

- (NSArray *)_arrayForKey:(id)key contentsTranformedToClass:(Class)class forceArrayObject:(BOOL)forceArrayObject unconvertibleMarker:(id)unconvertibleMarker
{
    NSArray *array = [self _arrayForKey:key forceObject:forceArrayObject];
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
    else if (theClass == [self class]) {
        NSDictionary *dictionary = [self _transformObject:fromObject toClass:[NSDictionary class] forceObject:forceObject];
        if (dictionary) {
            return [self extractorWithDictionary:dictionary];
        }
        else if (forceObject) {
            return [self extractorWithDictionary:@{}];
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

+ (NSArray *)_transformArray:(NSArray *)originalArray toArrayOfClass:(Class)toClass unconvertibleMarker:(id)unconvertibleMarker
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
