// KNTCGGeometryRule.m
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

#import "KNTCGGeometryRule.h"

@implementation KNTCGGeometryRule

+ (NSArray*)validateSource:(NSString *)source filename:(NSString *)filename {
    //Double backslash used for escaping
    NSRegularExpression * origin = RX(@"\\.origin\\.(x|y)");
    NSRegularExpression * size = RX(@"\\.size\\.(width|height)");
    return [KNTRule validateLines:source rule:^NSString *(NSString *line, NSUInteger lineNumber, BOOL *stop) {
        if ([origin hasAnyMatches:line]) {
            return @"Use CGRectGetMinX/MinY instead of rectangle origin";
        }
        else if ([size hasAnyMatches:line]) {
            return @"Use CGRectGetWidth/Height instead of rectangle size";
        }
        return nil;
    }];
}

@end
