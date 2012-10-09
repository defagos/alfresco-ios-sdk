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

#import <Foundation/Foundation.h>

@interface AlfrescoInternalConstants : NSObject

/**
 CMIS constants
 */
extern NSString * const kAlfrescoCMISPropertyTypeInt;
extern NSString * const kAlfrescoCMISPropertyTypeBoolean;
extern NSString * const kAlfrescoCMISPropertyTypeDatetime;
extern NSString * const kAlfrescoCMISPropertyTypeDecimal;
extern NSString * const kAlfrescoCMISPropertyTypeId;
extern NSString * const kAlfrescoCMISSessionMode;

/**
 Content Model constants
 */
extern NSString * const kAlfrescoPropertyName;
extern NSString * const kAlfrescoPropertyTitle;
extern NSString * const kAlfrescoPropertyDescription;

/**
 Property name constants
 */
extern NSString * const kAlfrescoRepositoryName;
extern NSString * const kAlfrescoRepositoryCommunity;
extern NSString * const kAlfrescoRepositoryEnterprise;
extern NSString * const kAlfrescoRepositoryEdition;
extern NSString * const kAlfrescoRepositoryIdentifier;
extern NSString * const kAlfrescoRepositorySummary;
extern NSString * const kAlfrescoRepositoryVersion;
extern NSString * const kAlfrescoRepositoryMajorVersion;
extern NSString * const kAlfrescoRepositoryMinorVersion;
extern NSString * const kAlfrescoRepositoryMaintenanceVersion;
extern NSString * const kAlfrescoRepositoryBuildNumber;
extern NSString * const kAlfrescoRepositoryCapabilities;

/**
 Parametrised strings to be used in API
 */
extern NSString * const kAlfrescoSiteId;
extern NSString * const kAlfrescoNodeRef;
extern NSString * const kAlfrescoPersonId;
extern NSString * const kAlfrescoCommentId;
extern NSString * const kAlfrescoRenditionId;
extern NSString * const kAlfrescoOnNodeRefURL;
extern NSString * const kAlfrescoNode;
extern NSString * const kAlfrescoDefaultMimeType;
extern NSString * const kAlfrescoAspects;
extern NSString * const kAlfrescoAppliedAspects;
extern NSString * const kAlfrescoAspectProperties;
extern NSString * const kAlfrescoAspectPropertyDefinitionId;
extern NSString * const kAlfrescoPagingRequest;
extern NSString * const kAlfrescoSkipCountRequest;
extern NSString * const kAlfrescoMaxItemsRequest;
extern NSString * const kAlfrescoClientID;
extern NSString * const kAlfrescoClientSecret;
extern NSString * const kAlfrescoCode;
extern NSString * const kAlfrescoRedirectURI;
extern NSString * const kAlfrescoRefreshID;
extern NSString * const kAlfrescoMe;

/**
 Session data key constants
 */
extern NSString * const kAlfrescoSessionKeyCmisSession;
extern NSString * const kAlfrescoSessionCloudURL;
extern NSString * const kAlfrescoSessionCloudBasicAuth;
extern NSString * const kAlfrescoSessionUsername;
extern NSString * const kAlfrescoSessionPassword;

/**
 Associated object key constants
 */
extern NSString * const kAlfrescoAuthenticationProviderObjectKey;

/**
 OAuth Constants
 */
extern NSString *const kAlfrescoJSONAccessToken;
extern NSString *const kAlfrescoJSONRefreshToken;
extern NSString *const kAlfrescoJSONTokenType;
extern NSString *const kAlfrescoJSONExpiresIn;
extern NSString *const kAlfrescoJSONScope;
extern NSString *const kAlfrescoJSONError;
extern NSString *const kAlfrescoJSONErrorDescription;
extern NSString *const kAlfrescoOAuthClientID;
extern NSString *const kAlfrescoOAuthClientSecret;
extern NSString *const kAlfrescoOAuthGrantType;
extern NSString *const kAlfrescoOAuthRedirectURI;
extern NSString *const kAlfrescoOAuthCode;
extern NSString *const kAlfrescoOAuthAuthorize;
extern NSString *const kAlfrescoOAuthToken;
extern NSString *const kAlfrescoOAuthScope;
extern NSString *const kAlfrescoOAuthResponseType;
extern NSString *const kAlfrescoOAuthGrantTypeRefresh;
extern NSString *const kAlfrescoOAuthRefreshToken;

/**
 On Premise constants
 */
extern NSString * const kAlfrescoOnPremiseAPIPath;
extern NSString * const kAlfrescoOnPremiseCMISPath;
extern NSString * const kAlfrescoOnPremise4_xCMISPath;
extern NSString * const kAlfrescoOnPremiseActivityAPI;
extern NSString * const kAlfrescoOnPremiseActivityForSiteAPI;
extern NSString * const kAlfrescoOnPremiseRatingsAPI;
extern NSString * const kAlfrescoOnPremiseRatingsLikingSchemeAPI;
extern NSString * const kAlfrescoOnPremiseRatingsCount;
extern NSString * const kAlfrescoOnPremiseLikesSchemeRatings;
extern NSString * const kAlfrescoOnNodeRefURL;
extern NSString * const kAlfrescoOnPremiseSiteAPI;
extern NSString * const kAlfrescoOnPremiseSiteForPersonAPI;
extern NSString * const kAlfrescoOnPremiseFavoriteSiteForPersonAPI;
extern NSString * const kAlfrescoOnPremiseSitesShortnameAPI;
extern NSString * const kAlfrescoOnPremiseSiteDoclibAPI;
extern NSString * const kAlfrescoOnPremiseFavoriteSites;
extern NSString * const kAlfrescoOnPremiseCommentsAPI;
extern NSString * const kAlfrescoOnPremiseCommentForNodeAPI;
extern NSString * const kAlfrescoOnPremiseTagsAPI;
extern NSString * const kAlfrescoOnPremiseTagsForNodeAPI;
extern NSString * const kAlfrescoOnPremisePersonAPI;
extern NSString * const kAlfrescoOnPremiseAvatarForPersonAPI;
extern NSString * const kAlfrescoOnPremiseMetadataExtractionAPI;
extern NSString * const kAlfrescoOnPremiseThumbnailCreationAPI;
extern NSString * const kAlfrescoOnPremiseThumbnailRenditionAPI;

/**
 Cloud constants
 */
extern NSString * const kAlfrescoCloudURL;
extern NSString * const kAlfrescoCloudBindingService;
extern NSString * const kAlfrescoCloudPrecursor;
extern NSString * const kAlfrescoCloudAPIPath;
extern NSString * const kAlfrescoCloudCMISPath;
extern NSString * const kAlfrescoHomeNetworkType;
extern NSString * const kAlfrescoDocumentLibrary;
extern NSString * const kAlfrescoCloudSiteAPI;
extern NSString * const kAlfrescoCloudSiteForPersonAPI;
extern NSString * const kAlfrescoCloudFavoriteSiteForPersonAPI;
extern NSString * const kAlfrescoCloudSiteForShortnameAPI;
extern NSString * const kAlfrescoCloudSiteContainersAPI;
extern NSString * const kAlfrescoCloudActivitiesAPI;
extern NSString * const kAlfrescoCloudActivitiesForSiteAPI;
extern NSString * const kAlfrescoCloudRatingsAPI;
extern NSString * const kAlfrescoCloudLikesRatingSchemeAPI;
extern NSString * const kAlfrescoCloudCommentsAPI;
extern NSString * const kAlfrescoCloudCommentForNodeAPI;
extern NSString * const kAlfrescoCloudTagsAPI;
extern NSString * const kAlfrescoCloudTagsForNodeAPI;
extern NSString * const kAlfrescoCloudPersonAPI;
extern NSString * const kAlfrescoCloudDefaultRedirectURI;

/**
 JSON Constants
 */
extern NSString * const kAlfrescoCloudJSONList;
extern NSString * const kAlfrescoCloudJSONEntries;
extern NSString * const kAlfrescoCloudJSONEntry;
extern NSString * const kAlfrescoJSONIdentifier;
extern NSString * const kAlfrescoJSONStatusCode;
extern NSString * const kAlfrescoJSONActivityPostDate;
extern NSString * const kAlfrescoJSONActivityPostUserID;
extern NSString * const kAlfrescoJSONActivityPostPersonID;
extern NSString * const kAlfrescoJSONActivitySiteNetwork;
extern NSString * const kAlfrescoJSONActivityType;
extern NSString * const kAlfrescoJSONActivitySummary;
extern NSString * const kAlfrescoJSONRating;
extern NSString * const kAlfrescoJSONRatingScheme;
extern NSString * const kAlfrescoJSONLikesRatingScheme;
extern NSString * const kAlfrescoJSONDescription;
extern NSString * const kAlfrescoJSONTitle;
extern NSString * const kAlfrescoJSONShortname;
extern NSString * const kAlfrescoJSONVisibility;
extern NSString * const kAlfrescoJSONVisibilityPUBLIC;
extern NSString * const kAlfrescoJSONVisibilityPRIVATE;
extern NSString * const kAlfrescoJSONVisibilityMODERATED;
extern NSString * const kAlfrescoJSONContainers;
extern NSString * const kAlfrescoJSONNodeRef;
extern NSString * const kAlfrescoJSONSiteID;
extern NSString * const kAlfrescoJSONLikes;
extern NSString * const kAlfrescoJSONMyRating;
extern NSString * const kAlfrescoJSONAggregate;
extern NSString * const kAlfrescoJSONNumberOfRatings;
extern NSString * const kAlfrescoJSONHomeNetwork;
extern NSString * const kAlfrescoJSONNetwork;
extern NSString * const kAlfrescoJSONPaidNetwork;
extern NSString * const kAlfrescoJSONCreationTime;
extern NSString * const kAlfrescoJSONSubscriptionLevel;
extern NSString * const kAlfrescoJSONName;
extern NSString * const kAlfrescoJSONItems;
extern NSString * const kAlfrescoJSONItem;
extern NSString * const kAlfrescoJSONCreatedOn;
extern NSString * const kAlfrescoJSONCreatedOnISO;
extern NSString * const kAlfrescoJSONAuthorUserName;
extern NSString * const kAlfrescoJSONAuthor;
extern NSString * const kAlfrescoJSONUsername;
extern NSString * const kAlfrescoJSONModifiedOn;
extern NSString * const kAlfrescoJSONModifiedOnISO;
extern NSString * const kAlfrescoJSONContent;
extern NSString * const kAlfrescoJSONIsUpdated;
extern NSString * const kAlfrescoJSONPermissionsEdit;
extern NSString * const kAlfrescoJSONPermissionsDelete;
extern NSString * const kAlfrescoJSONPermissions;
extern NSString * const kAlfrescoJSONEdit;
extern NSString * const kAlfrescoJSONDelete;
extern NSString * const kAlfrescoJSONCreatedAt;
extern NSString * const kAlfrescoJSONCreatedBy;
extern NSString * const kAlfrescoJSONCreator;
extern NSString * const kAlfrescoJSONAvatar;
extern NSString * const kAlfrescoJSONModifedAt;
extern NSString * const kAlfrescoJSONEdited;
extern NSString * const kAlfrescoJSONCanEdit;
extern NSString * const kAlfrescoJSONCanDelete;
extern NSString * const kAlfrescoJSONEnabled;
extern NSString * const kAlfrescoJSONTag;
extern NSString * const kAlfrescoJSONUserName;
extern NSString * const kAlfrescoJSONFirstName;
extern NSString * const kAlfrescoJSONLastName;
extern NSString * const kAlfrescoJSONActionedUponNode;
extern NSString * const kAlfrescoJSONExtractMetadata;
extern NSString * const kAlfrescoJSONActionDefinitionName;
extern NSString * const kAlfrescoJSONThumbnailName;
extern NSString * const kAlfrescoJSONSite;
extern NSString * const kAlfrescoJSONPostedAt;
extern NSString * const kAlfrescoJSONAvatarId;

extern NSString * const kAlfrescoNodeAspects;
extern NSString * const kAlfrescoNodeProperties;
extern NSString * const kAlfrescoPropertyType;
extern NSString * const kAlfrescoPropertyValue;
extern NSString * const kAlfrescoPropertyIsMultiValued;

@end
