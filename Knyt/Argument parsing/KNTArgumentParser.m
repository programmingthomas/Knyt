// KNTArgumentParser.m
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

#import "KNTArgumentParser.h"

@implementation KNTArgumentParser

+ (NSArray*)argumentsConvertedToNSTypes:(int)argc values:(const char**)argv {
    NSMutableArray * values = [NSMutableArray new];
    for (int n = 0; n < argc; n++) {
        if (strlen(argv[n])) {
            NSString * str = [NSString stringWithUTF8String:argv[n]];
            if (str) {
                [values addObject:str];
            }
        }
    }
    return values;
}

+ (NSArray*)parseArgumentsWithCount:(int)argc values:(const char **)argv {
    NSArray * allArguments = [KNTArgumentParser argumentsConvertedToNSTypes:argc values:argv];
    NSMutableArray * arguments = [NSMutableArray new];
    if (allArguments.count) {
        NSString * currentArgument;
        NSMutableArray * currentOptions;
        for (NSString * arg in allArguments) {
            if ([arg hasPrefix:@"-"]) {
                if (currentArgument) {
                    KNTArgument * argument = [[KNTArgument alloc] initWithArgument:currentArgument options:currentOptions];
                    [arguments addObject:argument];
                }
                currentArgument = arg;
                currentOptions = [NSMutableArray new];
            }
            else if (currentArgument && currentOptions) {
                [currentOptions addObject:arg];
            }
        }
        [arguments addObject:[[KNTArgument alloc] initWithArgument:currentArgument options:currentOptions]];
    }
    return arguments;
}

@end
