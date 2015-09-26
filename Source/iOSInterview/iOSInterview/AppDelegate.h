//
//  AppDelegate.h
//  iOSInterview
//
//  Created by MobileGenius on 1/23/14.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) MBProgressHUD  *loadingView;

+ (void) showWaitView :(NSString *) caption;
+ (void) hideWaitView;

@end
