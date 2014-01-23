//
//  AppDelegate.h
//  Malltip
//
//  Created by Jin Ming on 1/23/14.
//  Copyright (c) 2013 Jin Ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UIViewController * viewController;

+ (AppDelegate *) sharedDelegate;
- (NSString *)applicationDocumentsDirectoryInStringForm;

@end
