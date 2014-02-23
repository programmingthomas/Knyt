// KNTDefinedConstantsRule.h
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

#import "KNTDefinedConstantsRule.h"

@implementation KNTDefinedConstantsRule

+ (NSArray*)validateSource:(NSString *)source filename:(NSString *)filename {
    static NSRegularExpression * define;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        define = RX(@"^[\\s]{0,}#define[\\s]{0,}[A-z]{1,}[\\s]{0,}((@|)(\".*?\"|\\[.*?\\]|\\{.*?\\}|[0-9]{1,}))");
    });
    
    return [KNTRule validateLines:source rule:^NSString *(NSString *line, NSUInteger lineNumber, BOOL *stop) {
        if ([define hasAnyMatches:line]) {
            return @"Do not use #define for constant values";
        }
        return nil;
    }];
}

@end
