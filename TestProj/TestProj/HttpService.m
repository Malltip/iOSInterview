//
//  HttpService.m
//  TestProj
//
//  Created by Dan Kolov on 1/29/14.
//  Copyright (c) 2014 Dan Kolov. All rights reserved.
//

#import "HttpService.h"
#import "AppData.h"

@implementation HttpService
{
    NSData * _recieveData;
}

-(void)sendAsyncPostRequestWithUrl:(NSURL *)url data:(NSData *)data type:(int)type{
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * response, NSData *data, NSError * error) {
//                               if (error != nil){
//                                   NSLog(@"send asyncPost fail case by:%@",error);
//                                   return;
//                               }
                               
                               [self.delegate performSelector:@selector(httpServiceDidPostWithReceiveData:type:)
                                                   withObject:data
                                                   withObject:[NSNumber numberWithInt:type]];
                           }];
    NSLog(@"send post http did");
}




- (void)requestDataFromUrl:(NSURL *)url type:(int)type{
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                             timeoutInterval:10];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        if (error != nil){
            NSLog(@"request data fail case by:%@",error);
//            return;
        }
        
        [self.delegate performSelector:@selector(httpServiceDidRequestData:type:) withObject:data withObject:[NSNumber numberWithInt:type]];

    }];
}


@end
