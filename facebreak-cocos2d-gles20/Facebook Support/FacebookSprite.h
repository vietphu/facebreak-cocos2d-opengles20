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
}

@property (nonatomic, retain) NSString * friendIdentifier;
@property (nonatomic, retain) PhysicsSprite * sprite;

- (void)getFriendPhoto:(NSString*)identifier;

@end
