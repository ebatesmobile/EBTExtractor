//
// EBTExtractor+DirectObject.h
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

@interface EBTExtractor (DirectObject)

// Primitives

+ (BOOL)boolFromObject:(nullable id)object;
+ (NSInteger)integerFromObject:(nullable id)object;
+ (NSUInteger)unsignedIntegerFromObject:(nullable id)object; // negative values will return 0

// Objects

+ (nullable NSNumber *)numberFromObject:(nullable id)object; // truncated to integer representation
+ (nullable NSString *)stringFromObject:(nullable id)object;
+ (nullable NSDate *)unixDateFromObject:(nullable id)object;
+ (nullable NSDecimalNumber *)decimalNumberFromObject:(nullable id)object; // never returns NaN
+ (nullable NSArray *)arrayFromObject:(nullable id)object;
+ (nullable NSDictionary *)dictionaryFromObject:(nullable id)object;
+ (nullable instancetype)extractorFromObject:(nullable id)object;

// Typed Arrays

+ (nullable NSArray *)arrayOfNumbersFromObject:(nullable id)object; // values truncated to integer representation
+ (nullable NSArray *)arrayOfStringsFromObject:(nullable id)object;
+ (nullable NSArray *)arrayOfUnixDatesFromObject:(nullable id)object;
+ (nullable NSArray *)arrayOfDecimalNumbersFromObject:(nullable id)object; // values will never be NaN
+ (nullable NSArray *)arrayOfArraysFromObject:(nullable id)object;
+ (nullable NSArray *)arrayOfDictionariesFromObject:(nullable id)object;
+ (nullable NSArray *)arrayOfExtractorsFromObject:(nullable id)object;

+ (nullable NSArray *)arrayOfNumbersFromObject:(nullable id)object unconvertibleMarker:(nullable id)unconvertibleMarker; // values truncated to integer representation
+ (nullable NSArray *)arrayOfStringsFromObject:(nullable id)object unconvertibleMarker:(nullable id)unconvertibleMarker;
+ (nullable NSArray *)arrayOfUnixDatesFromObject:(nullable id)object unconvertibleMarker:(nullable id)unconvertibleMarker;
+ (nullable NSArray *)arrayOfDecimalNumbersFromObject:(nullable id)object unconvertibileMarker:(nullable id)unconvertibileMarker; // values will never be NaN
+ (nullable NSArray *)arrayOfArraysFromObject:(nullable id)object unconvertibileMarker:(nullable id)unconvertibleMarker;
+ (nullable NSArray *)arrayOfDictionariesFromObject:(nullable id)object unconvertibleMarker:(nullable id)unconvertibleMarker;
+ (nullable NSArray *)arrayOfExtractorsFromObject:(nullable id)object unconvertibleMarker:(nullable id)unconvertibleMarker;

@end
