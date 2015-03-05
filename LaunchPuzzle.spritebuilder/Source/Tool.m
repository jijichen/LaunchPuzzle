//
//  Tool.m
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Tool.h"
#import "UITouch+CC.h"

@implementation Tool

-(id)init
{
    self = [super init];
    if (self) {
        self.inToolBox = true;
        self.userInteractionEnabled = YES;
        self.isTouchEnabled = YES;
        UIRotationGestureRecognizer* rotRec = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationGestureRecognizer:)];
        UITapGestureRecognizer* tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleTap:)];
        tapRec.numberOfTapsRequired = 2;
        
        [rotRec setDelegate:self];
        [tapRec setDelegate:self];
        [self addGestureRecognizer:rotRec];
        [self addGestureRecognizer:tapRec];
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
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self removeFromParent];
    }
}




-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self.parent];

//    // Log touch location
//    CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));
//
//    // Move our sprite to touch location
//    CCActionMoveTo *actionMove = [CCActionMoveTo action];
//    [self runAction:actionMove];
}

-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self.parent];
    self.position = touchLoc;
}

@end
