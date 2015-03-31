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
#import "Bomb.h"
#import "Target.h"
#import "Plate.h"


const float initialForce = 5.0f;
const double epsilon = 0.0000001f;



@interface GameScene ()

- (void) afterOneTrial;
- (void) levelSuccess;

@end

@implementation GameScene {
    //Code connection with spriteBuilder CCB file for game scene
    CCNode *_plate;
    CCNode *_contentNode;
        CCPhysicsNode *_physicsNode;
        Level *_levelNode;
        ToolBox *_toolBox;
        CCNode *_livesIndicator;
        NSArray* _presetBombs;
    CCNode *popUp;

    //State data for internal use
    CGPoint originalPlatePosition;
    CGPoint prevTouchLocation;
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

    //[self loadLevel:currentLevel withPath:currentLevelStr];
    /*
    //Load level to game scene
    [self loadLevel:@"Levels/level1"];
    currentLevel = 1;

    //Enable plate interaction
    _plate.userInteractionEnabled = true;
    */
}

- (void)loadLevel:(int)level {
    currentLevel = level;
    NSString *levelPath = [NSString stringWithFormat:@"Levels/level%d", currentLevel];
    Level *levelToLoad = (Level *) [CCBReader load:levelPath];
    [_toolBox loadWithLevel:levelToLoad l1:_toolCount1 l2:_toolCount2 l3:_toolCount3];
    [_physicsNode addChild:levelToLoad];
    _levelNode = levelToLoad;
    _presetBombs = levelToLoad.presetBombs;
    //Setup live count
    [self updateLiveIndicator:levelToLoad.liveCount];
    self.paused = NO;

    _plate.userInteractionEnabled = true;
}

-(void)loadNextLevel {
    CCScene *scene = [CCBReader loadAsScene:@"GameScene"];
    GameScene *nextScene = (GameScene *)[scene.children objectAtIndex:0];
    [nextScene loadLevel:currentLevel+1];

    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
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
    } key:nodeA];
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair Bomb:(Bomb *)nodeA Plate:(Plate *)nodeB {
    [[_physicsNode space] addPostStepBlock:^{
        CGPoint bombPosition = nodeA.position;
        CGPoint bodyPosition = nodeB.position;

        float factor = 20000.0f;
        CGPoint forceDirection = [GameScene getDirection:bombPosition to:bodyPosition];
        CGPoint launchForceVec = ccpMult(forceDirection, factor);
        [nodeB.physicsBody applyForce:launchForceVec];

        CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"Sprites/bombExplosion"];
        explosion.autoRemoveOnFinish = TRUE;
        explosion.position = nodeA.position;
        [nodeA.parent addChild:explosion];
        [nodeA removeFromParent];
    } key:nodeA];
}

// -----------------------------------------------------------------------------
// UI touch to launch or place tool
// -----------------------------------------------------------------------------
- (void)touchBegan:(CCTouch *)touch withEvent:(UIEvent *)event {
    prevTouchLocation = [touch locationInNode:_contentNode];
    prevTime = timeCurrent;

    if (_plate.userInteractionEnabled && !launchStarted
            && CGRectContainsPoint([_plate boundingBox], prevTouchLocation)) {
        launchStarted = true;
        [_plate.physicsBody setVelocity:CGPointMake(0, 0)];
        //_plate.position = touchStartLocation;
    } else if (!launchStarted) {
        Tool *toolTouched = [_toolBox checkTouch:touch];
        if (toolTouched != nil) {
            toolToPlace = [GameScene loadToolByType:toolTouched.toolType];
            [_physicsNode addChild:toolToPlace];
            toolToPlace.gameScene = self;
            toolToPlace.inToolBox = false;
            toolToPlace.toolBox = _toolBox;
            toolToPlace.position = [touch locationInNode:_contentNode];
        }
    }
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchLocation = [touch locationInNode:_contentNode];

    if (_plate.userInteractionEnabled && launchStarted) {
        prevTouchLocation = touchLocation;
        prevTime = timeCurrent;
    } else if (toolToPlace != nil) {
        toolToPlace.position = touchLocation;
        //NSLog(@"Position : %lf, %lf",toolToPlace.position.x, toolToPlace.position.y);
    }
}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    touchEndLocation = [touch locationInNode:_contentNode];
    timeEnd = timeCurrent;

    if (_plate.userInteractionEnabled && launchStarted && timeEnd != prevTime) {
        //Launch finish
        CGPoint forceDirection = [GameScene getDirection:prevTouchLocation to:touchEndLocation];
        double velocity =
                [GameScene distanceBetween:prevTouchLocation and:touchEndLocation] / (double) (timeEnd - prevTime);


        CGPoint launchForceVec = ccpMult(forceDirection, initialForce * velocity);
        NSLog(@"Lauch with force : (%lf, %lf)", launchForceVec.x, launchForceVec.y);
        [_plate.physicsBody applyForce:launchForceVec];
        launchStarted = false;
        launchGoing = true;
        [_plate setUserInteractionEnabled:NO];
        [_toolBox setVisible:false];
    } else if (toolToPlace != nil) {
        if ([self checkOverlap:toolToPlace]) {
            toolToPlace.physicsBody.collisionMask = nil;
        } else {
            [toolToPlace.toolBox restoreToolToBox:toolToPlace];
            [toolToPlace removeFromParent];
        }

        toolToPlace = nil;
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

+ (CCSprite *)loadToolSpriteByType:(enum ToolType)type {
    NSString *imageName = [[Constants getTypeToImgNameDict] objectForKey:[NSNumber numberWithInt:type]];
    return [CCSprite spriteWithImageNamed:imageName];
}

+ (CGPoint)getDirection:(CGPoint)p1 to:(CGPoint)p2 {
    double length = [self distanceBetween:p1 and:p2];
    double xdiff = p2.x - p1.x;
    double ydiff = p2.y - p1.y;

    if (length - 0 < epsilon) {
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

    for (CCNode * obj in objectsToCheck) {
        if (CGRectIntersectsRect([obj boundingBox], [target boundingBox])) {
            return false;
        }
    }

    return true;
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
@end
