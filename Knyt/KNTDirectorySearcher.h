// KNTDirectorySearcher.h
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
 Provides utility functions for finding files of certain types in directorys
 */
@interface KNTDirectorySearcher : NSObject

/**
 Finds all files with a .h or .m extension
 @param directory The directory to search in
 @param recursive Search sub-directories
 @return An array of the full paths to files
 */
+ (NSArray*)findSourceFiles:(NSString*)directory recursive:(BOOL)recursive;

/**
 Finds all files with given types
 @param directory The directory to search in
 @param types An array of strings of extensions (i.e. in the form @".h" or @".m")
 @param recursive Search sub-directories
 @return An array of the full paths to files
 */
+ (NSArray*)findFiles:(NSString*)directory ofTypes:(NSArray*)types recursive:(BOOL)recursive;


@end
