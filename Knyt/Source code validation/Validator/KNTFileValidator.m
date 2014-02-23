// KNTFileValidator.m
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

#import "KNTFileValidator.h"

//Rule validator subclasses
#import "KNTSpacesNotTabsRule.h"
#import "KNTFourSpacesRule.h"
#import "KNTSpaceAfterScopeRule.h"
#import "KNTBraceNotOnNewlineRule.h"
#import "KNTNoOneLinersRule.h"
#import "KNTEnumRule.h"
#import "KNTBooleanComparisonRule.h"
#import "KNTCGGeometryRule.h"
#import "KNTThreeLetterClassPrefixRule.h"
#import "KNTInstanceTypeNotIdRule.h"
#import "KNTDeallocBeforeInitRule.h"
#import "KNTLiteralsRule.h"
#import "KNTDefinedConstantsRule.h"

@implementation KNTFileValidator

+ (NSArray*)ruleSubclasses {
    static NSArray * subclasses;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        subclasses = @[
                        [KNTSpacesNotTabsRule class],
                        [KNTFourSpacesRule class],
                        [KNTSpaceAfterScopeRule class],
                        [KNTBraceNotOnNewlineRule class],
                        [KNTNoOneLinersRule class],
                        [KNTEnumRule class],
                        [KNTBooleanComparisonRule class],
                        [KNTCGGeometryRule class],
                        [KNTThreeLetterClassPrefixRule class],
                        [KNTInstanceTypeNotIdRule class],
                        [KNTDeallocBeforeInitRule class],
                        [KNTLiteralsRule class],
                        [KNTDefinedConstantsRule class]
        ];
    });
    
    return subclasses;
}

+ (NSArray*)validateFile:(NSString *)path {
    return [KNTFileValidator validateFile:path withAdditionalRules:nil];
}

+ (NSString*)removeComments:(NSString*)source {
    static NSRegularExpression * singleLine, * multiLine;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //Uses lookaheads and look behinds because this regular expression was finding 'comments' in other regular expressions (see the Apache rule file, for example)
        singleLine = [NSRegularExpression regularExpressionWithPattern:@"(?<![\\S\"])(\\/\\/.*?($|\\n))(?![\\S\"])" options:NSRegularExpressionDotMatchesLineSeparators error:nil];
        multiLine = [NSRegularExpression regularExpressionWithPattern:@"\\/\\*.*?\\*\\/" options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    });
    
    //Replaces with a single line to ensure the line count remains the same
    NSString * singleLineCommentsRemoved = [singleLine stringByReplacingMatchesInString:source options:0 range:source.range withTemplate:@"\n"];
    
    //TODO: Fix multi-line comment regex
    //Currently the issue with this is that it doesn't take line breaks into account properly, so the line number reported by the program at the end really needs to be adapted to account for whitespace created by removing multi-line comments
//    NSString * multiLineCommentsRemoved = [multiLine stringByReplacingMatchesInString:singleLineCommentsRemoved options:0 range:singleLineCommentsRemoved.range withTemplate:@""];
    
    return singleLineCommentsRemoved;
}

+ (NSArray*)validateFile:(NSString *)path withAdditionalRules:(NSArray *)rules {
    NSArray * allRules = [[KNTFileValidator ruleSubclasses] arrayByAddingObjectsFromArray:rules];
    
    NSMutableArray * ruleFailures = [NSMutableArray new];
    
    NSError * fileIOError;
    NSData * data = [NSData dataWithContentsOfFile:path options:0 error:&fileIOError];
    
    if (fileIOError) {
        NSLog(@"I/O Error: %@", fileIOError);
        return ruleFailures;
    }
    
    NSString * fileContents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString * fileContentsNoComments = [KNTFileValidator removeComments:fileContents];
    
    NSString * filename = path.lastPathComponent;
    
    for (Class class in allRules) {
        NSString * fileContentsForProcessing = fileContents;
        if (((BOOL)[class performSelector:@selector(discardCommentsForProcessing)])) {
            fileContentsForProcessing = fileContentsNoComments;
        }
        NSArray * failures = [class performSelector:@selector(validateSource:filename:) withObject:fileContentsForProcessing withObject:filename];
        if (failures && [failures isKindOfClass:[NSArray class]]) {
            for (KNTRuleFailure * failure in failures) {
                failure.filename = [path lastPathComponent];
            }
            [ruleFailures addObjectsFromArray:failures];
        }
    }
    
    return ruleFailures;
}

@end
