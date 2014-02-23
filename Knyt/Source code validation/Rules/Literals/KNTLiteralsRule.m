// KNTLiteralsRule.m
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

#import "KNTLiteralsRule.h"

@implementation KNTLiteralsRule

+ (NSArray*)validateSource:(NSString *)source filename:(NSString *)filename {
    static NSRegularExpression * number, * array, * dictionary;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        number = RX(@"(NSNumber number|NSNumber alloc] init)With");
        array = RX(@"(NSArray array|NSArray alloc] init)(With|])");
        dictionary = RX(@"(NSDictionary dictionary|NSDictionary alloc] init)(]|WithObjects)");
    });
    
    return [KNTRule validateLines:source rule:^NSString *(NSString *line, NSUInteger lineNumber, BOOL *stop) {
        if ([number hasAnyMatches:line]) {
            return @"Use @() literal for creating NSNumber objects";
        }
        if ([array hasAnyMatches:line]) {
            return @"Use @[] literal for creating NSArray objects";
        }
        if ([dictionary hasAnyMatches:line]) {
            return @"Use @{:} literal for creating NSDictionary objects";
        }
        return nil;
    }];
}

@end
