// main.m
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

#import <Foundation/Foundation.h>

#import "KNTArgumentParser.h"
#import "KNTDirectorySearcher.h"
#import "KNTFileValidator.h"

//Additional rules
#import "KNTApacheRule.h"

void validate_directory(NSString * path, BOOL recursive, NSArray * additionalRules);
void validate_file(NSString * path, NSArray * additionalRules);
void print_failures(NSArray * failures);

int main(int argc, const char * argv[]) {

    @autoreleasepool {
        NSArray * arguments = [KNTArgumentParser parseArgumentsWithCount:argc values:argv];
        
        if (!arguments.count) {
            printf("No arguments supplied, use ./knyt -help to get help\n");
            return 1;
        }
        else {
            KNTArgument * primaryArgument = [arguments firstObject];
            
            //Load additional rules
            NSMutableArray * additionalRules = [NSMutableArray new];
            
            for (KNTArgument * argument in arguments) {
                if ([argument.argument isEqualToString:@"apache"]) {
                    [additionalRules addObject:[KNTApacheRule class]];
                }
            }
            
            if ([primaryArgument.argument hasPrefix:@"d"]) {
                validate_directory(primaryArgument.options[0], [primaryArgument.argument hasSuffix:@"r"], additionalRules);
            }
            else if ([primaryArgument.argument isEqualToString:@"f"]) {
                validate_file(primaryArgument.options[0], additionalRules);
            }
            else if ([primaryArgument.argument isEqualToString:@"version"] || [primaryArgument.argument isEqualToString:@"v"]) {
                printf("Knyt 1.0.0\n");
            }
            else if ([primaryArgument.argument isEqualToString:@"help"]) {
                printf("HELP:\n");
                printf("\t-d directory: Validate all files in directory\n");
                printf("\t-dr diretory: Validate all files in directory (recursive)\n");
                printf("\t-v: Print the version number\n");
                printf("Additional validation rules:\n");
                printf("\t-apache: Ensure that the Apache license is in the correct form in each file\n");
            }
        }
    }
    return 0;
}

void validate_directory(NSString * path, BOOL recursive, NSArray * additionalRules) {
    NSArray * files = [KNTDirectorySearcher findSourceFiles:path recursive:recursive];
    NSMutableArray * allFailures = [NSMutableArray new];
    for (NSString * file in files) {
        [allFailures addObjectsFromArray:[KNTFileValidator validateFile:file withAdditionalRules:additionalRules]];
    }
    print_failures(allFailures);
}

void validate_file(NSString * path, NSArray * additionalRules) {
    print_failures([KNTFileValidator validateFile:path withAdditionalRules:additionalRules]);
}

void print_failures(NSArray * failures) {
    NSArray * allFailures = [failures sortedArrayUsingSelector:@selector(compare:)];
    for (KNTRuleFailure * failure in allFailures) {
        printf("%s\n", failure.description.UTF8String);
    }
    if (allFailures.count) {
        printf("Total of %d failures\n", (int)allFailures.count);
    }
}
