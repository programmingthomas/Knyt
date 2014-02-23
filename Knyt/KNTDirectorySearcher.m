// KNTDirectorySearcher.m
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

#import "KNTDirectorySearcher.h"

@implementation KNTDirectorySearcher

+ (NSArray*)findSourceFiles:(NSString *)directory recursive:(BOOL)recursive {
    return [KNTDirectorySearcher findFiles:directory ofTypes:@[@".h",@".m"] recursive:recursive];
}

+ (NSArray*)findFiles:(NSString *)directory ofTypes:(NSArray *)types recursive:(BOOL)recursive {
    NSMutableArray * allFiles = [NSMutableArray new];
    
    NSURL * directoryUrl = [NSURL fileURLWithPath:directory];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    NSDirectoryEnumerator * enumerator = [fileManager enumeratorAtURL:directoryUrl includingPropertiesForKeys:@[NSURLNameKey, NSURLIsDirectoryKey] options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:nil];
    
    for (NSURL * url in enumerator) {
        NSString * filename;
        [url getResourceValue:&filename forKey:NSURLNameKey error:nil];
        NSNumber * isDirectory;
        [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
        
        
        
        if (!isDirectory.boolValue) {
            for (NSString * suffix in types) {
                if ([[filename lowercaseString] hasSuffix:[suffix lowercaseString]]) {
                    [allFiles addObject:[url path]];
                    break;
                }
            }
        }
        
        if ((isDirectory.boolValue && [filename hasPrefix:@"_"]) || !recursive) {
            [enumerator skipDescendants];
            continue;
        }
    }
    
    return allFiles;
}

@end
