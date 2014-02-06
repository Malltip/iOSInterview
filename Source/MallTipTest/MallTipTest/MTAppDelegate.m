//
//  MTAppDelegate.m
//  MallTipTest
//
//  Created by Matthew Griffin on 2/5/14.
//  Copyright (c) 2014 Matthew Griffin. All rights reserved.
//

#import "MTAppDelegate.h"
#import "MTTableViewController.h"

@implementation MTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSURL *baseURL = [NSURL URLWithString:@"https://m.malltip.com/api/v1"];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    //[RKObjectManager setSharedManager:objectManager];
    

    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
    
    
    
    RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"Feed" inManagedObjectStore:managedObjectStore];
    [entityMapping addAttributeMappingsFromDictionary:@{
                                                        @"feedId":             @"feedId",
                                                        @"retailerId":            @"retailerId",
                                                        @"dateValid":    @"dateValid",
                                                        @"hasLogo":         @"hasLogo",
                                                        @"title":     @"title"}];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:entityMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"feeds" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    [managedObjectStore createPersistentStoreCoordinator];
    [managedObjectStore addInMemoryPersistentStore:nil];

    
    
    
    [managedObjectStore createManagedObjectContexts];
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.mainQueueManagedObjectContext];
    [RKManagedObjectStore setDefaultStore:managedObjectStore];
    MTTableViewController *controller = (MTTableViewController *)((UINavigationController*)self.window.rootViewController).topViewController;
    controller.managedObjectContext = managedObjectStore.mainQueueManagedObjectContext;
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}


@end
