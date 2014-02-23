// KNTNoOneLinersRule.m
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

#import "KNTNoOneLinersRule.h"

@implementation KNTNoOneLinersRule

+ (NSArray*)validateSource:(NSString *)source filename:(NSString *)filename {
    static NSRegularExpression * allButElseRegex, * elseRegex;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allButElseRegex = [NSRegularExpression regularExpressionWithPattern:@"(^|(\\s){1,})(if|else if|while|for|switch)(\\s){0,}\\(" options:0 error:nil];
        elseRegex = [NSRegularExpression regularExpressionWithPattern:@"else(\\s){0,}\\{" options:0 error:nil];
    });
    
    return [KNTRule validateLines:source rule:^NSString *(NSString *line, NSUInteger lineNumber, BOOL *stop) {
        NSString * trimmedLine = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (([allButElseRegex hasAnyMatches:line] || [elseRegex hasAnyMatches:line]) && ![trimmedLine hasSuffix:@"{"]) {
            return [NSString stringWithFormat:@"One-liners aren't funny. Use braces to avoid errors (%@)", trimmedLine];
        }
        return nil;
    }];
}

@end
