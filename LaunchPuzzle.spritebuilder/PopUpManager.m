//
// Created by Yizhe Chen on 4/19/15.
// Copyright (c) 2015 Apportable. All rights reserved.
//

#import "PopUpManager.h"
#import "GameScene.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@implementation PopUpManager {

}



- (void)loadNextLevel {
    CCScene *scene = [CCBReader loadAsScene:@"GameScene"];
    GameScene *nextScene = (GameScene *) [scene.children objectAtIndex:0];
    [nextScene loadLevel:_currentLevel + 1];

    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

- (void)shareOnFacebook {
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"http://launchpuzzle.yizhe-chen.com"];
    content.contentTitle = [NSString stringWithFormat:@"I've break the %d level of Launch Puzzle!", _currentLevel];
    content.contentDescription = @"Awesome, huh? : )";

    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.fromViewController = [CCDirector sharedDirector];
    [dialog setShareContent:content];
    dialog.mode = FBSDKShareDialogModeShareSheet;
    [dialog show];
}


@end