//
//  Level.h
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/19/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface GameScene : CCNode <CCPhysicsCollisionDelegate>

/**
 Get normalized directio vector from two points
 */
+(CGPoint) getDirection:(CGPoint)p1 to:(CGPoint)p2;

/**
 Get distance scalar between two points
 */
+(double) distanceBetween:(CGPoint)p1 and:(CGPoint)p2;

@end
