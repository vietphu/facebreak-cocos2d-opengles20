//
//  NameDisplay.m
//  facebreak-cocos2d-gles20
//
//  Created by Truman, Christopher on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NameDisplay.h"

@implementation NameDisplay

@synthesize nameLabel = _nameLabel;

-(id)init{
    if (self = [super init]) {
        self.nameLabel = [[CCLabelTTF alloc] initWithString:@"_" fontName:@"Helvetica" fontSize:16];
        [self.nameLabel setPosition:CGPointMake(240, 240)];
        [self addChild:self.nameLabel];
    }
    return self;
}

-(void)dealloc{
    [self.nameLabel dealloc];
    _nameLabel = nil;
    [super dealloc];
}

@end
