//
//  FacebookSprite.h
//
//  Created by Administrator on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "PhysicsSprite.h"
#import "FBConnect.h"

@interface FacebookSprite : NSObject <FBRequestDelegate> {
  Facebook *facebook;
  NSString *_friendIdentifier;
  PhysicsSprite * _sprite;
    BOOL loaded;
}

@property (atomic, retain) NSString * friendIdentifier;
@property (atomic, retain) PhysicsSprite * sprite;
@property (atomic, readwrite) BOOL loaded;

- (void)getFriendPhoto:(NSString*)identifier;

@end
