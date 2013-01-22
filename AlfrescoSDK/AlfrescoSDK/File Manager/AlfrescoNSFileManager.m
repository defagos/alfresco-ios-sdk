/*
 ******************************************************************************
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
 *****************************************************************************
 */

#import "AlfrescoNSFileManager.h"
#import "AlfrescoConstants.h"

@implementation AlfrescoNSFileManager

- (NSString *)homeDirectory
{
    return NSHomeDirectory();
}

- (NSString *)documentsDirectory
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return path;
}

- (NSString *)temporaryDirectory
{
    return NSTemporaryDirectory();
}

- (BOOL)fileExistsAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (BOOL)fileExistsAtPath:(NSString *)path isDirectory:(BOOL *)isDirectory
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:isDirectory];
}

- (BOOL)createFileAtPath:(NSString *)path contents:(NSData *)data error:(NSError **)error
{
    return [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
}

- (BOOL)createDirectoryAtPath:(NSString *)path withIntermediateDirectories:(BOOL)createIntermediates attributes:(NSDictionary *)attributes error:(NSError **)error
{
    return [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:createIntermediates attributes:attributes error:error];
}

- (BOOL)removeItemAtPath:(NSString *)path error:(NSError **)error
{
    return [[NSFileManager defaultManager] removeItemAtPath:path error:error];
}

- (BOOL)copyItemAtPath:(NSString *)sourcePath toPath:(NSString *)destinationPath error:(NSError **)error
{
    return [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:error];
}

- (BOOL)moveItemAtPath:(NSString *)sourcePath toPath:(NSString *)destinationPath error:(NSError **)error
{
    return [[NSFileManager defaultManager] moveItemAtPath:sourcePath toPath:destinationPath error:error];
}

- (NSDictionary *)attributesOfItemAtPath:(NSString *)path error:(NSError **)error
{
    // find out if path is a folder
    BOOL isDir;
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:error];
    
    NSDictionary *alfrescoAttributeDictionary = nil;
    
    if (attributes)
    {
        alfrescoAttributeDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[attributes objectForKey:NSFileSize], kAlfrescoFileSize,
                                       [attributes objectForKey:NSFileModificationDate], kAlfrescoFileLastModification,
                                       [NSNumber numberWithBool:isDir], kAlfrescoIsFolder,
                                       nil];
    }
    
    return alfrescoAttributeDictionary;
}

- (NSArray *)contentsOfDirectoryAtPath:(NSString *)directoryPath error:(NSError **)error
{
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:error];
}

- (void)enumerateThroughDirectory:(NSString *)directory includingSubDirectories:(BOOL)includeSubDirectories error:(NSError **)error withBlock:(void (^)(NSString *fullFilePath))block
{
    NSDirectoryEnumerationOptions options;
    if (!includeSubDirectories)
    {
        options = NSDirectoryEnumerationSkipsHiddenFiles | NSDirectoryEnumerationSkipsSubdirectoryDescendants;
    }
    else
    {
        options = NSDirectoryEnumerationSkipsHiddenFiles;
    }
    
    NSEnumerator *folderContents = [[NSFileManager defaultManager] enumeratorAtURL:[NSURL URLWithString:[directory stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                                        includingPropertiesForKeys:[NSArray arrayWithObjects:NSURLNameKey, NSURLPathKey,nil]
                                                                           options:options
                                                                      errorHandler:^BOOL(NSURL *url, NSError *fileError) {
                                                                          NSLog(@"Error retrieving contents of the URL: %@ with the error: %@", [url absoluteString], [fileError localizedDescription]);
                                                                          return YES;
                                                                      }];
    
    for (NSURL *fileURL in folderContents)
    {
        NSString *fullPath = nil;
        [fileURL getResourceValue:&fullPath forKey:NSURLPathKey error:nil];
        block(fullPath);
    }
}

- (NSData *)dataWithContentsOfURL:(NSURL *)url
{
    return [[NSFileManager defaultManager] contentsAtPath:[url path]];
}

- (void)appendToFileAtPath:(NSString *)filePath data:(NSData *)data
{
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    
    if (fileHandle)
    {
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:data];
    }
    
    [fileHandle closeFile];
}

- (NSString *)internalFilePathFromName:(NSString *)fileName
{
    return [[self temporaryDirectory] stringByAppendingPathComponent:fileName];
}

- (BOOL)fileStreamIsOpen:(NSStream *)stream
{
    BOOL isStreamOpen = NO;
    NSOutputStream *outputStream = (NSOutputStream *)stream;
    isStreamOpen = outputStream.streamStatus == NSStreamStatusOpen;
    return isStreamOpen;
}

@end
