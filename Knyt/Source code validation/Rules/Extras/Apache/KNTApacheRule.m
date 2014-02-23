// KNTApacheRule.m
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

#import "KNTApacheRule.h"

@implementation KNTApacheRule

+ (BOOL)discardCommentsForProcessing {
    return NO;
}

+ (NSArray*)validateSource:(NSString *)source filename:(NSString *)filename {
    static NSRegularExpression * apacheRegex;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        apacheRegex = RX(@"// [\\w\\+]{0,}\\.(h|m)\\n//\\n// Copyright [0-9]{0,4} [\\w\\s]{0,}\\n//\\n// Licensed under the Apache License, Version 2\\.0 \\(the \"License\"\\);\\n// you may not use this file except in compliance with the License\\.\\n// You may obtain a copy of the License at\\n//\\n// http:\\/\\/www\\.apache\\.org\\/licenses\\/LICENSE-2\\.0\\n//\\n// Unless required by applicable law or agreed to in writing, software\\n// distributed under the License is distributed on an \"AS IS\" BASIS,\\n// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied\\.\\n// See the License for the specific language governing permissions and\\n// limitations under the License\\.");
    });
    
    if (![source hasPrefix:[NSString stringWithFormat:@"// %@", filename]]) {
        KNTRuleFailure * failure = [KNTRuleFailure new];
        failure.failureDescription = @"Filename not present on first line of file";
        failure.lineNumber = 1;
        failure.filename = filename;
        return @[failure];
    }
    
    NSTextCheckingResult * result = [apacheRegex firstMatchInString:source options:0 range:source.range];
    
    if (!result || result.range.location != 0) {
        KNTRuleFailure * failure = [KNTRuleFailure new];
        failure.failureDescription = @"Apache license not present in the correct form";
        failure.lineNumber = 1;
        failure.filename = filename;
        return @[failure];
    }
    
    return nil;
}

@end
