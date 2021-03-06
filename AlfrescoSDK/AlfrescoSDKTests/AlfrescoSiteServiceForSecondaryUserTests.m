/*******************************************************************************
 * Copyright (C) 2005-2013 Alfresco Software Limited.
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

#import "AlfrescoSiteServiceForSecondaryUserTests.h"
#import "AlfrescoSite.h"

@implementation AlfrescoSiteServiceForSecondaryUserTests

- (void)setUp
{
    NSDictionary *environment = [self testEnvironmentDictionary];
    self.server = [environment valueForKey:@"server"];
    BOOL success = NO;
    if ([[environment allKeys] containsObject:@"isCloud"])
    {
        self.isCloud = [[environment valueForKey:@"isCloud"] boolValue];
    }
    else
    {
        self.isCloud = NO;
    }
    NSString *user = [environment valueForKey:@"secondUsername"];
    NSString *pass = [environment valueForKey:@"secondPassword"];
    NSString *site = [environment valueForKey:@"moderatedSite"];
    if (nil != user && nil != pass && nil != site)
    {
        self.userName = user;
        self.testPassword = pass;
        self.testModeratedSiteName = site;
        if (self.isCloud)
        {
            success = [self authenticateCloudServer];
            [self resetTestVariables];
        }
        else
        {
            success = [self authenticateOnPremiseServer:nil];
            [self resetTestVariables];
        }
    }
    self.setUpSuccess = success;    
}

- (void)tearDown
{
    
}


- (void)testAddAndRemoveFavoriteSite
{
    if (self.setUpSuccess)
    {
        self.siteService = [[AlfrescoSiteService alloc] initWithSession:self.currentSession];
        
        [self.siteService retrieveSiteWithShortName:@"remoteapi"
                                    completionBlock:^(AlfrescoSite *remoteSite, NSError *error){
                                        if (remoteSite == nil)
                                        {
                                            STAssertNil(remoteSite,@"if failure, the site remoteapi should be nil");
                                            self.lastTestSuccessful = NO;
                                            self.lastTestFailureMessage = [NSString stringWithFormat:@"%@ - %@", [error localizedDescription], [error localizedFailureReason]];
                                            self.callbackCompleted = YES;
                                        }
                                        else
                                        {
                                            [self.siteService addFavoriteSite:remoteSite completionBlock:^(AlfrescoSite *favSite, NSError *favError){
                                                if (nil == favSite)
                                                {
                                                    self.lastTestSuccessful = NO;
                                                    self.lastTestFailureMessage = [NSString stringWithFormat:@"%@ - %@", [favError localizedDescription], [favError localizedFailureReason]];
                                                    self.callbackCompleted = YES;
                                                }
                                                else
                                                {
                                                    STAssertTrue([favSite.identifier isEqualToString:@"remoteapi"], @"The favorite site should be remoteapi - but instead we got %@",favSite.identifier);
                                                    STAssertTrue(favSite.isFavorite, @"site %@ should be set to isFavorite",favSite.identifier);
                                                    STAssertTrue(favSite.isPendingMember == remoteSite.isPendingMember, @"pending state should be the same for favourited site");
                                                    STAssertTrue(favSite.isMember == remoteSite.isMember, @"member state should be the same for favourited site");
                                                    [self.siteService removeFavoriteSite:favSite completionBlock:^(AlfrescoSite *unFavSite, NSError *unFavError){
                                                        if (nil == unFavSite)
                                                        {
                                                            self.lastTestSuccessful = NO;
                                                            self.lastTestFailureMessage = [NSString stringWithFormat:@"%@ - %@", [unFavError localizedDescription], [unFavError localizedFailureReason]];
                                                            self.callbackCompleted = YES;
                                                        }
                                                        else
                                                        {
                                                            STAssertTrue([unFavSite.identifier isEqualToString:@"remoteapi"], @"The favorite site should be remoteapi - but instead we got %@",favSite.identifier);
                                                            STAssertFalse(unFavSite.isFavorite, @"site %@ should no longer be a favorite",unFavSite.identifier);
                                                            STAssertTrue(unFavSite.isPendingMember == remoteSite.isPendingMember, @"pending state should be the same for unfavourited site");
                                                            STAssertTrue(unFavSite.isMember == remoteSite.isMember, @"member state should be the same for unfavourited site");
                                                            self.lastTestSuccessful = YES;
                                                            self.callbackCompleted = YES;
                                                        }
                                                    }];
                                                }
                                            }];
                                            
                                        }
                                    }];
        [self waitUntilCompleteWithFixedTimeInterval];
        STAssertTrue(self.lastTestSuccessful, self.lastTestFailureMessage);
    }
    else
    {
        STFail(@"We could not run this test case");
    }
    
}

- (void)testJoinAndCancelModeratedSite
{
    if (self.setUpSuccess)
    {
        self.siteService = [[AlfrescoSiteService alloc] initWithSession:self.currentSession];
        [self.siteService retrieveSiteWithShortName:self.testModeratedSiteName
                                    completionBlock:^(AlfrescoSite *modSite, NSError *error){
                                        if (nil == modSite)
                                        {
                                            STAssertNil(modSite,@"if failure, the site object should be nil");
                                            self.lastTestSuccessful = NO;
                                            self.lastTestFailureMessage = [NSString stringWithFormat:@"%@ - %@", [error localizedDescription], [error localizedFailureReason]];
                                            self.callbackCompleted = YES;
                                        }
                                        else
                                        {
                                            BOOL isCorrectName = [modSite.identifier isEqualToString:@"iosmoderatedsite"] || [modSite.identifier isEqualToString:@"iOSModeratedSite"];
                                            STAssertTrue(isCorrectName, @"the site should be equal to iosmoderatedsite/iOSModeratedSite, but instead we got %@",modSite.identifier);
                                            BOOL isMember = modSite.isMember;
                                            BOOL isPendingMember = modSite.isPendingMember;
                                            BOOL isFavorite = modSite.isFavorite;
                                            STAssertFalse(isPendingMember, @"We should not have it marked as pending just yet");
                                            [self.siteService joinSite:modSite completionBlock:^(AlfrescoSite *requestedSite, NSError *requestError){
                                                if (nil == requestedSite)
                                                {
                                                    STAssertNil(requestedSite,@"if failure, the requestedSite object should be nil");
                                                    self.lastTestSuccessful = NO;
                                                    self.lastTestFailureMessage = [NSString stringWithFormat:@"%@ - %@", [requestError localizedDescription], [requestError localizedFailureReason]];
                                                    self.callbackCompleted = YES;
                                                }
                                                else
                                                {
                                                    BOOL isCorrectName = [requestedSite.identifier isEqualToString:@"iosmoderatedsite"] || [requestedSite.identifier isEqualToString:@"iOSModeratedSite"];
                                                    BOOL reqIsMember = requestedSite.isMember;
                                                    BOOL reqIsFavorite = requestedSite.isFavorite;
                                                    STAssertTrue(reqIsMember == isMember, @"the membership state of requested site should not have changed");
                                                    STAssertTrue(reqIsFavorite == isFavorite, @"the favourite state of requested site should not have changed");
                                                    STAssertTrue(isCorrectName, @"the site should be equal to iOSModeratedSite, but instead we got %@",requestedSite.identifier);
                                                    STAssertTrue(requestedSite.isPendingMember, @"Site should be in state isPendingMember - but appears to be not");
                                                    [self.siteService retrievePendingSitesWithCompletionBlock:^(NSArray *pendingSites, NSError *retrieveError){
                                                        if (nil == pendingSites)
                                                        {
                                                            self.lastTestSuccessful = NO;
                                                            self.lastTestFailureMessage = [NSString stringWithFormat:@"%@ - %@", [retrieveError localizedDescription], [retrieveError localizedFailureReason]];
                                                            self.callbackCompleted = YES;
                                                        }
                                                        else
                                                        {
                                                            STAssertTrue(0 < pendingSites.count, @"We should have at least 1 requested site in the array, instead we got %d", pendingSites.count);
                                                            [self.siteService cancelPendingJoinRequestForSite:requestedSite completionBlock:^(AlfrescoSite *cancelledSite, NSError *cancelError){
                                                                if (nil == cancelledSite)
                                                                {
                                                                    STAssertNil(cancelledSite,@"if failure, the cancelledSite object should be nil");
                                                                    self.lastTestSuccessful = NO;
                                                                    self.lastTestFailureMessage = [NSString stringWithFormat:@"%@ - %@", [cancelError localizedDescription], [cancelError localizedFailureReason]];
                                                                    self.callbackCompleted = YES;
                                                                }
                                                                else
                                                                {
                                                                    BOOL isCorrectName = [requestedSite.identifier isEqualToString:@"iosmoderatedsite"] || [requestedSite.identifier isEqualToString:@"iOSModeratedSite"];
                                                                    STAssertTrue(cancelledSite.isMember == isMember, @"the membership state of cancelled site should not have changed");
                                                                    STAssertTrue(cancelledSite.isFavorite == isFavorite, @"the favourite state of cancelled site should not have changed");
                                                                    STAssertTrue(isCorrectName, @"the site should be equal to iosmoderatedsite/iOSModeratedSite, but instead we got %@",modSite.identifier);
                                                                    STAssertFalse(cancelledSite.isPendingMember, @"Site should NOT be in state isPendingMember - but appears to be still in this state");
                                                                    self.lastTestSuccessful = YES;
                                                                    self.callbackCompleted = YES;
                                                                }
                                                            }];
                                                        }
                                                        
                                                    }];
                                                }
                                            }];
                                            
                                        }
                                    }];
        [self waitUntilCompleteWithFixedTimeInterval];
        STAssertTrue(self.lastTestSuccessful, self.lastTestFailureMessage);
    }
    else
    {
        STFail(@"We could not run this test case");
    }
}

- (void)testJoinAndLeavePublicSite
{
    if (self.setUpSuccess)
    {
        self.siteService = [[AlfrescoSiteService alloc] initWithSession:self.currentSession];
        [self.siteService retrieveSiteWithShortName:@"remoteapi"
                                    completionBlock:^(AlfrescoSite *modSite, NSError *error){
                                        if (nil == modSite)
                                        {
                                            STAssertNil(modSite,@"if failure, the site object should be nil");
                                            self.lastTestSuccessful = NO;
                                            self.lastTestFailureMessage = [NSString stringWithFormat:@"%@ - %@", [error localizedDescription], [error localizedFailureReason]];
                                            self.callbackCompleted = YES;
                                        }
                                        else
                                        {
                                            BOOL isCorrectName = [modSite.identifier isEqualToString:@"remoteapi"];
                                            STAssertTrue(isCorrectName, @"the site should be equal to remoteapi, but instead we got %@",modSite.identifier);
                                            [self.siteService joinSite:modSite completionBlock:^(AlfrescoSite *requestedSite, NSError *requestError){
                                                if (nil == requestedSite)
                                                {
                                                    STAssertNil(requestedSite,@"if failure, the requestedSite object should be nil");
                                                    self.lastTestSuccessful = NO;
                                                    self.lastTestFailureMessage = [NSString stringWithFormat:@"%@ - %@", [requestError localizedDescription], [requestError localizedFailureReason]];
                                                    self.callbackCompleted = YES;
                                                }
                                                else
                                                {
                                                    BOOL isCorrectName = [modSite.identifier isEqualToString:@"remoteapi"];
                                                    STAssertTrue(requestedSite.isFavorite == modSite.isFavorite, @"favorite state of joined site should be the same");
                                                    STAssertTrue(requestedSite.isPendingMember == modSite.isPendingMember, @"pending state of joined site should be the same");
                                                    STAssertTrue(isCorrectName, @"the site should be equal to remoteapi, but instead we got %@",modSite.identifier);
                                                    STAssertTrue(requestedSite.isMember, @"Site should be in state isMember - but appears to be not");
                                                    [self.siteService leaveSite:requestedSite completionBlock:^(AlfrescoSite *noMemberSite, NSError *noMemberError){
                                                        if (nil == noMemberSite)
                                                        {
                                                            STAssertNil(noMemberSite,@"if failure, the noMemberSite object should be nil");
                                                            self.lastTestSuccessful = NO;
                                                            self.lastTestFailureMessage = [NSString stringWithFormat:@"%@ - %@", [noMemberError localizedDescription], [noMemberError localizedFailureReason]];
                                                            self.callbackCompleted = YES;
                                                        }
                                                        else
                                                        {
                                                            BOOL isCorrectName = [modSite.identifier isEqualToString:@"remoteapi"];
                                                            STAssertTrue(noMemberSite.isFavorite == modSite.isFavorite, @"favorite state of left site should be the same");
                                                            STAssertTrue(noMemberSite.isPendingMember == modSite.isPendingMember, @"pending state of left site should be the same");
                                                            STAssertTrue(isCorrectName, @"the site should be equal to remoteapi, but instead we got %@",noMemberSite.identifier);
                                                            STAssertFalse(noMemberSite.isMember, @"Site should NOT be in state isMember - but appears to be still in this state");
                                                            self.lastTestSuccessful = YES;
                                                            self.callbackCompleted = YES;
                                                            
                                                        }
                                                    }];
                                                    
                                                }
                                            }];
                                            
                                        }
                                    }];
        [self waitUntilCompleteWithFixedTimeInterval];
        STAssertTrue(self.lastTestSuccessful, self.lastTestFailureMessage);
    }
    else
    {
        STFail(@"We could not run this test case");
    }
    
}

@end
