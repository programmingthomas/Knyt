// KNTArgument.h
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

/**
 Represents a command line argument (-something) followed by a series of options (arguments not starting with a dash)
 */
@interface KNTArgument : NSObject<NSCoding>

/**
 Creates an argument object and removes the dash from the argument name
 @return A new KNTArgument object
 @param argument The argument, optionally with a preceding dash
 @param options An options that followed the argument
 */
- (instancetype)initWithArgument:(NSString*)argument options:(NSArray*)options;

/**
 The argument that was used, with the dash prefix removed
 */
@property NSString * argument;

/**
 An array of strings of the options used with that argument
 */
@property NSArray * options;

@end