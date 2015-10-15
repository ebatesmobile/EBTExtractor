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

+ (nullable instancetype)extractorWithDictionary:(nullable NSDictionary *)dictionary;

- (nullable instancetype)initWithDictionary:(nullable NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

@property (nonatomic, copy, readonly, nonnull) NSDictionary *dictionary;

NS_ASSUME_NONNULL_BEGIN

// Primitives

- (BOOL)boolForKey:(id)key;
- (NSInteger)integerForKey:(id)key;
- (NSUInteger)unsignedIntegerForKey:(id)key; // negative values will return 0

// Objects

- (nullable NSNumber *)numberForKey:(id)key; // truncated to integer representation
- (nullable NSString *)stringForKey:(id)key;
- (nullable NSDate *)unixDateForKey:(id)key;
- (nullable NSDecimalNumber *)decimalNumberForKey:(id)key; // never returns NaN
- (nullable NSArray *)arrayForKey:(id)key;
- (nullable NSDictionary *)dictionaryForKey:(id)key;
- (nullable instancetype)extractorForKey:(id)key;

// Typed Arrays

- (nullable NSArray<NSNumber *> *)arrayOfNumbersForKey:(id)key; // values truncated to integer representation
- (nullable NSArray<NSString *> *)arrayOfStringsForKey:(id)key;
- (nullable NSArray<NSDate *> *)arrayOfUnixDatesForKey:(id)key;
- (nullable NSArray<NSDecimalNumber *> *)arrayOfDecimalNumbersForKey:(id)key; // values will never be NaN
- (nullable NSArray<NSArray *> *)arrayOfArraysForKey:(id)key;
- (nullable NSArray<NSDictionary *> *)arrayOfDictionariesForKey:(id)key;
- (nullable NSArray<EBTExtractor *> *)arrayOfExtractorsForKey:(id)key;

- (nullable NSArray *)arrayOfNumbersForKey:(id)key unconvertibleMarker:(nullable id)unconvertibleMarker; // values truncated to integer representation
- (nullable NSArray *)arrayOfStringsForKey:(id)key unconvertibleMarker:(nullable id)unconvertibleMarker;
- (nullable NSArray *)arrayOfUnixDatesForKey:(id)key unconvertibleMarker:(nullable id)unconvertibleMarker;
- (nullable NSArray *)arrayOfDecimalNumbersForKey:(id)key unconvertibleMarker:(nullable id)unconvertibleMarker; // values will never be NaN
- (nullable NSArray *)arrayOfArraysForKey:(id)key unconvertibleMarker:(nullable id)unconvertibleMarker;
- (nullable NSArray *)arrayOfDictionariesForKey:(id)key unconvertibleMarker:(nullable id)unconvertibleMarker;
- (nullable NSArray *)arrayOfExtractorsForKey:(id)key unconvertibleMarker:(nullable id)unconvertibleMarker;

// Forced Objects

- (NSNumber *)forcedNumberForKey:(id)key; // truncated to integer representation
- (NSString *)forcedStringForKey:(id)key;
- (NSDate *)forcedUnixDateForKey:(id)key;
- (NSDecimalNumber *)forcedDecimalNumberForKey:(id)key; // may return NaN
- (NSArray *)forcedArrayForKey:(id)key;
- (NSDictionary *)forcedDictionaryForKey:(id)key;
- (instancetype)forcedExtractorForKey:(id)key;

// Forced Typed Arrays

- (NSArray *)forcedArrayOfNumbersForKey:(id)key unconvertibleMarker:(nullable id)unconvertibleMarker; // values truncated to integer representation
- (NSArray *)forcedArrayOfStringsForKey:(id)key unconvertibleMarker:(nullable id)unconvertibleMarker;
- (NSArray *)forcedArrayOfUnixDatesForKey:(id)key unconvertibleMarker:(nullable id)unconvertibleMarker;
- (NSArray *)forcedArrayOfDecimalNumbersForKey:(id)key unconvertibleMarker:(nullable id)unconvertibleMarker;  // values will never be NaN
- (NSArray *)forcedArrayOfArraysForKey:(id)key unconvertibleMarker:(nullable id)unconvertibleMarker;
- (NSArray *)forcedArrayOfDictionariesForKey:(id)key unconvertibleMarker:(nullable id)unconvertibleMarker;
- (NSArray *)forcedArrayOfExtractorsForKey:(id)key unconvertibleMarker:(nullable id)unconvertibleMarker;

NS_ASSUME_NONNULL_END

@end
