//
//  Tool.m
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Tool.h"
#import "UITouch+CC.h"
#import "ToolBox.h"
#import "GameScene.h"

@implementation Tool {
    UIRotationGestureRecognizer *rotRec;
    UITapGestureRecognizer *doubleTapRec;
    NSString *oriCollisionType;
}

- (id)init {
    self = [super init];
    if (self) {
        self.inToolBox = true;
        self.userInteractionEnabled = YES;
        self.isTouchEnabled = YES;
        self.placeColliding = NO;

        //Set gesture recognizer : rotation and double tap
        rotRec = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationGestureRecognizer:)];
        doubleTapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTapRec.numberOfTapsRequired = 2;

        [rotRec setDelegate:self];
        [doubleTapRec setDelegate:self];
        [self addGestureRecognizer:rotRec];
        [self addGestureRecognizer:doubleTapRec];
    }
    return self;
}

// -----------------------------------------------------------------------------
// UI touch to select , place and rotate tool
// -----------------------------------------------------------------------------
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"Tool touch begins");
    oriCollisionType = [[self physicsBody] collisionType];
    [[self physicsBody] setCollisionMask:nil];
    [[self physicsBody] setCollisionType:@"ToolToPlace"];
    [[self toolBox] toolSelected:self];
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    self.position = [touch locationInNode:self.parent];
}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    NSLog(@"Tool touch ends");
    if (self.placeColliding) {
        [[self toolBox] restoreToolToBox:self];
        [self removeFromParent];
    } else {
        [[self physicsBody] setCollisionType:oriCollisionType];
        [[self physicsBody] setCollisionMask:nil];
    }
}

- (void)secondTouchBegin:(CCTouch *)touch {
    NSLog(@"Second touch on tool begins");
    CGPoint sFingerPosition = [touch locationInNode:self.parent];
    self.physicsBody.collisionMask = @[];
}

- (void)secondTouchMoved:(CCTouch *)touch {
    self.physicsBody.collisionMask = @[];
    CGPoint sFingerPosition = [touch locationInNode:self.parent];
    CGPoint selfLocation = [self positionInPoints];
    CGPoint fVec = {0, -1};
    CGPoint sVec = {sFingerPosition.x - selfLocation.x,
            sFingerPosition.y - selfLocation.y};

    double dot = fVec.x * sVec.x + fVec.y * sVec.y;
    double det = fVec.x * sVec.y - fVec.y * sVec.x;
    double angle = CC_RADIANS_TO_DEGREES(atan2(det, dot));
    NSLog(@"angle : %lf", angle);
    self.rotation = -angle;
}

- (void)secondTouchEnded:(CCTouch *)touch {
    NSLog(@"Second touch on tool ends");
}

// -----------------------------------------------------------------------------
// Gesture recognizer
// -----------------------------------------------------------------------------
- (void)handleRotationGestureRecognizer:(UIRotationGestureRecognizer *)aRotationGestureRecognizer {
    if (aRotationGestureRecognizer.state == UIGestureRecognizerStateBegan || aRotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CCNode *node = aRotationGestureRecognizer.node;
        float rotation = aRotationGestureRecognizer.rotation;
        node.rotation += CC_RADIANS_TO_DEGREES(rotation);
        aRotationGestureRecognizer.rotation = 0;

        [self touchEnded:nil withEvent:nil];
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded && !self.inToolBox) {
        [_toolBox restoreToolToBox:self];
        [self removeFromParent];
    }
}

- (void)setAllGestureEnabled:(Boolean) on {
    [rotRec setEnabled:on];
    [doubleTapRec setEnabled:on];
}

@end
