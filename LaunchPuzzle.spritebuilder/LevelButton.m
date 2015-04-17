//
// Created by Yizhe Chen on 4/17/15.
// Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LevelButton.h"
#import "GameScene.h"

@implementation LevelButton {

}

-(void)playLevel {
    CCScene *scene = [CCBReader loadAsScene:@"GameScene"];
    //[gameScene setCurrentLevel:1];
    GameScene *gameScene = (GameScene *)[scene.children objectAtIndex:0];
    [gameScene loadLevel:[self level]];
    [[CCDirector sharedDirector] replaceScene:scene];
}
@end