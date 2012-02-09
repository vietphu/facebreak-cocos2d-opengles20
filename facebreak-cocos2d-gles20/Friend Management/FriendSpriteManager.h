//
//  FriendSpriteManager.h
//  facebreak-cocos2d-gles20
//
//  Created by Truman, Christopher on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

#import "FacebookSprite.h"

#import "FacebookSupport.h"

@interface FriendSpriteManager : NSObject
{
  NSMutableArray * _friendSpriteArray;
  NSMutableDictionary * _friendDictionary;
  id _delegate;
}

@property (nonatomic, retain) NSMutableArray * friendSpriteArray;
@property (nonatomic, retain) NSMutableDictionary * friendDictionary;
@property (nonatomic, assign) id delegate;

+ (FriendSpriteManager*)sharedFriendSpriteManager;

- (void)fetchFriends;

- (NSString*)nameForFBID:(NSString*)identifier;

@end


@protocol FriendSpriteManagerDelegate <NSObject>

-(void)finishedLoadingSprites;

@end