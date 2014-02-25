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
    //Xcode's unit tests seem to create names using Product_NameTests as the class name, so I'll ignore those
    if ([filename hasSuffix:@"Tests.m"]) {
        return nil;
    }
    
    static NSRegularExpression * interfaceWithPrefix;
    static NSRegularExpression * interfaceWithCategory;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        interfaceWithPrefix = RX(@"@(interface|protocol|implementation)[\\s][A-Z]{3,}");
        interfaceWithCategory = RX(@"@(interface|protocol|implementation)[\\s][A-z]{0,}[\\s]\\(");
    });
    
    return [KNTRule validateLines:source rule:^NSString *(NSString *line, NSUInteger lineNumber, BOOL *stop) {
        NSString * trimmedLine = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimmedLine hasPrefix:@"@interface"] || [trimmedLine hasPrefix:@"@implementation"] || [trimmedLine hasPrefix:@"@protocol"]) {
            //Fail if it is not a category and it doesn't have a three letter prefix
            if (![interfaceWithPrefix hasAnyMatches:trimmedLine] && ![interfaceWithCategory hasAnyMatches:trimmedLine]) {
                return @"Class or protocol definition doesn't use a three uppercase character prefix";
            }
        }
        return nil;
    }];
}

@end
