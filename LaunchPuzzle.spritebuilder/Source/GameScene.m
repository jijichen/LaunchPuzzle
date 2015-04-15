//
//  Level.m
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/19/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <math.h>
#import <CoreGraphics/CoreGraphics.h>
#import "GameScene.h"
#import "CCPhysics+ObjectiveChipmunk.h"
#import "Level.h"
#import "ToolBox.h"
#import "Bomb.h"
#import "Target.h"
#import "Plate.h"

@interface GameScene ()

- (void)afterOneTrial;

- (void)levelSuccess;

@end

@implementation GameScene {
    //Code connection with spriteBuilder CCB file for game scene
    CCNode *_plate;
    CCNode *_contentNode;
    CCPhysicsNode *_physicsNode;
    Level *_levelNode;
    ToolBox *_toolBox;
    CCNode *_livesIndicator;
    CCNode *popUp;

    //State data for internal use
    CGPoint originalPlatePosition;
    CGPoint touchStartLocation;
    CGPoint touchEndLocation;
    CCTime timeCurrent;
    CCTime prevTime;
    CCTime timeEnd;
    Boolean launchStarted;
    Boolean launchGoing;
    int currentLevel;

    //Temporary data cross methods
    Tool *toolToPlace;

    //Code connection redundancy due to cocos2d owner
    CCLabelTTF *_toolCount1;
    CCLabelTTF *_toolCount2;
    CCLabelTTF *_toolCount3;

    //Tool Rotation handler
    Tool* toolToRotate;
}


// -----------------------------------------------------------------------------
// Initialize and loading
// -----------------------------------------------------------------------------
- (id)init {
    self = [super init];
    if (self) {
        //[self schedule:@selector(update:)];
        [self schedule:@selector(checkBoundary:) interval:(CCTime) 1];
        timeCurrent = (CCTime) 0;
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
}

- (void)loadLevel:(int)level {
    currentLevel = level;
    NSString *levelPath = [NSString stringWithFormat:@"Levels/Level%d", currentLevel];
    Level *levelToLoad = (Level *) [CCBReader load:levelPath];
    [_toolBox loadWithLevel:levelToLoad l1:_toolCount1 l2:_toolCount2 l3:_toolCount3 withScene:self];
    [_toolBox setUserInteractionEnabled:YES];
    [_physicsNode addChild:levelToLoad];
    _levelNode = levelToLoad;
    //Setup live count
    [self updateLiveIndicator:levelToLoad.liveCount];
    self.paused = NO;

    _plate.userInteractionEnabled = true;
}

- (void)addObjToPhysicNode:(CCNode *)obj {
    [_physicsNode addChild:obj];
}

- (void)oneTouchOnTool:(bool)toggle atTool:(Tool *)tool {
    if (toggle) {
        toolToRotate = tool;
    } else if (tool == toolToRotate) {
        toolToRotate = nil;
    }
}

- (void)loadNextLevel {
    CCScene *scene = [CCBReader loadAsScene:@"GameScene"];
    GameScene *nextScene = (GameScene *) [scene.children objectAtIndex:0];
    [nextScene loadLevel:currentLevel + 1];

    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

// -----------------------------------------------------------------------------
// State transition
// -----------------------------------------------------------------------------
- (void)levelSuccess {
    self.paused = YES;

    launchGoing = NO;
    if (currentLevel + 1 > Constants.totalLevelCount) {
        //TODO pop up finish all levels window
    } else {
        popUp = [CCBReader load:@"Success" owner:self];
        popUp.positionType = CCPositionTypeNormalized;
        popUp.anchorPoint = ccp(0.5, 0.5);
        popUp.position = ccp(0.5, 0.5);
        [self addChild:popUp];
    }
}

- (void)levelFail {
    self.paused = YES;

    launchGoing = NO;
    popUp = [CCBReader load:@"Fail" owner:self];
    popUp.positionType = CCPositionTypeNormalized;
    popUp.anchorPoint = ccp(0.5, 0.5);
    popUp.position = ccp(0.5, 0.5);
    [self addChild:popUp];
}

- (void)levelReset {
    self.paused = YES;
    currentLevel -= 1;
    [self loadNextLevel];
}

// -----------------------------------------------------------------------------
// Update and state check
// -----------------------------------------------------------------------------
- (void)update:(CCTime)delta {
    timeCurrent += delta;
}

- (void)checkBoundary:(CCTime)delta {
    if (launchGoing) {
        //NSLog(@"x : %f, y : %f", _plate.position.x, _plate.position.y);
        if (_plate.position.x > 1.0 || _plate.position.y > 1.0 || _plate.position.x < 0 || _plate.position.y < 0) {
            [self afterOneTrial];
            return;
        }

        CGFloat velocityScalar = pow(_plate.physicsBody.velocity.x, 2.0) + pow(_plate.physicsBody.velocity.y, 2.0);
        if (velocityScalar <= 64) {
            [self afterOneTrial];
        }
    }
}

- (void)afterOneTrial {
    [self resetPlate];

    _levelNode.liveCount -= 1;
    launchGoing = false;
    launchStarted = false;
    [self updateLiveIndicator:_levelNode.liveCount];

    if (_levelNode.liveCount == 0) {
        [self levelFail];
    }
}

- (void)resetPlate {
    _plate.physicsBody.velocity = CGPointMake(0, 0);
    _plate.physicsNode.rotation = 0.0f;
    _plate.position = originalPlatePosition;
    _plate.userInteractionEnabled = YES;
    [_toolBox setVisible:true];
}

- (void)updateLiveIndicator:(int)liveCount {
    [_livesIndicator removeAllChildren];
    for (int i = 0; i < liveCount; ++i) {
        CCNode *plateInd = [CCBReader load:[Constants getPlateCCBName]];
        plateInd.positionType = CCPositionTypeMake(CCPositionUnitNormalized, CCPositionUnitNormalized,
                CCPositionReferenceCornerBottomLeft);
        plateInd.position = CGPointMake(0.2 * (i), 0.5);
        plateInd.anchorPoint = CGPointMake(0.0, 0.5);
        plateInd.scale = 0.6;
        plateInd.opacity = 0.8;
        [plateInd setPhysicsBody:nil];
        [_livesIndicator addChild:plateInd];
    }
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair Target:(Target *)nodeA Plate:(Plate *)nodeB {
    [[_physicsNode space] addPostStepBlock:^{
        [nodeA removeFromParent];
        _levelNode.targetCount -= 1;
        if (_levelNode.targetCount == 0) {
            [self levelSuccess];
        }
    }                                  key:nodeA];
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair Bomb:(Bomb *)nodeA Plate:(Plate *)nodeB {
    [[_physicsNode space] addPostStepBlock:^{

        NSMutableArray * movableObject = [[NSMutableArray alloc] initWithArray:[[_levelNode presetPlate] copy]];
        for (CCNode* node in [_physicsNode children]) {
            if ([[[node physicsBody] collisionType] isEqual:@"Plate"]) {
                [movableObject addObject:node];
            }
        }

        for (CCNode* node in movableObject) {
                float factor = 20000.0f;
                float distance = [GameScene getDistance:[nodeA positionInPoints] to:[node positionInPoints]];
                factor /= (distance / 10);
                CGPoint forceDirection = [GameScene getDirection:[nodeA positionInPoints] to:[node positionInPoints]];
                CGPoint launchForceVec = ccpMult(forceDirection, factor);
                [node.physicsBody applyForce:launchForceVec];
        }

        /*
        float factor = 20000.0f;
        CGPoint forceDirection = [GameScene getDirection:bombPosition to:bodyPosition];
        CGPoint launchForceVec = ccpMult(forceDirection, factor);
        [nodeB.physicsBody applyForce:launchForceVec];
        */
        CCParticleSystem *explosion = (CCParticleSystem *) [CCBReader load:@"Sprites/bombExplosion"];
        explosion.autoRemoveOnFinish = TRUE;
        [explosion setPositionType:[nodeA positionType]];
        explosion.position = nodeA.position;
        [nodeA.parent addChild:explosion];
        [nodeA removeFromParent];
    }                                  key:nodeA];
}

+ (float)getDistance:(CGPoint)pA to:(CGPoint)pB {
    return sqrt(pow((pA.x - pB.x), 2) + pow((pA.y - pB.y), 2));
}

// -----------------------------------------------------------------------------
// UI touch to launch
// -----------------------------------------------------------------------------
- (void)touchBegan:(CCTouch *)touch withEvent:(UIEvent *)event {
    prevTime = timeCurrent;
    touchStartLocation = [touch locationInNode:_contentNode];

    if (toolToRotate != nil) {
        [toolToRotate secondTouchBegin:touch];
    } else if (_plate.userInteractionEnabled && !launchStarted
            && CGRectContainsPoint([_plate boundingBox], touchStartLocation)) {
        launchStarted = true;
        touchStartLocation = [_plate positionInPoints];
        [[_plate physicsBody] setVelocity:CGPointMake(0, 0)];
        NSLog(@"Touch start position : %lf , %lf", touchStartLocation.x, touchStartLocation.y);
    }
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    if (toolToPlace != nil) {
        [toolToPlace setPosition:touchLocation];
    } else if (toolToRotate != nil ) {
        [toolToRotate secondTouchMoved:touch];
    }
}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    touchEndLocation = [touch locationInNode:_contentNode];
    timeEnd = timeCurrent;

    if (toolToRotate != nil) {
        [toolToRotate secondTouchEnded:touch];
    } else if (_plate.userInteractionEnabled && launchStarted && timeEnd != prevTime) {
        NSLog(@"Touch end position : %lf , %lf", touchEndLocation.x, touchEndLocation.y);
        //Launch finish
        CGPoint forceDirection = [GameScene getDirection:touchStartLocation to:touchEndLocation];
        double velocity =
                [GameScene distanceBetween:touchStartLocation and:touchEndLocation] / (double) ((timeEnd - prevTime) / 10);

        NSLog(@"Launch target velocity %lf", velocity);

        CGPoint launchForceVec = ccpMult(forceDirection, [[_plate physicsBody] mass] * velocity);
        NSLog(@"Lauch with force : (%lf, %lf)", launchForceVec.x, launchForceVec.y);
        [_plate.physicsBody applyForce:launchForceVec];
        launchStarted = false;
        launchGoing = true;
        [_plate setUserInteractionEnabled:NO];
        [_toolBox setVisible:false];
    }
}

// -----------------------------------------------------------------------------
// Level and Utility class functions
// -----------------------------------------------------------------------------
+ (Tool *)loadToolByType:(enum ToolType)type {
    NSString *ccbName = [[Constants getTypeToCCBNameDict] objectForKey:[NSNumber numberWithInt:type]];

    if (ccbName == nil) {
        [NSException raise:@"Failed load tool" format:@"Failed to load tool by type %d", type];
    }
    Tool *tool = (Tool *) [CCBReader load:ccbName];
    tool.toolType = type;
    tool.inToolBox = false;
    tool.physicsBody.collisionMask = @[];
    return tool;
}

+ (CGPoint)getDirection:(CGPoint)p1 to:(CGPoint)p2 {
    double length = [self distanceBetween:p1 and:p2];
    double xdiff = p2.x - p1.x;
    double ydiff = p2.y - p1.y;

    if (length - 0 < [Constants epsilon]) {
        return CGPointMake(0, 0);
    }

    return CGPointMake(xdiff / length, ydiff / length);
}

+ (double)distanceBetween:(CGPoint)p1 and:(CGPoint)p2 {
    double xdiff = p2.x - p1.x;
    double ydiff = p2.y - p1.y;
    double length = sqrt(pow(xdiff, 2) + pow(ydiff, 2));

    return length;
}

- (Boolean)checkOverlap:(CCNode *)target {
    NSMutableArray *objectsToCheck = [[NSMutableArray alloc] initWithArray:_levelNode.presetObjs];
    [objectsToCheck addObject:_plate];

    for (CCNode *obj in objectsToCheck) {
        if (CGRectIntersectsRect([obj boundingBox], [target boundingBox])) {
            return false;
        }
    }

    return true;
}

@end
