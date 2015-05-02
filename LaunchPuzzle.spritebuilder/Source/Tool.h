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

-(void) secondTouchBegin:(CCTouch *) touch;
-(void) secondTouchMoved:(CCTouch *) touch;
-(void) secondTouchEnded:(CCTouch *) touch;
-(void) setAllGestureEnabled:(Boolean) on;


@property enum ToolType toolType;
@property BOOL inToolBox;
@property (weak) ToolBox* toolBox;
@property (weak) GameScene* gameScene;
@property double rotationAngle;
@property BOOL placeColliding;
@end
