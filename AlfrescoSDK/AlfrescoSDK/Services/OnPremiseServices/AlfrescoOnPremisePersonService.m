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

#import "AlfrescoOnPremisePersonService.h"
#import "AlfrescoInternalConstants.h"
#import "AlfrescoAuthenticationProvider.h"
#import "AlfrescoBasicAuthenticationProvider.h"
#import "AlfrescoErrors.h"
#import "AlfrescoHTTPUtils.h"
#import "AlfrescoPagingUtils.h"

@interface AlfrescoOnPremisePersonService ()
@property (nonatomic, strong, readwrite) id<AlfrescoSession> session;
@property (nonatomic, strong, readwrite) NSString *baseApiUrl;
@property (nonatomic, strong, readwrite) AlfrescoObjectConverter *objectConverter;
@property (nonatomic, weak, readwrite) id<AlfrescoAuthenticationProvider> authenticationProvider;
- (AlfrescoPerson *) alfrescoPersonFromJSONData:(NSData *)data error:(NSError **)outError;
- (void)retrieveAvatarForPersonV4x:(AlfrescoPerson *)person completionBlock:(AlfrescoContentFileCompletionBlock)completionBlock;
- (void)retrieveAvatarForPersonV3x:(AlfrescoPerson *)person completionBlock:(AlfrescoContentFileCompletionBlock)completionBlock;
@end


@implementation AlfrescoOnPremisePersonService
@synthesize baseApiUrl = _baseApiUrl;
@synthesize session = _session;
@synthesize objectConverter = _objectConverter;
@synthesize authenticationProvider = _authenticationProvider;

- (id)initWithSession:(id<AlfrescoSession>)session
{
    if (self = [super init])
    {
        self.session = session;
        self.baseApiUrl = [[self.session.baseUrl absoluteString] stringByAppendingString:kAlfrescoOnPremiseAPIPath];
        self.objectConverter = [[AlfrescoObjectConverter alloc] initWithSession:self.session];
        id authenticationObject = [session objectForParameter:kAlfrescoAuthenticationProviderObjectKey];
        self.authenticationProvider = nil;
        if ([authenticationObject isKindOfClass:[AlfrescoBasicAuthenticationProvider class]])
        {
            self.authenticationProvider = (AlfrescoBasicAuthenticationProvider *)authenticationObject;
        }
    }
    return self;
}
- (void)retrievePersonWithIdentifier:(NSString *)identifier completionBlock:(AlfrescoPersonCompletionBlock)completionBlock
{
    [AlfrescoErrors assertArgumentNotNil:identifier argumentName:@"identifier"];
    [AlfrescoErrors assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    NSString *requestString = [kAlfrescoOnPremisePersonAPI stringByReplacingOccurrencesOfString:kAlfrescoPersonId withString:identifier];
    NSURL *url = [AlfrescoHTTPUtils buildURLFromBaseURLString:self.baseApiUrl extensionURL:requestString];
    
    __weak AlfrescoOnPremisePersonService *weakSelf = self;
    [AlfrescoHTTPUtils executeRequestWithURL:url session:self.session completionBlock:^(NSData *responseData, NSError *error){
        if (nil == responseData)
        {
            completionBlock(nil, error);
        }
        else
        {
            NSError *conversionError = nil;
            AlfrescoPerson *person = [weakSelf alfrescoPersonFromJSONData:responseData error:&conversionError];
            completionBlock(person, conversionError);
        }
    }];

    /*
    __weak AlfrescoOnPremisePersonService *weakSelf = self;
    [self.operationQueue addOperationWithBlock:^{
        NSError *operationQueueError = nil;
        NSString *requestString = [kAlfrescoOnPremisePersonAPI stringByReplacingOccurrencesOfString:kAlfrescoPersonId withString:identifier];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
                                           weakSelf.baseApiUrl, requestString]];
        
        log(@"url is %@, requestString is %@",[url absoluteString], requestString);
        
        NSData *data = [AlfrescoHTTPUtils executeRequestWithURL:url
                                                        session:weakSelf.session
                                                           data:nil
                                                     httpMethod:@"GET"
                                                          error:&operationQueueError];
        AlfrescoPerson *person = nil;
        if (nil != data)
        {
            person = [weakSelf alfrescoPersonFromJSONData:data error:&operationQueueError];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            log(@"returned json data");
            completionBlock(person, operationQueueError);
        }];
        
    }];
     */
}

- (void)retrieveAvatarForPerson:(AlfrescoPerson *)person completionBlock:(AlfrescoContentFileCompletionBlock)completionBlock
{
    [AlfrescoErrors assertArgumentNotNil:person argumentName:@"person"];
    [AlfrescoErrors assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    AlfrescoRepositoryInfo *repoInfo = self.session.repositoryInfo;
    NSNumber *majorVersion = repoInfo.majorVersion;
    if ([majorVersion intValue] < 4)
    {
        [self retrieveAvatarForPersonV3x:person completionBlock:completionBlock];
    }
    else
    {
        [self retrieveAvatarForPersonV4x:person completionBlock:completionBlock];
    }

}

- (void)retrieveAvatarForPersonV4x:(AlfrescoPerson *)person completionBlock:(AlfrescoContentFileCompletionBlock)completionBlock
{
    NSString *requestString = [kAlfrescoOnPremiseAvatarForPersonAPI stringByReplacingOccurrencesOfString:kAlfrescoPersonId withString:person.identifier];
    NSURL *url = [AlfrescoHTTPUtils buildURLFromBaseURLString:self.baseApiUrl extensionURL:requestString];
    [AlfrescoHTTPUtils executeRequestWithURL:url session:self.session completionBlock:^(NSData *responseData, NSError *error){
        if (nil == responseData)
        {
            completionBlock(nil, error);
        }
        else
        {
            AlfrescoContentFile *avatarFile = [[AlfrescoContentFile alloc] initWithData:responseData mimeType:@"application/octet-stream"];
            completionBlock(avatarFile, nil);
        }
    }];
    /*
    __weak AlfrescoOnPremisePersonService *weakSelf = self;
    [self.operationQueue addOperationWithBlock:^{
        
        NSError *operationQueueError = nil;
        NSString *requestString = [kAlfrescoOnPremiseAvatarForPersonAPI stringByReplacingOccurrencesOfString:kAlfrescoPersonId withString:person.identifier];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
                                           [weakSelf.session.baseUrl absoluteString], requestString]];
        NSData *data = [AlfrescoHTTPUtils executeRequestWithURL:url
                                                        session:weakSelf.session
                                                           data:nil
                                                     httpMethod:@"GET"
                                                          error:&operationQueueError];
        
        AlfrescoContentFile *avatarFile = nil;
        if (nil != data)
        {
            avatarFile = [[AlfrescoContentFile alloc] initWithData:data mimeType:@"application/octet-stream"];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completionBlock(avatarFile, operationQueueError);
        }];
    }];    
     */
}

- (void)retrieveAvatarForPersonV3x:(AlfrescoPerson *)person completionBlock:(AlfrescoContentFileCompletionBlock)completionBlock
{
    NSString *avatarId = person.avatarIdentifier;
    if (nil == avatarId)
    {
        completionBlock(nil, [AlfrescoErrors alfrescoErrorWithAlfrescoErrorCode:kAlfrescoErrorCodePersonNoAvatarFound]);
        return;
    }
    NSString *requestString = [NSString stringWithFormat:@"%@/service/%@",[self.session.baseUrl absoluteString],avatarId];
    NSURL *url = [NSURL URLWithString:requestString];
    [AlfrescoHTTPUtils executeRequestWithURL:url session:self.session completionBlock:^(NSData *responseData, NSError *error){
        if (nil == responseData)
        {
            completionBlock(nil, error);
        }
        else
        {
            AlfrescoContentFile *avatarFile = [[AlfrescoContentFile alloc] initWithData:responseData mimeType:@"application/octet-stream"];
            completionBlock(avatarFile, nil);
        }
    }];
    
    
    /*
    __weak AlfrescoOnPremisePersonService *weakSelf = self;
    [self.operationQueue addOperationWithBlock:^{
        NSError *operationQueueError = nil;
        NSString *avatarId = person.avatarIdentifier;
        if (nil == avatarId)
        {
            operationQueueError = [AlfrescoErrors alfrescoErrorWithAlfrescoErrorCode:kAlfrescoErrorCodePersonNoAvatarFound];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionBlock(nil, operationQueueError);
            }];
        }
        NSString *requestString = [NSString stringWithFormat:@"%@/service/%@",[weakSelf.session.baseUrl absoluteString],avatarId];
        NSURL *url = [NSURL URLWithString:requestString];
        NSData *data = [AlfrescoHTTPUtils executeRequestWithURL:url
                                                        session:weakSelf.session
                                                           data:nil
                                                     httpMethod:@"GET"
                                                          error:&operationQueueError];
        
        AlfrescoContentFile *avatarFile = nil;
        if (nil != data)
        {
            avatarFile = [[AlfrescoContentFile alloc] initWithData:data mimeType:@"application/octet-stream"];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completionBlock(avatarFile, operationQueueError);
        }];
        
        
        
    }];
     */
}



#pragma mark - private methods
- (AlfrescoPerson *) alfrescoPersonFromJSONData:(NSData *)data error:(NSError *__autoreleasing *)outError
{
    if (nil == data)
    {
        if (nil == *outError)
        {
            *outError = [AlfrescoErrors alfrescoErrorWithAlfrescoErrorCode:kAlfrescoErrorCodeJSONParsingNilData];
        }
        else
        {
            NSError *error = [AlfrescoErrors alfrescoErrorWithAlfrescoErrorCode:kAlfrescoErrorCodeJSONParsingNilData];
            *outError = [AlfrescoErrors alfrescoErrorWithUnderlyingError:error andAlfrescoErrorCode:kAlfrescoErrorCodeJSONParsingNilData];
        }
        return nil;
    }
    
    NSError *error = nil;
    id jsonPersonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if(nil == jsonPersonDict)
    {
        *outError = [AlfrescoErrors alfrescoErrorWithUnderlyingError:error andAlfrescoErrorCode:kAlfrescoErrorCodePerson];
        return nil;
    }
    if ([[jsonPersonDict valueForKeyPath:kAlfrescoJSONStatusCode] isEqualToNumber:[NSNumber numberWithInt:404]])
    {
        // no person found
        if (nil == *outError)
        {
            *outError = [AlfrescoErrors alfrescoErrorWithAlfrescoErrorCode:kAlfrescoErrorCodePersonNotFound];
        }
        else
        {
            NSError *underlyingError = [AlfrescoErrors alfrescoErrorWithAlfrescoErrorCode:kAlfrescoErrorCodePersonNotFound];
            *outError = [AlfrescoErrors alfrescoErrorWithUnderlyingError:underlyingError andAlfrescoErrorCode:kAlfrescoErrorCodePersonNotFound];
        }
        return nil;
    }
    if (NO == [jsonPersonDict isKindOfClass:[NSDictionary class]])
    {
        if (nil == *outError)
        {
            *outError = [AlfrescoErrors alfrescoErrorWithAlfrescoErrorCode:kAlfrescoErrorCodeJSONParsing];
        }
        else
        {
            NSError *underlyingError = [AlfrescoErrors alfrescoErrorWithAlfrescoErrorCode:kAlfrescoErrorCodeJSONParsing];
            *outError = [AlfrescoErrors alfrescoErrorWithUnderlyingError:underlyingError andAlfrescoErrorCode:kAlfrescoErrorCodeJSONParsing];
        }
        return nil;
    }
    return [[AlfrescoPerson alloc] initWithProperties:jsonPersonDict];
    
}

@end
