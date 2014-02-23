// KNTThreeLetterClassPrefixRule.m
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

#import "KNTThreeLetterClassPrefixRule.h"

@implementation KNTThreeLetterClassPrefixRule

+ (NSArray*)validateSource:(NSString *)source filename:(NSString *)filename {
    static NSRegularExpression * interfaceWithPrefix;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        interfaceWithPrefix = [NSRegularExpression regularExpressionWithPattern:@"@(interface|protocol|implementation)[\\s][A-Z]{3,}" options:NSRegularExpressionAnchorsMatchLines error:nil];
    });
    
    return [KNTRule validateLines:source rule:^NSString *(NSString *line, NSUInteger lineNumber, BOOL *stop) {
        NSString * trimmedLine = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimmedLine hasPrefix:@"@interface"] || [trimmedLine hasPrefix:@"@interface"] || [trimmedLine hasPrefix:@"@protocol"]) {
            NSTextCheckingResult * match = [interfaceWithPrefix firstMatchInString:line options:NSMatchingAnchored range:line.range];
            if (!match) {
                return @"Class or protocol definition doesn't use a three uppercase character prefix";
            }
        }
        return nil;
    }];
}

@end
