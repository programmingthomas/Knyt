// KNTFourSpacesRule.m
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

#import "KNTFourSpacesRule.h"

@implementation KNTFourSpacesRule

+ (NSUInteger)openingSpaces:(NSString*)line {
    NSUInteger count = 0;
    unichar buffer[line.length + 1];
    [line getCharacters:buffer];
    for (NSUInteger i = 0; i < line.length; i++) {
        if (buffer[i] == ' ') {
            count++;
        }
        else {
            break;
        }
    }
    return count;
}

+ (NSArray*)validateSource:(NSString *)source filename:(NSString *)filename {
    return [KNTRule validateLines:source rule:^NSString *(NSString *line, NSUInteger lineNumber, BOOL *stop) {
        NSUInteger openingSpaces = [KNTFourSpacesRule openingSpaces:line];
        if (openingSpaces % 4 != 0 && openingSpaces != 1) {
            return [NSString stringWithFormat:@"Indentation used %d space%@ (not multiple of 4)", (int)openingSpaces, openingSpaces != 1 ? @"s" : @""]  ;
        }
        return nil;
    }];
}

@end
