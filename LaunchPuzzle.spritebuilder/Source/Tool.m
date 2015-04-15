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
    CGPoint sFingerPosition;
}

- (id)init {
    self = [super init];
    if (self) {
        self.inToolBox = true;
        self.userInteractionEnabled = YES;
        self.isTouchEnabled = YES;

        //Set gesture recognizer : rotation and double tap
        UIRotationGestureRecognizer *rotRec = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationGestureRecognizer:)];
        UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapRec.numberOfTapsRequired = 2;
        [rotRec setDelegate:self];
        [tapRec setDelegate:self];
        [self addGestureRecognizer:rotRec];
        [self addGestureRecognizer:tapRec];
    }
    return self;
}

- (void)handleRotationGestureRecognizer:(UIRotationGestureRecognizer *)aRotationGestureRecognizer {
    if (aRotationGestureRecognizer.state == UIGestureRecognizerStateBegan || aRotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CCNode *node = aRotationGestureRecognizer.node;
        float rotation = aRotationGestureRecognizer.rotation;
        node.rotation += CC_RADIANS_TO_DEGREES(rotation);
        aRotationGestureRecognizer.rotation = 0;

        [self touchEnded:nil withEvent:nil];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded && !self.inToolBox) {
        [_toolBox restoreToolToBox:self];
        [self removeFromParent];
    }
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"Tool touch begins");
    self.physicsBody.collisionMask = @[];
    [[self gameScene] oneTouchOnTool:true atTool:self];
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    self.position = [touch locationInNode:self.parent];
}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    NSLog(@"Tool touch ends");
    if ([self.gameScene checkOverlap:self]) {
        //No overlap with predefined objects in the level
        self.physicsBody.collisionMask = nil;
    } else {
        [[self toolBox] restoreToolToBox:self];
        [self removeFromParent];
    }
    [[self gameScene] oneTouchOnTool:false atTool:self];
}

- (void)secondTouchBegin:(CCTouch *)touch {
    NSLog(@"Second touch on tool begins");
    sFingerPosition = [touch locationInNode:self.parent];
}

- (void)secondTouchMoved:(CCTouch *)touch {
    sFingerPosition = [touch locationInNode:self.parent];
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


@end
