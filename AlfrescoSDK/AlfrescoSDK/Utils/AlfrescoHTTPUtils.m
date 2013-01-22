/*******************************************************************************
 * Copyright (C) 2005-2012 Alfresco Software Limited.
 *
 * This file is part of the Alfresco Mobile SDK.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 ******************************************************************************/

#import "AlfrescoHTTPUtils.h"
#import "AlfrescoNSHTTPRequest.h"
#import "AlfrescoErrors.h"

@implementation AlfrescoHTTPUtils

+ (NSURL *)buildURLFromBaseURLString:(NSString *)baseURL extensionURL:(NSString *)extensionURL
{
    NSMutableString *mutableRequestString = [NSMutableString string];
    if ([baseURL hasSuffix:@"/"] && [extensionURL hasPrefix:@"/"])
    {
        [mutableRequestString appendString:[baseURL substringToIndex:baseURL.length - 1]];
        [mutableRequestString appendString:extensionURL];
    }
    else
    {
        NSString *separator = ([baseURL hasSuffix:@"/"] || [extensionURL hasPrefix:@"/"]) ? @"" : @"/";
        [mutableRequestString appendString:baseURL];
        [mutableRequestString appendString:separator];
        [mutableRequestString appendString:extensionURL];        
    }
    return [NSURL URLWithString:mutableRequestString];
}

+ (void)addRequestObject:(id<AlfrescoHTTPRequest>)request toArray:(NSMutableArray *)requestArray
{
    if (![request isKindOfClass:[AlfrescoNSHTTPRequest class]])
    {
        [requestArray addObject:request];
    }
}

+ (void)removeRequestObject:(id<AlfrescoHTTPRequest>)request fromArray:(NSMutableArray *)requestArray
{
    if (![request isKindOfClass:[AlfrescoNSHTTPRequest class]])
    {
        [requestArray removeObject:request];
    }
}

@end
