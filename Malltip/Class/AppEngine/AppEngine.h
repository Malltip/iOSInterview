//
//  DMAppEngine.h
//  Hyundai
//
//  Created by Jinhe on 6/19/13.
//  Copyright (c) 2013 jinhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface AppEngine : NSObject <CLLocationManagerDelegate>

@property (nonatomic, retain) NSString * fbid;
@property (nonatomic, retain) NSString * fbname;
@property (nonatomic, retain) NSString * fbpicurl;
@property (nonatomic, retain) NSString * fbtoken;

@property (nonatomic, retain) NSString * userid;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * phone;

@property (nonatomic, strong) CLLocation * location;
@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, retain) NSString * locationName;

#pragma mark - shared Instance
+ (AppEngine *) sharedInstance;

#pragma mark - Web Service
- (void) sendToService:(void (^)(id _responseObject)) _success
               failure:(void (^)(NSError * _error)) _failure;

#pragma mark - Alert
- (void) showAlertView:(NSString *) _title message:(NSString *) _message;

@end
