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

+ (BOOL)boolFromObject:(id)object;
+ (NSInteger)integerFromObject:(id)object;
+ (NSUInteger)unsignedIntegerFromObject:(id)object; // negative values will return 0

// Objects

+ (NSNumber *)numberFromObject:(id)object; // truncated to integer representation
+ (NSString *)stringFromObject:(id)object;
+ (NSDate *)unixDateFromObject:(id)object;
+ (NSDecimalNumber *)decimalNumberFromObject:(id)object; // never returns NaN
+ (NSArray *)arrayFromObject:(id)object;
+ (NSDictionary *)dictionaryFromObject:(id)object;
+ (instancetype)extractorFromObject:(id)object;

// Typed Arrays

+ (NSArray *)arrayOfNumbersFromObject:(id)object; // values truncated to integer representation
+ (NSArray *)arrayOfStringsFromObject:(id)object;
+ (NSArray *)arrayOfUnixDatesFromObject:(id)object;
+ (NSArray *)arrayOfDecimalNumbersFromObject:(id)object; // values will never be NaN
+ (NSArray *)arrayOfArraysFromObject:(id)object;
+ (NSArray *)arrayOfDictionariesFromObject:(id)object;
+ (NSArray *)arrayOfExtractorsFromObject:(id)object;

+ (NSArray *)arrayOfNumbersFromObject:(id)object unconvertibleMarker:(id)unconvertibleMarker; // values truncated to integer representation
+ (NSArray *)arrayOfStringsFromObject:(id)object unconvertibleMarker:(id)unconvertibleMarker;
+ (NSArray *)arrayOfUnixDatesFromObject:(id)object unconvertibleMarker:(id)unconvertibleMarker;
+ (NSArray *)arrayOfDecimalNumbersFromObject:(id)object unconvertibileMarker:(id)unconvertibileMarker; // values will never be NaN
+ (NSArray *)arrayOfArraysFromObject:(id)object unconvertibileMarker:(id)unconvertibleMarker;
+ (NSArray *)arrayOfDictionariesFromObject:(id)object unconvertibleMarker:(id)unconvertibleMarker;
+ (NSArray *)arrayOfExtractorsFromObject:(id)object unconvertibleMarker:(id)unconvertibleMarker;

@end
