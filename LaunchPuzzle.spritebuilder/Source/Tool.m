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

@implementation Tool{
    CGPoint prevLocation;
}

-(id)init
{
    self = [super init];
    if (self) {
        self.inToolBox = true;
        self.userInteractionEnabled = YES;
        self.isTouchEnabled = YES;

        //Set gesture recognizer : rotation and double tap
        UIRotationGestureRecognizer* rotRec = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationGestureRecognizer:)];
        UITapGestureRecognizer* tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapRec.numberOfTapsRequired = 2;
        [rotRec setDelegate:self];
        [tapRec setDelegate:self];
        [self addGestureRecognizer:rotRec];
        [self addGestureRecognizer:tapRec];
    }
    return self;
}

-(id)initWithToolBox:(ToolBox*)parentToolBox
{
    self = [self init];
    if (self) {
        self.toolBox = parentToolBox;
    }

    return self;
}

- (void)handleRotationGestureRecognizer:(UIRotationGestureRecognizer*)aRotationGestureRecognizer
{
    if (aRotationGestureRecognizer.state == UIGestureRecognizerStateBegan || aRotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CCNode *node = aRotationGestureRecognizer.node;
        float rotation = aRotationGestureRecognizer.rotation;
        node.rotation += CC_RADIANS_TO_DEGREES(rotation);
        aRotationGestureRecognizer.rotation = 0;
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded && !self.inToolBox)
    {
        [_toolBox restoreToolToBox:self];
        [self removeFromParent];
    }
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self.parent];
    prevLocation = touchLoc;
    self.physicsBody.collisionMask = @[];
}

-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self.parent];
    self.position = touchLoc;
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    if ([self.gameScene checkOverlap:self]) {
        //No overlap with predefined objects in the level
        self.physicsBody.collisionMask = nil;
    } else {
        [[self toolBox] restoreToolToBox:self];
        [self removeFromParent];
    }
}

@end
