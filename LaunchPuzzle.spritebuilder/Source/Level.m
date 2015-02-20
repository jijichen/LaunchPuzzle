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

-(void) resetPlate;

@end

@implementation Level {
    CCNode* _plate;
    CCNode* _contentNode;
    CCPhysicsNode* _physicsNode;
    
    CGPoint originalPlatePosition;
    CGPoint prevTouchLocation;
    CGPoint touchEndLocation;
    CCTime timeCurrent;
    CCTime prevTime;
    CCTime timeEnd;
    Boolean launchStarted;
}


- (id)init
{
    self = [super init];
    if (self) {
        //[self schedule:@selector(update:)];
        [self schedule:@selector(checkBoundary:) interval:(CCTime) 1];
        timeCurrent = (CCTime)0;
    }
    return self;
}

-(void)update:(CCTime)delta {
    timeCurrent += delta;
}

-(void)checkBoundary:(CCTime)delta {
    if (!CGRectContainsPoint([self boundingBox], _plate.position)) {
        [self resetPlate];
    }
}

-(void)resetPlate {
    _plate.physicsBody.velocity = CGPointMake(0, 0);
    _plate.position = originalPlatePosition;
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    originalPlatePosition = _plate.position;
    _physicsNode.debugDraw = true;
    _physicsNode.collisionDelegate = self;
}


// -----------------------------------------------------------------------------
// UI touch to launch
// -----------------------------------------------------------------------------
-(void) touchBegan:(CCTouch *)touch withEvent:(UIEvent *)event
{
    prevTouchLocation = [touch locationInNode:_contentNode];
    prevTime = timeCurrent;
    
    if (!launchStarted && CGRectContainsPoint([_plate boundingBox], prevTouchLocation))
    {
        launchStarted = true;
        [_plate.physicsBody setVelocity:CGPointMake(0, 0)];
        //_plate.position = touchStartLocation;
    }
}

-(void) touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    
    if (launchStarted){
        //[_plate.physicsBody setVelocity:CGPointMake(0, 0)];
        //_plate.position = touchLocation;
        prevTouchLocation = touchLocation;
        prevTime = timeCurrent;
    }
}

-(void) touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    touchEndLocation = [touch locationInNode:_contentNode];
    timeEnd = timeCurrent;
    
    if (launchStarted && timeEnd != prevTime) {
        CGPoint forceDirection = [Level getDirection:prevTouchLocation to: touchEndLocation];
        double velocity =
            [Level distanceBetween:prevTouchLocation and:touchEndLocation] / (double)(timeEnd - prevTime);
        
        
        CGPoint launchForceVec = ccpMult(forceDirection, initialForce * velocity);
        NSLog(@"Lauch with force : (%lf, %lf)", launchForceVec.x, launchForceVec.y);
        [_plate.physicsBody applyForce:launchForceVec];
        launchStarted = false;
    }
  
}
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Level Uitility class funcitons
// -----------------------------------------------------------------------------
+(CGPoint) getDirection:(CGPoint)p1 to:(CGPoint)p2
{
    double length = [self distanceBetween:p1 and:p2];
    double xdiff = p2.x - p1.x;
    double ydiff = p2.y - p1.y;
    
    if (length - 0 < epsilon) {
        return CGPointMake(0, 0);
    }
    
    return CGPointMake(xdiff / length, ydiff / length);
}

+(double) distanceBetween:(CGPoint)p1 and:(CGPoint)p2
{
    double xdiff = p2.x - p1.x;
    double ydiff = p2.y - p1.y;
    double length = sqrt(pow(xdiff, 2) + pow(ydiff, 2));
    
    return length;
}
// -----------------------------------------------------------------------------

@end
