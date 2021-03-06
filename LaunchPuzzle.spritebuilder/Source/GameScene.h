//
//  Level.h
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/19/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Constants.h"
#import "Tool.h"

@interface GameScene : CCNode <CCPhysicsCollisionDelegate>

/**
 Get normalized direction vector from two points
 */
+(CGPoint) getDirection:(CGPoint)p1 to:(CGPoint)p2;

/**
 Get distance scalar between two points
 */
+(double) distanceBetween:(CGPoint)p1 and:(CGPoint)p2;

/**
 Load a tool by its type.
 */
+ (Tool *)loadToolByType:(enum ToolType) type;

/**
* Check if object overlap with current scene objects (like plate, coin, preset objects, etc..)
*/
- (Boolean)checkOverlap:(CCNode *)target;

+ (float)getDistance:(CGPoint)point to:(CGPoint)to;

/**
* Load current scene with level
*/
- (void)loadLevel:(int)level;

/**
* Add object to physic node
*/
- (void) addObjToPhysicNode:(CCNode*)obj;

@end
