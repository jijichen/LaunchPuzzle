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
#import "ToolBox.h"

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
    ToolBox* _toolBox;
    
    CGPoint originalPlatePosition;
    CGPoint prevTouchLocation;
    CGPoint touchEndLocation;
    CCTime timeCurrent;
    CCTime prevTime;
    CCTime timeEnd;
    Boolean launchStarted;
    Tool* toolToPlace;

    //Code connection redundancy due to cocos2d owner
    CCLabelTTF* _toolCount1;
    CCLabelTTF* _toolCount2;
    CCLabelTTF* _toolCount3;
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
        toolToPlace = nil;
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
    
    [_toolBox loadWithLevel:levelToLoad l1:_toolCount1 l2:_toolCount2 l3:_toolCount3];
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
//    //CCLOG(@"content boung : %f %f", [_contentNode boundingBox].size.width,[_contentNode boundingBox].size.height );
//    //CCLOG(@"plate position: %f %f", _plate.position.x , _plate.position.y);
//    if (!CGRectContainsPoint([_contentNode boundingBox], _plate.position)) {
//        [self resetPlate];
//    }

    if (_plate.position.x > 1.0 || _plate.position.y > 1.0) {
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
    } else if (!launchStarted ) {
        Tool* toolTouched = [_toolBox checkTouch:touch];
        if (toolTouched != nil) {
            toolToPlace = [GameScene loadToolByType:toolTouched.toolType];
            toolToPlace.inToolBox = false;
            toolToPlace.position = [touch locationInNode:_contentNode];
            [_physicsNode addChild:toolToPlace];
        }
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
    } else if (toolToPlace != nil) {
        toolToPlace.position = touchLocation;
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
    } else if (toolToPlace != nil) {
        //toolToPlace.physicsBody = [CCPhysicsBody bodyWithRect:toolToPlace.boundingBox cornerRadius:0.0];
        toolToPlace = nil;
    }
  
}

// -----------------------------------------------------------------------------
// Level Utility class functions
// -----------------------------------------------------------------------------
+ (Tool *)loadToolByType:(enum ToolType) type {
    NSString* ccbName = [[Constants getTypeToCCBNameDict] objectForKey:[NSNumber numberWithInt:type]];
    Tool* tool = (Tool*)[CCBReader load:ccbName];
    tool.toolType = type;
    return tool;
}

+ (CCSprite *)loadToolSpriteByType:(enum ToolType) type {
    NSString* imageName = [[Constants getTypeToImgNameDict] objectForKey:[NSNumber numberWithInt:type]];
    return [CCSprite spriteWithImageNamed:imageName];
}

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
