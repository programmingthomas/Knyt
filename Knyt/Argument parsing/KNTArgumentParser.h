// KNTArgumentParser.h
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
#import "KNTArgument.h"

/**
 A utility class that parses a set of arguments from the command line
 */
@interface KNTArgumentParser : NSObject

/**
 Parses a set of command line arguments into `KNTArgument` objects
 @param argc The number of arguments
 @param argv An array of C-style strings containing the arguments
 @return An array of KNTArgument objects
 */
+ (NSArray*)parseArgumentsWithCount:(int)argc values:(const char**)argv;

@end
