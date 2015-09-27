//
//  DataManager.m
//  MallTip
//
//  Created by lifeng on 1/24/14.
//  Copyright (c) 2014 Li Feng. All rights reserved.
//

#import "DataManager.h"
#import "MallFeedItem+Extra.h"
#import <AFNetworking/AFNetworking.h>
#import <CoreData/CoreData.h>

@interface DataManager ()
{
    NSOperationQueue *queue;
    
}

@property (nonatomic,strong) NSManagedObjectContext * managedObjectContext;
@property (nonatomic,strong) NSManagedObjectContext * backgroundManagedObjectContext;

@property (nonatomic,strong) NSManagedObjectModel           * managedObjectModel;
@property (nonatomic,strong) NSPersistentStoreCoordinator   * persistentStoreCoordinator;
@end

@implementation DataManager

+ (DataManager*)manager
{
    static dispatch_once_t once;
    static DataManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        
    });
    return sharedInstance;
}

+ (NSString *)cacheDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

- (BOOL)isJPEGValid:(NSData *)jpeg
{
    if ([jpeg length] < 4) return NO;
    const char * bytes = (const char *)[jpeg bytes];
    if (bytes[0] != '\xff' || bytes[1] != '\xd8') return NO;
    if (bytes[[jpeg length] - 2] != '\xff' || bytes[[jpeg length] - 1] != '\xd9') return NO;
    return YES;
}

- (BOOL)isPNGValid:(NSData *)png
{
    if (!png || png.length < 12)
    {
        return NO;
    }
    
    NSInteger totalBytes = png.length;
    const char *bytes = (const char *)[png bytes];
    
    return (bytes[0] == (char)0x89 && // PNG
            bytes[1] == (char)0x50 &&
            bytes[2] == (char)0x4e &&
            bytes[3] == (char)0x47 &&
            bytes[4] == (char)0x0d &&
            bytes[5] == (char)0x0a &&
            bytes[6] == (char)0x1a &&
            bytes[7] == (char)0x0a &&
            
            bytes[totalBytes - 12] == (char)0x00 && // IEND
            bytes[totalBytes - 11] == (char)0x00 &&
            bytes[totalBytes - 10] == (char)0x00 &&
            bytes[totalBytes - 9] == (char)0x00 &&
            bytes[totalBytes - 8] == (char)0x49 &&
            bytes[totalBytes - 7] == (char)0x45 &&
            bytes[totalBytes - 6] == (char)0x4e &&
            bytes[totalBytes - 5] == (char)0x44 &&
            bytes[totalBytes - 4] == (char)0xae &&
            bytes[totalBytes - 3] == (char)0x42 &&
            bytes[totalBytes - 2] == (char)0x60 &&
            bytes[totalBytes - 1] == (char)0x82);
}

- (BOOL)isGIFValid:(NSData *)gif {
    return YES;
}

#pragma mark - Server Connection

- (NSOperationQueue *)queue
{
    
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 30.;
    }
    return queue;
}

- (NSString *)host {
    return @"https://m.malltip.com/";
}

- (NSString *)hostWithPath:(NSString *)path
{
    if([path hasPrefix:@"http"])
        return path;
    
    if ([path hasPrefix:@"/"]) {
        path = [path substringFromIndex:1];
    }
    return [NSString stringWithFormat:@"%@%@",[self host], path];
}

- (void)requestWithPath:(NSString *)path HTTPMethod:(NSString*)HTTPMethod bodyData:(NSData *)bodyData contentType:(NSString*) contentType withToken:(BOOL)useAuthToken completionHandler:(void (^)(NSURLResponse *response, NSData *data, NSError *error))handler
{
    
    NSError *error;
    
    if (error) {
        if (handler) handler(nil,nil,error);
    }
    else
    {
        
        NSURL *url = [NSURL URLWithString:[[self hostWithPath:path] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        if (bodyData) {
            [request setHTTPBody:bodyData];
        }
        [request setHTTPMethod:HTTPMethod];
        [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        /*
         if (useAuthToken) {
         NSString *token = [self userAccessToken];
         if (token) {
         [request setValue:token forHTTPHeaderField:@"X-AUTH-TOKEN"];
         }
         }
         */
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            handler([operation response], responseObject, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            handler([operation response], nil, error);
        }];
        
        
        [[self queue] addOperation:operation];
    }
}

- (void)requestWithPath:(NSString *)path HTTPMethod:(NSString*)HTTPMethod body:(NSDictionary *)jsonBody withToken:(BOOL)useAuthToken completionHandler:(void (^)(NSURLResponse *response, NSData *data, NSError *error))handler
{
    NSError *error;
    NSData *bodyData;
    
    if (jsonBody) {
        bodyData = [NSJSONSerialization dataWithJSONObject:jsonBody options:0 error:&error];
    }
    
    [self requestWithPath:path HTTPMethod:HTTPMethod bodyData:bodyData contentType:@"application/json" withToken:useAuthToken completionHandler:handler];
}

- (void)getFeedsforMallWithID:(NSNumber*)itemID withCompletionHandler:(void(^)(BOOL success, int offsetID, NSString *error))handler {
    
    NSString *requestPath = [NSString stringWithFormat:@"/api/v1/mall/%@/feed/offset/0", itemID];
    
    [self requestWithPath:requestPath HTTPMethod:@"GET" body:nil withToken:YES completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
            {
                NSManagedObjectContext *context = self.backgroundManagedObjectContext;
                [context performBlock:^{
                    
                    NSDictionary *jsonResponse;
                    NSString *resolvedError;
                    NSInteger statusCode = [self statusCodeForServerResponseSuccessful:response responseData:data responseError:error parsedJSONObject:&jsonResponse resolvedLocalizedErrorMessage:&resolvedError];
                    
                    BOOL success = YES;
                    int offset = 0;
                    
                    NSError *error = nil;
                    if (statusCode < 400) {
                        NSArray *feeds = jsonResponse[@"feeds"];
                        offset = [jsonResponse[@"offset"] intValue];
                        
                        // remove old feeds
                        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MallFeedItem"];
                        [fetchRequest setIncludesPropertyValues:NO];
                        
                        NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
                        
                        for (NSManagedObject *managedObject in items) {
                            [managedObject.managedObjectContext deleteObject:managedObject];
                        }
                        
                        
                        // add new feeds
                        for (NSDictionary *itemDictionary in feeds) {
                            MallFeedItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"MallFeedItem" inManagedObjectContext:context];
                            [item setValuesFromDictionary:itemDictionary];
                        }
                    }
                    else {
                        success = NO;
                        
                        /*NSDictionary *response = (NSDictionary*)jsonResponse;
                         
                         NSString *errorMessage = [response[@"error"][@"messages"] lastObject];
                         if (errorMessage)
                         resolvedError = errorMessage;
                         */
                        resolvedError = @"unexpected server response";
                        
                    }
                    
                    if ([context hasChanges])
                    {
                        [self save];
                    }
                    
                    if (handler) handler(success, offset, resolvedError);
                }];
                
            }];
}

- (void)getFeedsforMallWithID:(NSNumber*)itemID withOffsetFeedID:(NSNumber *)offsetID withCompletionHandler:(void(^)(BOOL success, int offsetID, NSString *error))handler {
    
    NSString *requestPath = [NSString stringWithFormat:@"/api/v1/mall/%@/feed/offset/%@", itemID, offsetID];
    
    [self requestWithPath:requestPath HTTPMethod:@"GET" body:nil withToken:YES completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
            {
                NSManagedObjectContext *context = self.backgroundManagedObjectContext;
                [context performBlock:^{
                    
                    NSDictionary *jsonResponse;
                    NSString *resolvedError;
                    NSInteger statusCode = [self statusCodeForServerResponseSuccessful:response responseData:data responseError:error parsedJSONObject:&jsonResponse resolvedLocalizedErrorMessage:&resolvedError];
                    
                    BOOL success = YES;
                    int offset = 0;
                    if (statusCode < 400) {
                        NSArray *feeds = jsonResponse[@"feeds"];
                        offset = [jsonResponse[@"offset"] intValue];
                        for (NSDictionary *itemDictionary in feeds) {
                            
                            NSNumber *itemID = itemDictionary[@"feedId"];
                            
                            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MallFeedItem"];
                            [request setPredicate:[NSPredicate predicateWithFormat:@"feedId == %@", itemID]];
                            
                            MallFeedItem *item = [[context executeFetchRequest:request error:NULL] firstObject];
                            
                            if (!item) {
                                item = [NSEntityDescription insertNewObjectForEntityForName:@"MallFeedItem" inManagedObjectContext:context];
                            }
                            [item setValuesFromDictionary:itemDictionary];
                        }
                    }
                    else {
                        success = NO;
                        
                        /*NSDictionary *response = (NSDictionary*)jsonResponse;
                         
                         NSString *errorMessage = [response[@"error"][@"messages"] lastObject];
                         if (errorMessage)
                         resolvedError = errorMessage;
                         */
                        resolvedError = @"unexpected server response";
                        
                    }
                    
                    if ([context hasChanges])
                    {
                        [self save];
                    }
                    
                    if (handler) handler(success, offset, resolvedError);
                }];
                
            }];
}


- (NSInteger)statusCodeForServerResponseSuccessful:(NSURLResponse*)urlResponse
                                      responseData:(NSData*)data
                                     responseError:(NSError*)error
                                  parsedJSONObject:(__autoreleasing id*)jsonResponse
                     resolvedLocalizedErrorMessage:(__autoreleasing NSString**)resolvedMessage
{
    
    NSHTTPURLResponse *response = (NSHTTPURLResponse*)urlResponse;
    
    
    NSString *errorMessage;
    
    if (data) {
        NSError *parsingError;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parsingError];
        
        if (jsonObject) {
            if (jsonResponse) {
                *jsonResponse = jsonObject;
                
                /*
                 if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                 
                 NSDictionary *dictionary = jsonObject;
                 NSNumber *successNumber = dictionary[@"success"];
                 if (successNumber) {
                 BOOL success = successNumber.boolValue;
                 if (!success) {
                 NSString *error = dictionary[@"message"];
                 errorMessage = error;
                 
                 if (response.statusCode == 401 && [self isUserLoggedIn]) {
                 [self logoff];
                 }
                 }
                 }
                 else {
                 
                 NSString *serverErrorMessage = [dictionary[@"error"][@"messages"] lastObject];
                 if (serverErrorMessage) {
                 errorMessage = serverErrorMessage;
                 }
                 }
                 
                 }
                 
                 */
                
            }
        }
        else {
            if (parsingError) {
                errorMessage = NSLocalizedString(@"GenericParseError", nil);
            }
        }
    }
    
    
    if (error) {
        errorMessage = NSLocalizedString(@"GenericConnectionError", nil);
    }
    
    *resolvedMessage = errorMessage;
    
    return response.statusCode;
}

#pragma mark - Core Data

- (NSManagedObjectContext *)backgroundManagedObjectContext {
    
    if (!_backgroundManagedObjectContext)
    {
        _backgroundManagedObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _backgroundManagedObjectContext.parentContext = self.managedObjectContext;
    }
    
    return _backgroundManagedObjectContext;
}

- (NSManagedObjectContext *)managedObjectContext {
	if(!_managedObjectContext) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
	return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
	if(!_managedObjectModel)
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
	return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	if(!_persistentStoreCoordinator) {
        NSString * appSupportDirectory = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        BOOL dirExists = [[NSFileManager defaultManager] fileExistsAtPath:appSupportDirectory];
        if (dirExists == NO) {
            [[NSFileManager defaultManager] createDirectoryAtPath:appSupportDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        
        NSURL *appSupportURL = [NSURL URLWithString:appSupportDirectory];
        [appSupportURL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
        
        NSString *storePath = [appSupportDirectory stringByAppendingPathComponent:@"MallTip.sqlite"];
        NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        
        NSError *error = nil;
        if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
            DLog(@"Error loading persistent store: %@", error);
            
            NSError *removeError;
            BOOL removed = [[NSFileManager defaultManager] removeItemAtPath:storePath error:&removeError];
            if (removed) {
                if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
                    DLog(@"Error re-adding persistent store: %@", error);
                }
                else {
                    DLog(@"Removed previous store and re-added clean one.");
                }
                
            }
            DLog(@"Error re-adding persistent store: %@", removeError);
            
            
        }
    }
	
    return _persistentStoreCoordinator;
}


- (void)save
{
    [self.backgroundManagedObjectContext performBlockAndWait:^{
        
        NSError *error;
        [self.backgroundManagedObjectContext save:&error];
        if (error) {
            NSLog(@"Error saving BACKGROUND Context");
        }
        [self.backgroundManagedObjectContext processPendingChanges];
    }];
    
    [self.managedObjectContext performBlockAndWait:^{
        
        NSError *error;
        [self.managedObjectContext save:&error];
        if (error) {
            NSLog(@"Error saving MAIN Context");
        }
        [self.managedObjectContext processPendingChanges];
    }];
}

- (void)removeAllCoreDataObjectsFormContext:(NSManagedObjectContext*) useContext
{
    NSError *error;
    NSArray *entities = self.managedObjectModel.entities;
    
    for (NSEntityDescription *entity in entities)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        [fetchRequest setIncludesPropertyValues:NO];
        
        NSArray *items = [useContext executeFetchRequest:fetchRequest error:&error];
        error = nil;
        
        for (NSManagedObject *managedObject in items) {
            [managedObject.managedObjectContext deleteObject:managedObject];
        }
    }
    [useContext processPendingChanges];
}

- (void)removeAllCoreDataObjects
{
    [self removeAllCoreDataObjectsFormContext:self.managedObjectContext];
    [self removeAllCoreDataObjectsFormContext:self.backgroundManagedObjectContext];
    [self save];
}

+ (NSArray*)fetchObjectsWithEntityName:(NSString*)entityName predicates:(NSPredicate*)predicate inContext:(NSManagedObjectContext*)context
{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    [request setPredicate: predicate];
    return [context executeFetchRequest:request error:NULL];
}

+ (NSMutableArray *)managedObjects:(NSArray *)objects convertToContext:(NSManagedObjectContext *)context
{
    NSMutableArray *objectsInNewContext = [NSMutableArray array];
    for (NSManagedObject *object in objects) {
        NSManagedObjectID *objectID = object.objectID;
        [objectsInNewContext addObject:[context objectWithID:objectID]];
    }
    
    return objectsInNewContext;
    
}

@end
