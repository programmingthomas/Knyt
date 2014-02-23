// KNTDeallocBeforeInitRule.m
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

#import "KNTDeallocBeforeInitRule.h"

@implementation KNTDeallocBeforeInitRule

+ (NSArray*)validateSource:(NSString *)source filename:(NSString *)filename {
    //This method is a little more complex because there could be multiple implementations per .m file
    if ([filename hasSuffix:@".m"]) {
        
        //Regular expressions
        NSRegularExpression * implementation = [NSRegularExpression regularExpressionWithPattern:@"^[\\s]*.?@implementation" options:0 error:nil];
        NSRegularExpression * end = [NSRegularExpression regularExpressionWithPattern:@"^[\\s]*.?@end" options:0 error:nil];
        NSRegularExpression * dealloc = [NSRegularExpression regularExpressionWithPattern:@"^[\\s]*.?-[\\s]*.?\\(void\\)dealloc" options:0 error:nil];
        NSRegularExpression * init = [NSRegularExpression regularExpressionWithPattern:@"^[\\s]*.?-[\\s]*.?\\((id|instancetype)\\)init" options:0 error:nil];
        
        NSArray * lines = [KNTRule lines:source];
        NSMutableArray * failures = [NSMutableArray new];
    
        BOOL foundImplementation = NO, foundDealloc = NO, foundInit = NO;
        
        for (NSString * line in lines) {
            if ([implementation hasAnyMatches:line] && !foundImplementation) {
                foundImplementation = YES;
                foundDealloc = foundInit = NO;
                continue;
            }
            
            if ([end hasAnyMatches:line] && foundImplementation) {
                foundImplementation = NO;
                continue;
            }
            
            if (foundImplementation) {
                if ([dealloc hasAnyMatches:line]) {
                    foundDealloc = YES;
                    if (foundInit) {
                        KNTRuleFailure * failure = [KNTRuleFailure new];
                        failure.lineNumber = [lines indexOfObject:line];
                        failure.failureDescription = @"Dealloc should come before init";
                        [failures addObject:failure];
                    }
                }
                
                if ([init hasAnyMatches:line]) {
                    foundInit = YES;
                }
            }
        }
        
        return failures;
    }
    return nil;
}

@end
