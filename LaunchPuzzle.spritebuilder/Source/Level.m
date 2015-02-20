//
//  Level.m
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/19/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Level.h"

@implementation Level {
    CCNode* _plate;
    CCNode* _contentNode;
    CCPhysicsNode* _physicsNode;
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    _physicsNode.debugDraw = true;
    _physicsNode.collisionDelegate = self;
}

-(void) touchBegan:(CCTouch *)touch withEvent:(UIEvent *)event
//-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    
    if (CGRectContainsPoint([_plate boundingBox], touchLocation))
    {
        // move the mouseJointNode to the touch position
        _plate.position = touchLocation;
    }
}

-(void) touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    
    _plate.position = touchLocation;
}
@end
