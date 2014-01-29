//
//  AsyncImageView.h
//  YellowJacket
//
//  Created by Wayne Cochran on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


//
//

#import <UIKit/UIKit.h>


@interface AsyncImageView : UIImageView {
    NSURLConnection *connection;
    NSMutableData *data;
    NSString *urlString; // key for image cache dictionary
}
@property BOOL isFinshedLoading;
@property (nonatomic, retain) UIImageView *imageView;

-(void)loadImageFromURL:(NSURL*)url;

@end
