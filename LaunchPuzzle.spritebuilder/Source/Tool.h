//
//  Tool.h
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "Constants.h"

@class ToolBox;
@class GameScene;

@interface Tool : CCSprite <UIGestureRecognizerDelegate>

@property enum ToolType toolType;
@property BOOL inToolBox;
@property (weak) ToolBox* toolBox;
@property (weak) GameScene* gameScene;

@end
