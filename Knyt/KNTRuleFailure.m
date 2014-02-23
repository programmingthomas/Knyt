// KNTRuleFailure.m
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

#import "KNTRuleFailure.h"

@implementation KNTRuleFailure

- (NSString*)description {
    return [NSString stringWithFormat:@"%@ %d: %@", self.filename, (int)self.lineNumber, self.failureDescription];
}

- (NSComparisonResult)compare:(KNTRuleFailure *)failure2 {
    NSComparisonResult filename = [self.filename compare:failure2.filename];
    if (filename == NSOrderedSame) {
        if (self.lineNumber == failure2.lineNumber) {
            return [self.failureDescription compare:failure2.failureDescription];
        }
        else if (self.lineNumber < failure2.lineNumber) {
            return NSOrderedAscending;
        }
        else {
            return NSOrderedDescending;
        }
    }
    else {
        return filename;
    }
}

@end
