// KNTRule.m
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

#import "KNTRule.h"

@implementation KNTRule

+ (BOOL)discardCommentsForProcessing {
    return YES;
}

+ (NSArray*)validateSource:(NSString *)source filename:(NSString *)filename {
    NSAssert(NO, @"Subclasses must override %s", __PRETTY_FUNCTION__);
    return [NSArray new];
}

+ (NSArray*)lines:(NSString *)source {
    return [source componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

+ (NSArray*)validateLines:(NSString *)source rule:(KNTRuleLineValidator)lineValidator {
    NSArray * lines = [KNTRule lines:source];
    NSMutableArray * failures = [NSMutableArray new];
    for (NSString * line in lines) {
        BOOL stop;
        NSUInteger lineNumber = 1 + [lines indexOfObject:line];
        NSString * failure = lineValidator(line, 1 + [lines indexOfObject:line], &stop);
        if (failure) {
            KNTRuleFailure * ruleFailure = [KNTRuleFailure new];
            ruleFailure.lineNumber = lineNumber;
            ruleFailure.failureDescription = failure;
            [failures addObject:ruleFailure];
        }
        if (stop) {
            break;
        }
    }
    return failures;
}

@end
