//
//  FacebookImage.m
//
//  Created by Administrator on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FacebookImage.h"
#import <QuartzCore/QuartzCore.h>

@implementation FacebookImage

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.autoresizesSubviews = YES;
    
    loadingActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loadingActivity.hidesWhenStopped = YES;
    if ([loadingActivity isAnimating]) {
        [loadingActivity stopAnimating];
    }
    loadingActivity.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    loadingActivity.layer.cornerRadius = 3.0f;
    loadingActivity.center = CGPointMake(frame.size.width/2., frame.size.height/2.);
    loadingActivity.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
    [self addSubview:loadingActivity];
    
    return self;
}

- (void)getFriendPhoto:(NSString*)identifier {
    if (!facebook) {
        facebook = [[Facebook alloc] initWithAppId:@"6621526385"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"] 
            && [defaults objectForKey:@"FBExpirationDateKey"]) {
            facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }
    }
    if ([facebook isSessionValid]) {
        if (friendIdentifier) {
            [friendIdentifier release];
            friendIdentifier = nil;
        }
        friendIdentifier = [[NSString alloc] initWithString:identifier];
        AppController * appDelegate = (AppController*)[[UIApplication sharedApplication] delegate];

        NSString *path = [[appDelegate applicationCacheDirectory] stringByAppendingPathComponent:@"FacebookImages"];
        BOOL directory = NO;
        if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&directory]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        } else {
            if (!directory) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }
        path = [path stringByAppendingPathComponent:friendIdentifier];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:nil]) {
            self.image = [UIImage imageWithContentsOfFile:path];
            if ([loadingActivity isAnimating]) {
                [loadingActivity stopAnimating];
            }
        } else {
            self.image = nil;
            if (![loadingActivity isAnimating]) {
                [loadingActivity startAnimating];
            }
        }
        [facebook requestWithGraphPath:[NSString stringWithFormat:@"%@/picture", identifier] andDelegate:self];
    }
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    //  check if request was picture request
    if ([result isKindOfClass:[NSData class]]&&[request.url hasSuffix:@"picture"]) {
        AppController * appDelegate = (AppController*)[[UIApplication sharedApplication] delegate];

        NSString *path = [[[appDelegate applicationCacheDirectory] stringByAppendingPathComponent:@"FacebookImages"] stringByAppendingPathComponent:friendIdentifier];
        [result writeToFile:path atomically:YES];
        if ([[[request.url stringByReplacingOccurrencesOfString:@"https://graph.facebook.com/" withString:@""] stringByReplacingOccurrencesOfString:@"/picture" withString:@""] isEqualToString:friendIdentifier]) {
            self.image = [UIImage imageWithData:result];
        }
    }
    if ([loadingActivity isAnimating]) {
        [loadingActivity stopAnimating];
    }
}

- (void)dealloc {
    if (facebook) {
        [facebook release];
        facebook = nil;
    }
    if (loadingActivity) {
        [loadingActivity release];
        loadingActivity = nil;
    }
    [super dealloc];
}

@end
