// KNTRule.h
//
// Copyright 2014 Programming Thomas
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import <Foundation/Foundation.h>

#import "KNTRuleFailure.h"

#import "NSString+KNT.h"
#import "NSRegularExpression+KNT.h"

typedef NSString*(^KNTRuleLineValidator)(NSString * line,NSUInteger lineNumber, BOOL*stop);

/**
 Validates source code against a rule
 */
@interface KNTRule : NSObject

/**
 @return YES, by default
 */
+ (BOOL)discardCommentsForProcessing;

/**
 Validates an Objective-C .h/.m file against a rule in the New York Times style guide
 @return An array of failures, if any
 @warning This must be overrided in subclasses. It will cause a failure in execution if you call this superclass' function
 */
+ (NSArray*)validateSource:(NSString*)source filename:(NSString*)filename;

/**
 Splits a string into separate lines
 @param source Objective-C source code
 @return An array of the lines
 */
+ (NSArray*)lines:(NSString*)source;

/**
 Iterates across the lines of a source file and produces an array of failures produced by the validator block
 @param source Objective-C source code
 @param lineValidator A block that will iterate across each line of the file in order. Set *stop = YES to halt iteration. Return nil if there is no failure for this line, but return a message describing the error if there is a failure of some sort
 @return An array of failures
 */
+ (NSArray*)validateLines:(NSString*)source rule:(KNTRuleLineValidator)lineValidator;

@end
