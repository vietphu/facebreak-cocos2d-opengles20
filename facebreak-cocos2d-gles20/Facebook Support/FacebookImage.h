//
//  FacebookImage.h
//
//  Created by Administrator on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"
#import "AppDelegate.h"

@interface FacebookImage : UIImageView <FBRequestDelegate> {
    Facebook *facebook;
    UIActivityIndicatorView *loadingActivity;
    NSString *friendIdentifier;
}

- (void)getFriendPhoto:(NSString*)identifier;

@end
