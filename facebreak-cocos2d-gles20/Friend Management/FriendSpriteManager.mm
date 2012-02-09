//
//  FriendSpriteManager.m
//  facebreak-cocos2d-gles20
//
//  Created by Truman, Christopher on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendSpriteManager.h"
#import "SynthesizeSingleton.h"

@interface FriendSpriteManager ()

- (void)fbConnected;
- (void)receivedFriends:(NSNotification*)notification;

@end

@implementation FriendSpriteManager

SYNTHESIZE_SINGLETON_FOR_CLASS(FriendSpriteManager)

@synthesize friendSpriteArray = _friendSpriteArray, friendDictionary = _friendDictionary, delegate = _delegate;

-(id)init{
    if (self = [super init]) {
        self.friendSpriteArray = [[NSMutableArray alloc] init];
        self.friendDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)fetchFriends {
  if (![[FacebookSupport sharedFacebookSupport] connected]) {
    [[FacebookSupport sharedFacebookSupport] connect];
  } else{
    [self fbConnected];
  }
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedFriends:) name:kFacebookFriendsListReceivedNotificationKey object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fbConnected) name:kFacebookConnectedNotificationKey object:nil];
}

- (NSString*)nameForFBID:(NSString*)identifier{
    return (NSString*)[self.friendDictionary objectForKey:identifier];
}

- (void)fbConnected {
  [[FacebookSupport sharedFacebookSupport] getFriendsList];
}

- (void)receivedFriends:(NSNotification*)notification {
  NSLog(@"%@", [notification description]);
  for (NSDictionary * friendDict in [[notification userInfo] objectForKey : @"FacebookSupportFriendsKey"]) {
      NSString * friendIdentifier = [friendDict objectForKey:@"id"];
      NSString * friendName = [friendDict objectForKey:@"name"];
      NSDictionary * tempDict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObject:friendName] forKeys:[NSArray arrayWithObject:friendIdentifier]];
    [self.friendDictionary addEntriesFromDictionary:tempDict];
    FacebookSprite * fs = [[FacebookSprite alloc] init];
    [fs getFriendPhoto:[friendDict objectForKey:@"id"]];
    [self.friendSpriteArray addObject:fs];
    [fs release];
  }
    [self.delegate finishedLoadingSprites];
}

- (void) dealloc {
  [self.friendSpriteArray release];
  _friendSpriteArray = nil;
    [self.friendDictionary release];
    _friendDictionary = nil;
    if (self.delegate) {
        _delegate = nil;
    }
  [super dealloc];
}

@end
