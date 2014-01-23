//
//  DMAppEngine.m
//  Hyundai
//
//  Created by Jinhe on 6/19/13.
//  Copyright (c) 2013 jinhe. All rights reserved.
//

#import "AppEngine.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@implementation AppEngine


@synthesize fbid = _fbid;
@synthesize fbname = _fbname;
@synthesize fbpicurl = _fbpicurl;
@synthesize fbtoken = _fbtoken;

@synthesize userid = _userid;
@synthesize email = _email;
@synthesize phone = _phone;

@synthesize location = _location;
@synthesize locationManager = _locationManager;
@synthesize locationName = _locationName;

#pragma mark -
#pragma mark - shared Instance

+ (AppEngine *) sharedInstance {
    
    __strong static AppEngine * sharedInstance = nil;
	static dispatch_once_t onceToken;
    
	dispatch_once(&onceToken, ^{
        sharedInstance = [[AppEngine alloc] init];
	});
    
    return sharedInstance;
}

- (id)init {
    
    if ( self == [super init] ) {
        
//        CLLocationManager * manager = [[[CLLocationManager alloc] init] autorelease];
//        manager.delegate = self;
//        manager.desiredAccuracy = kCLLocationAccuracyBest;
//        [manager startUpdatingLocation];
//        
//        self.locationManager = manager;
//        self.location = nil;
    }
    
    return self;
}

- (void)dealloc {
    
    [super dealloc];
    
    _fbid = nil;
    _fbname = nil;
    _fbpicurl = nil;
    _fbtoken = nil;
    
    _userid = nil;
    _email = nil;
    _phone = nil;
    
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
    self.location = nil;
}

#pragma mark -
#pragma mark - CLLocationManager Delegate

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    self.location = newLocation;
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray * placemarks, NSError * error) {
        
        for ( CLPlacemark * placemark in placemarks ) {
            NSString * addressText = [NSString stringWithFormat:@"%@, %@, %@, %@", placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.administrativeArea];
            NSLog(@"%@", addressText);
            _locationName = placemark.locality;
        }
    }];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"Invalid Position");
}

#pragma mark -
#pragma mark - Web Service

- (void) sendToService:(void (^)(id _responseObject)) _success
               failure:(void (^)(NSError * _error)) _failure
{
    NSURL*                  url         = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient*           client      = [[AFHTTPClient alloc]initWithBaseURL:url];
    NSMutableURLRequest*    request     = [client requestWithMethod:@"GET" path:nil parameters:nil];
    AFHTTPRequestOperation* operation   = [[[AFHTTPRequestOperation alloc] initWithRequest:request] autorelease];
    
    [client registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^( AFHTTPRequestOperation * _operation, id _responseObject) {
        // Response Object ;
        id responseObject   = [NSJSONSerialization JSONObjectWithData:_responseObject
                                                              options:kNilOptions
                                                                error:nil ] ;
        // Success ;
        if (_success)
        {
            _success(responseObject) ;
        }
    } failure:^(AFHTTPRequestOperation * _operation, NSError * _error)
     {
         NSLog (@"%@", _error.description);
         // Failture ;
         if (_failure)
         {
             _failure(_error);
         }
     }];
    [operation start];
    [client release];
}

#pragma mark - 
#pragma mark - Alert

- (void) showAlertView:(NSString *) _title message:(NSString *) _message {
    
    [[[UIAlertView alloc] initWithTitle:_title message:_message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

@end
