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

#import "AlfrescoSearchService.h"
#import "AlfrescoErrors.h"
#import "AlfrescoObjectConverter.h"
#import "AlfrescoPagingUtils.h"
#import "CMISDocument.h"
#import "CMISSession.h"
#import "CMISDiscoveryService.h"
#import "CMISPagedResult.h"
#import "CMISObjectList.h"
#import "CMISQueryResult.h"
#import "AlfrescoInternalConstants.h"
#import "AlfrescoSortingUtils.h"

@interface AlfrescoSearchService ()
@property (nonatomic, strong, readwrite) id<AlfrescoSession> session;
@property (nonatomic, strong, readwrite) NSOperationQueue *operationQueue;
@property (nonatomic, strong, readwrite) AlfrescoObjectConverter *objectConverter;
@property (nonatomic, strong, readwrite) NSArray *supportedSortKeys;
@property (nonatomic, strong, readwrite) NSString *defaultSortKey;
- (NSString *) createSearchQuery:(NSString *)keywords options:(AlfrescoKeywordSearchOptions *)options;
- (BOOL) isValueSearchLanguage:(NSInteger)language error:(NSError **)error;

@end

@implementation AlfrescoSearchService
@synthesize session = _session;
@synthesize operationQueue = _operationQueue;
@synthesize objectConverter = _objectConverter;
@synthesize supportedSortKeys = _supportedSortKeys;
@synthesize defaultSortKey = _defaultSortKey;


- (id)initWithSession:(id<AlfrescoSession>)session
{
    self = [super init];
    if (nil != self)
    {
        self.session = session;
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.maxConcurrentOperationCount = 2;
        self.objectConverter = [[AlfrescoObjectConverter alloc] initWithSession:self.session];
        self.defaultSortKey = kAlfrescoSortByName;
        self.supportedSortKeys = [NSArray arrayWithObjects:kAlfrescoSortByName, kAlfrescoSortByTitle, kAlfrescoSortByDescription, kAlfrescoSortByCreatedAt, kAlfrescoSortByModifiedAt, nil];
    }
    return self;
}



- (void)searchWithStatement:(NSString *)statement
                   language:(AlfrescoSearchLanguage)language
            completionBlock:(AlfrescoArrayCompletionBlock)completionBlock
{
    [AlfrescoErrors assertArgumentNotNil:statement argumentAsString:@"statement"];
    [AlfrescoErrors assertArgumentNotNil:completionBlock argumentAsString:@"completionBlock"];    
    
    if (AlfrescoSearchLanguageCMIS == language)
    {
        __weak AlfrescoSearchService *weakSelf = self;
        [self.operationQueue addOperationWithBlock:^{
            
            NSError *operationQueueError = nil;
            CMISSession *cmisSession = [weakSelf.session objectForParameter:kAlfrescoSessionKeyCmisSession];
            CMISObjectList *queryResultList = [cmisSession.binding.discoveryService query:statement
                                                                        searchAllVersions:NO
                                                                     includeRelationShips:CMISIncludeRelationshipBoth
                                                                          renditionFilter:nil
                                                                  includeAllowableActions:YES
                                                                                 maxItems:[NSNumber numberWithInt:50]
                                                                                skipCount:0
                                                                                    error:&operationQueueError];
            NSMutableArray *resultArray = nil;
            NSArray *sortedResultArray = nil;
            if (nil != queryResultList)
            {
                resultArray = [NSMutableArray arrayWithCapacity:[queryResultList.objects count]];
                for (CMISObjectData *queryData in queryResultList.objects) 
                {
                    [resultArray addObject:[self.objectConverter nodeFromCMISObjectData:queryData]];
                }
                sortedResultArray = [AlfrescoSortingUtils sortedArrayForArray:resultArray sortKey:self.defaultSortKey ascending:YES];
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionBlock(sortedResultArray, operationQueueError);
            }];
        }];
    }
    
}


- (void)searchWithStatement:(NSString *)statement
                   language:(AlfrescoSearchLanguage)language
             listingContext:(AlfrescoListingContext *)listingContext
            completionBlock:(AlfrescoPagingResultCompletionBlock)completionBlock
{
    [AlfrescoErrors assertArgumentNotNil:statement argumentAsString:@"statement"];
    [AlfrescoErrors assertArgumentNotNil:completionBlock argumentAsString:@"completionBlock"];
    if (nil == listingContext)
    {
        listingContext = [[AlfrescoListingContext alloc]init];
    }

    if (AlfrescoSearchLanguageCMIS == language)
    {
        __weak AlfrescoSearchService *weakSelf = self;
        [self.operationQueue addOperationWithBlock:^{
            
            NSError *operationQueueError = nil;
             CMISSession *cmisSession = [weakSelf.session objectForParameter:kAlfrescoSessionKeyCmisSession];
             CMISObjectList *queryResultList = [cmisSession.binding.discoveryService query:statement
                                                                         searchAllVersions:NO
                                                                      includeRelationShips:CMISIncludeRelationshipBoth
                                                                           renditionFilter:nil
                                                                   includeAllowableActions:YES
                                                                                  maxItems:[NSNumber numberWithInt:50]
                                                                                 skipCount:0
                                                                                     error:&operationQueueError];
            AlfrescoPagingResult *pagingResult = nil;
            if (nil != queryResultList)
            {
                NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:[queryResultList.objects count]];
                for (CMISObjectData *queryData in queryResultList.objects) 
                {
                    [resultArray addObject:[self.objectConverter nodeFromCMISObjectData:queryData]];
                }
                NSArray *sortedArray = [AlfrescoSortingUtils sortedArrayForArray:resultArray
                                                                         sortKey:listingContext.sortProperty
                                                                   supportedKeys:self.supportedSortKeys
                                                                      defaultKey:self.defaultSortKey
                                                                       ascending:listingContext.sortAscending];
                pagingResult = [[AlfrescoPagingResult alloc] initWithArray:sortedArray hasMoreItems:YES totalItems:-1];
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionBlock(pagingResult, operationQueueError);
            }];
        }];
    }
    
}

- (void)searchWithKeywords:(NSString *)keywords
                   options:(AlfrescoKeywordSearchOptions *)options
           completionBlock:(AlfrescoArrayCompletionBlock)completionBlock
{
    [AlfrescoErrors assertArgumentNotNil:keywords argumentAsString:@"keywords"];
    [AlfrescoErrors assertArgumentNotNil:options argumentAsString:@"options"];
    [AlfrescoErrors assertArgumentNotNil:completionBlock argumentAsString:@"completionBlock"];

    NSString *query = [self createSearchQuery:keywords options:options];
    __weak AlfrescoSearchService *weakSelf = self;
    [self.operationQueue addOperationWithBlock:^{
        
        NSError *operationQueueError = nil;
        NSMutableArray *resultArray = nil;
        NSArray *sortedResultArray = nil;
        CMISSession *cmisSession = [weakSelf.session objectForParameter:kAlfrescoSessionKeyCmisSession];
        CMISPagedResult *queryResultList = [cmisSession query:query searchAllVersions:NO error:&operationQueueError];
        if (nil != queryResultList)
        {
            resultArray = [NSMutableArray arrayWithCapacity:[queryResultList.resultArray count]];
            for (CMISQueryResult *queryResult in queryResultList.resultArray) 
            {
                [resultArray addObject:[self.objectConverter documentFromCMISQueryResult:queryResult]];
            }
            sortedResultArray = [AlfrescoSortingUtils sortedArrayForArray:resultArray sortKey:self.defaultSortKey ascending:YES];
            
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completionBlock(sortedResultArray, operationQueueError);
        }];
    }];
    
}

- (void)searchWithKeywords:(NSString *)keywords
                   options:(AlfrescoKeywordSearchOptions *)options
            listingContext:(AlfrescoListingContext *)listingContext
           completionBlock:(AlfrescoPagingResultCompletionBlock)completionBlock
{
    [AlfrescoErrors assertArgumentNotNil:keywords argumentAsString:@"keywords"];
    [AlfrescoErrors assertArgumentNotNil:options argumentAsString:@"options"];
    [AlfrescoErrors assertArgumentNotNil:completionBlock argumentAsString:@"completionBlock"];
    if (nil == listingContext)
    {
        listingContext = [[AlfrescoListingContext alloc]init];
    }

    NSString *query = [self createSearchQuery:keywords options:options];
    CMISOperationContext *operationContext = [AlfrescoPagingUtils operationContextFromListingContext:listingContext];
    
    __weak AlfrescoSearchService *weakSelf = self;
    [self.operationQueue addOperationWithBlock:^{
        
        NSError *operationQueueError = nil;
        NSMutableArray *resultArray = nil;
        NSArray *sortedResultArray = nil;
        AlfrescoPagingResult *pagingResult = nil;
        CMISSession *cmisSession = [weakSelf.session objectForParameter:kAlfrescoSessionKeyCmisSession];
        CMISPagedResult *queryResultList = [cmisSession query:query searchAllVersions:NO operationContext:operationContext error:&operationQueueError];
        if (nil != queryResultList)
        {
            resultArray = [NSMutableArray arrayWithCapacity:[queryResultList.resultArray count]];
            for (CMISQueryResult *queryResult in queryResultList.resultArray)
            {
                [resultArray addObject:[self.objectConverter documentFromCMISQueryResult:queryResult]];
            }
            sortedResultArray = [AlfrescoSortingUtils sortedArrayForArray:resultArray sortKey:self.defaultSortKey ascending:YES];
            pagingResult = [AlfrescoPagingUtils pagedResultFromArray:sortedResultArray listingContext:listingContext];
//            pagingResult = [AlfrescoPagingUtils pagedResultFromArray:queryResultList objectConverter:weakSelf.objectConverter];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completionBlock(pagingResult, operationQueueError);
        }];
    }];
    
}


#pragma mark Internal methods

- (NSString *) createSearchQuery:(NSString *)keywords  options:(AlfrescoKeywordSearchOptions *)options
{
    NSMutableString *searchQuery = [NSMutableString stringWithString:@"SELECT * FROM cmis:document WHERE ("];
    BOOL firstKeyword = YES;
    NSArray *keywordArray = [keywords componentsSeparatedByString:@" "];
    for (NSString *keyword in keywordArray) {
        if (firstKeyword == NO)
        {
            [searchQuery appendString:@" OR "];
        }
        else 
        {
            firstKeyword = NO;
        }
        
        if (YES == options.exactMatch)
        {
            [searchQuery appendString:[NSString stringWithFormat:@"%@ = '%@'", kCMISNameParameterForSearch, keyword]];
        }
        else 
        {
            [searchQuery appendString:[NSString stringWithFormat:@"CONTAINS('~%@:*%@*')", kCMISNameParameterForSearch, keyword]];
        }
        
        if (YES == options.includeContent)
        {
            [searchQuery appendString:[NSString stringWithFormat:@" OR CONTAINS('%@')", keyword]];
        }
    }
    [searchQuery appendString:@")"];
    if (YES == options.includeDescendants) 
    {
        if (nil != options.folder && nil != options.folder.identifier) 
        {
            [searchQuery appendString:[NSString stringWithFormat:@" AND IN_TREE('%@')", options.folder.identifier]];
        }
    }
    
    return searchQuery;
    
}

- (BOOL) isValueSearchLanguage:(NSInteger)language error:(NSError **)error
{
    if (AlfrescoSearchLanguageCMIS == language) 
    {
        return YES;
    }
    if (nil == *error)
    {
        *error = [AlfrescoErrors createAlfrescoErrorWithCode:kAlfrescoErrorCodeSearchUnsupportedSearchLanguage];
    }
    else
    {
        NSError *underlyingError = [AlfrescoErrors createAlfrescoErrorWithCode:kAlfrescoErrorCodeSearchUnsupportedSearchLanguage];
        *error = [AlfrescoErrors alfrescoError:underlyingError withAlfrescoErrorCode:kAlfrescoErrorCodeSearch];
    }
    return NO;
}



@end
