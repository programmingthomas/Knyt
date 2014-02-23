// KNTArgument.m
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

#import "KNTArgument.h"

static NSString * const KNTArgumentName = @"KNTArgumentName";
static NSString * const KNTOptionsName = @"KNTOptionsName";

@implementation KNTArgument

- (instancetype)initWithArgument:(NSString *)argument options:(NSArray *)options {
    self = [super init];
    if (self) {
        if ([argument hasPrefix:@"-"]) {
            self.argument = [argument substringFromIndex:1];
        }
        else {
            self.argument = argument;
        }
        
        self.options = options ? options : [NSMutableArray new];
    }
    return self;
}

#pragma mark - NSCoding support

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.argument = [aDecoder decodeObjectForKey:KNTArgumentName];
        self.options = [aDecoder decodeObjectForKey:KNTOptionsName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.argument forKey:KNTArgumentName];
    [aCoder encodeObject:self.options forKey:KNTOptionsName];
}

#pragma mark - String representation

- (NSString*)description {
    return [NSString stringWithFormat:@"-%@ %@", self.argument, [self.options componentsJoinedByString:@" "]];
}

@end
