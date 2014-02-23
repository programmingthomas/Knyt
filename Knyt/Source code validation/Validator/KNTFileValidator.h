// KNTFileValidator.h
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

#import "KNTRule.h"

/**
 Utility class that reads source code files and validates them across all of the rules
 */
@interface KNTFileValidator : NSObject

/**
 Uses regular expressions to remove comments from Objective-C source code
 @param source A segment of commented Objective-C source code
 @return A string with the comments removed
 @warning Literally removes everything on each line after // and everything between multiline comments (even if they are in strings)
 */
+ (NSString*)removeComments:(NSString*)source;

/**
 Validates a source file
 @param path The path to the source file to validate
 @return An NSArray containing any failure objects if the file breaks the rules
 */
+ (NSArray*)validateFile:(NSString*)path;

/**
 Validate a source file and apply the additional given rules
 @param path The path to the source file to validate
 @param rules Extra, non-standard rules to apply
 @return An NSArray containing any failure objects if the file breaks the rules
 */
+ (NSArray*)validateFile:(NSString *)path withAdditionalRules:(NSArray*)rules;

@end
