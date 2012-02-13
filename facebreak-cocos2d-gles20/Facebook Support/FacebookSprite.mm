//
//  FacebookSprite.m
//
//  Created by Administrator on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FacebookSprite.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface FacebookSprite ()
- (void)spriteFromFile:(NSString*)path;
@end

@implementation FacebookSprite

@synthesize  sprite = _sprite, friendIdentifier = _friendIdentifier, loaded;

-(id)init{
    if (self = [super init]) {
        loaded = NO;
    }
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
	[self setFriendIdentifier:identifier];
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
	path = [path stringByAppendingPathComponent:self.friendIdentifier];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:nil]) {
	    [self performSelectorOnMainThread:@selector(spriteFromFile:) withObject:path waitUntilDone:YES];
	} else {
	    //no image
	}
	[self performSelectorOnMainThread:@selector(facebookRequestForID:) withObject:identifier waitUntilDone:YES];
    }
}

- (void)facebookRequestForID:(NSString*)identifier {
    [facebook requestWithGraphPath:[NSString stringWithFormat:@"%@/picture", self.friendIdentifier] andDelegate:self];
}

- (void)spriteFromFile:(NSString*)path {
    self.sprite = [[PhysicsSprite alloc] initWithFile:path];
    self.loaded = YES;
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    //  check if request was picture request
    if ([result isKindOfClass:[NSData class]]&&[request.url hasSuffix:@"picture"]) {
	AppController * appDelegate = (AppController*)[[UIApplication sharedApplication] delegate];
	NSString *path = [[[appDelegate applicationCacheDirectory] stringByAppendingPathComponent:@"FacebookImages"] stringByAppendingPathComponent:self.friendIdentifier];
	[result writeToFile:path atomically:YES];
        if ([[[request.url stringByReplacingOccurrencesOfString:@"https://graph.facebook.com/" withString:@""] stringByReplacingOccurrencesOfString:@"/picture?type=square" withString:@""] isEqualToString:self.friendIdentifier]) {
            CCTexture2D * friendTexture = [[CCTexture2D alloc] initWithData:result pixelFormat:kCCTexture2DPixelFormat_RGB888 pixelsWide:50 pixelsHigh:50 contentSize:CGSizeMake(50, 50)];
            self.sprite = [[PhysicsSprite alloc] initWithTexture:friendTexture];
            self.loaded = YES;
        }
    }
}

- (void)dealloc {
    [facebook release];
    facebook = nil;
    [self.sprite release];
    _sprite = nil;

    [super dealloc];
}

@end
