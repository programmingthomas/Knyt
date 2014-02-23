// KNTInstanceTypeNotIdRule.m
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

#import "KNTInstanceTypeNotIdRule.h"

@implementation KNTInstanceTypeNotIdRule

+ (NSArray*)validateSource:(NSString *)source filename:(NSString *)filename {
    static NSRegularExpression * regex;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"^[\\s]*.?-[\\s]*.?\\(id\\)init" options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    });
    
    return [KNTRule validateLines:source rule:^NSString *(NSString *line, NSUInteger lineNumber, BOOL *stop) {
        if ([regex hasAnyMatches:line]) {
            return @"Return type of init methods should be (instancetype)";
        }
        return nil;
    }];
}

@end
