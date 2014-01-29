//
//  AsyncImageView.m
//
//  Created by Wayne Cochran on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AsyncImageView.h"
#import "ImageCacheObject.h"
#import "ImageCache.h"

//
// Key's are URL strings.
// Value's are ImageCacheObject's
//
static ImageCache *imageCache = nil;
@implementation AsyncImageView
@synthesize isFinshedLoading;
@synthesize imageView;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
    {
        isFinshedLoading = NO;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


- (void)dealloc
{
    [connection cancel];
    [connection release];
    [data release];
    
    [imageView release];
    [super dealloc];
}

-(void)loadImageFromURL:(NSURL*)url
{
    if (connection != nil)
    {
        [connection cancel];
        [connection release];
        connection = nil;
    }
    if (data != nil)
    {
        [data release];
        data = nil;
    }
    
    if ([[self subviews] count] > 0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    if (imageCache == nil) // lazily create image cache
        imageCache = [[ImageCache alloc] initWithMaxSize:2*1024*1024];  // 2 MB Image cache
    
    [urlString release];
    urlString = [[url absoluteString] copy];
    UIImage *cachedImage = [imageCache imageForKey:urlString];
    if (cachedImage != nil) {
        
        isFinshedLoading = YES;
        if ([[self subviews] count] > 0)
        {
            [[[self subviews] objectAtIndex:0] removeFromSuperview];
        }
        imageView = [[UIImageView alloc] initWithImage:cachedImage];
        [imageView setClipsToBounds:YES];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:imageView];
        
        
        imageView.frame = self.bounds;
        [imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
        [self setNeedsLayout];
        
        
        
        
        return;
    }
    
#define SPINNY_TAG 5555
    
    UIActivityIndicatorView *spinny = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinny.tag = SPINNY_TAG;
    [spinny setCenter:CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0)];
    [spinny startAnimating];
    [self addSubview:spinny];
    [spinny release];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)incrementalData
{
    if (data==nil)
    {
        data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection
{
    [connection release];
    connection = nil;
    
    UIView *spinny = [self viewWithTag:SPINNY_TAG];
    [spinny removeFromSuperview];
    if ([[self subviews] count] > 0)
    {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    UIImage *image = [UIImage imageWithData:data];
    [imageCache insertImage:image withSize:[data length] forKey:urlString];
    imageView = [[UIImageView alloc] initWithImage:image];
    
    [imageView setClipsToBounds:YES];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:imageView];
    imageView.frame = self.bounds;
    [imageView setNeedsLayout];
    [self setNeedsLayout];
    
    
    isFinshedLoading = YES;
    
    [data release];
    data = nil;
}

@end
