//
//  Extractor.h
//  Extractor
//
//  Created by Neil Daniels on 4/18/15.
//  Copyright (c) 2015 Ebates Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for Extractor.
FOUNDATION_EXPORT double ExtractorVersionNumber;

//! Project version string for Extractor.
FOUNDATION_EXPORT const unsigned char ExtractorVersionString[];

#if TARGET_OS_WATCH
#import <ExtractorWatch/EBTExtractor.h>
#import <ExtractorWatch/EBTExtractor+DirectObject.h>
#else
#import <Extractor/EBTExtractor.h>
#import <Extractor/EBTExtractor+DirectObject.h>
#endif