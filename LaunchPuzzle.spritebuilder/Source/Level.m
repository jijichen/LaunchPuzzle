//
//  Level.m
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/19/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Level.h"
#import <math.h>

const float initialForce = 5.0f;
const double epsilon = 0.0000001f;

@interface Level()

-(CGPoint) getDirection:(CGPoint)p1 to:(CGPoint)p2;
-(double) distanceBetween:(CGPoint)p1 and:(CGPoint)p2;

@end

@implementation Level {
    CCNode* _plate;
    CCNode* _contentNode;
    CCPhysicsNode* _physicsNode;
    
    CGPoint touchStartLocation;
    CGPoint touchEndLocation;
    CCTime timeCurrent;
    CCTime timeStart;
    CCTime timeEnd;
    Boolean launchStarted;
}

- (id)init
{
    self = [super init];
    if (self) {
        //[self schedule:@selector(update:)];
        timeCurrent = (CCTime)0;
    }
    return self;
}

-(void)update:(CCTime)delta {
    timeCurrent += delta;
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
    touchStartLocation = [touch locationInNode:_contentNode];
    timeStart = timeCurrent;
    
    if (CGRectContainsPoint([_plate boundingBox], touchStartLocation))
    {
        launchStarted = true;
        [_plate.physicsBody setVelocity:CGPointMake(0, 0)];
        // move the mouseJointNode to the touch position
        _plate.position = touchStartLocation;
    }
}

-(void) touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    
    if (launchStarted){
        [_plate.physicsBody setVelocity:CGPointMake(0, 0)];
        _plate.position = touchLocation;
        touchStartLocation = touchLocation;
        timeStart = timeCurrent;
    }
}

-(void) touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    touchEndLocation = [touch locationInNode:_contentNode];
    timeEnd = timeCurrent;
    
    if (launchStarted && timeEnd != timeStart) {
        CGPoint forceDirection = [self getDirection:touchStartLocation to: touchEndLocation];
        double velocity = [self distanceBetween:touchStartLocation and:touchEndLocation] / (double)(timeEnd - timeStart);
        
        
        CGPoint launchForceVec = ccpMult(forceDirection, initialForce * velocity);
        [_plate.physicsBody applyForce:launchForceVec];
        launchStarted = false;
    }
  
}
     
-(CGPoint) getDirection:(CGPoint)p1 to:(CGPoint)p2
{
    double length = [self distanceBetween:p1 and:p2];
    double xdiff = p2.x - p1.x;
    double ydiff = p2.y - p1.y;
    
    if (length - 0 < epsilon) {
        return CGPointMake(0, 0);
    }
    
    return CGPointMake(xdiff / length, ydiff / length);
}

-(double) distanceBetween:(CGPoint)p1 and:(CGPoint)p2
{
    double xdiff = p2.x - p1.x;
    double ydiff = p2.y - p1.y;
    double length = sqrt(pow(xdiff, 2) + pow(ydiff, 2));
    
    return length;
}
@end
