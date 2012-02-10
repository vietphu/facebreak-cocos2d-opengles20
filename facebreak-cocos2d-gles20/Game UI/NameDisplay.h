//
//  NameDisplay.h
//  facebreak-cocos2d-gles20
//
//  Created by Truman, Christopher on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface NameDisplay : CCLayer {
    CCLabelTTF * _nameLabel;
}

@property (nonatomic, retain) CCLabelTTF * nameLabel;

@end
