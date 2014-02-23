// KNTBooleanComparisonRule.m
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


#import "KNTBooleanComparisonRule.h"

@implementation KNTBooleanComparisonRule

+ (NSArray*)validateSource:(NSString *)source filename:(NSString *)filename {
    //I tested these regular expressions on http://regexpal.com (quite a useful site...)
    //The \\s is used for escaping (the real thing uses a single backslash, but Objective-C doesn't have native regular expressions)
    NSRegularExpression * regexLeft = [NSRegularExpression regularExpressionWithPattern:@"(YES|NO|(N|n)il)(\\s){0,}(!|=)=" options:0 error:nil];
    NSRegularExpression * regexRight = [NSRegularExpression regularExpressionWithPattern:@"(!|=)=(\\s){0,}(YES|NO|(N|n)il)" options:0 error:nil];
    
    
    return [KNTRule validateLines:source rule:^NSString *(NSString *line, NSUInteger lineNumber, BOOL *stop) {
        if ([regexLeft hasAnyMatches:line] || [regexRight hasAnyMatches:line]) {
            return @"Do not do comparisons with YES, NO, Nil or nil";
        }
        return nil;
    }];
}

@end
