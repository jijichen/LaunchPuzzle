//
//  Level.m
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/19/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <math.h>
#import "GameScene.h"
#import "CCPhysics+ObjectiveChipmunk.h"
#import "Level.h"
#import "Tool.h"
#import "Constants.h"

const float initialForce = 5.0f;
const double epsilon = 0.0000001f;

@interface GameScene()

-(void) resetPlate;

@end

@implementation GameScene {
    CCNode* _plate;
    CCNode* _contentNode;
    CCPhysicsNode* _physicsNode;
    CCNode* _levelNode;
    CCNode* _target;
    CCNode* _toolBox;
    
    CGPoint originalPlatePosition;
    CGPoint prevTouchLocation;
    CGPoint touchEndLocation;
    CCTime timeCurrent;
    CCTime prevTime;
    CCTime timeEnd;
    Boolean launchStarted;
}


// -----------------------------------------------------------------------------
// Initialize and loading
// -----------------------------------------------------------------------------
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

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    originalPlatePosition = _plate.position;
    _physicsNode.debugDraw = false;
    _physicsNode.collisionDelegate = self;
    [_physicsNode.space setDamping:1.0f];
    [self loadLevel:@"Levels/level1"];
}

- (void)loadLevel:(NSString*)levelName {
    Level* levelToLoad = (Level *)[CCBReader load:levelName];
    [_physicsNode addChild:levelToLoad];
    
    //Initialize Tool box
    NSMutableArray* toolsToLoad = [[NSMutableArray alloc] init];
    NSMutableArray* toolsCount = [[NSMutableArray alloc] init];
    if (levelToLoad.countToolStick > 0) {
        NSString* ccbName = [[Constants getTypeToCCBNameDict] objectForKey:[NSNumber numberWithInt:Stick]];
        CCNode* stick = [CCBReader load:ccbName];
        [toolsToLoad addObject:stick];
        [toolsCount addObject:[NSNumber numberWithInt:levelToLoad.countToolStick]];
    }
    
    for (int i = 0; i < [toolsToLoad count]; i++) {
        CCNode* toolToAdd = [toolsToLoad objectAtIndex:i];
        toolToAdd.positionType = CCPositionTypeMake(CCPositionUnitNormalized, CCPositionUnitNormalized,
                                                    CCPositionReferenceCornerBottomLeft);
        toolToAdd.position = CGPointMake(0.1 * (i + 1), 0.5);
        [_toolBox addChild:toolToAdd];
        
    }
}

// -----------------------------------------------------------------------------
// Update and state check
// -----------------------------------------------------------------------------
-(void)update:(CCTime)delta {
    timeCurrent += delta;
    
//    if (CGRectIntersectsRect(_target.boundingBox, _plate.boundingBox)) {
//        NSLog(@"Collision happed");
//        [self removeChild:_target cleanup:YES];
//    }
}

-(void)checkBoundary:(CCTime)delta {
    if (!CGRectContainsPoint([_contentNode boundingBox], _plate.position)) {
        [self resetPlate];
    }
}

-(void)resetPlate {
    _plate.physicsBody.velocity = CGPointMake(0, 0);
    _plate.physicsNode.rotation = 0.0f;
    _plate.position = originalPlatePosition;
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair Target:(CCNode *)nodeA wildcard:(CCNode *)nodeB{
    [[_physicsNode space] addPostStepBlock:^{
        [self targetRemoved:nodeA];
    } key:nodeA];
}

-(void) targetRemoved:(CCNode *)target {
    [target removeFromParent];
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
        CGPoint forceDirection = [GameScene getDirection:prevTouchLocation to: touchEndLocation];
        double velocity =
            [GameScene distanceBetween:prevTouchLocation and:touchEndLocation] / (double)(timeEnd - prevTime);
        
        
        CGPoint launchForceVec = ccpMult(forceDirection, initialForce * velocity);
        NSLog(@"Lauch with force : (%lf, %lf)", launchForceVec.x, launchForceVec.y);
        [_plate.physicsBody applyForce:launchForceVec];
        launchStarted = false;
    }
  
}

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

@end
