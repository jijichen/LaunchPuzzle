//
//  ToolBox.m
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <SSZipArchive/unzip.h>
#import "ToolBox.h"


@implementation ToolBox {
    NSMutableArray *toolCountArr;
    Tool *toolToPlace;
    GameScene *gameScene;
    NSMutableArray* _toolsOnScene;
    Tool*_toolSelected;
    NSString *oriToolToPlaceCollisionType;
};


- (Tool *)checkTouch:(CCTouch *)touch {
    CGPoint touchLocation = [touch locationInNode:self];
    for (int i = 0; i < [_toolsToLoad count]; ++i) {
        Tool *tool = [_toolsToLoad objectAtIndex:i];
        if (CGRectContainsPoint([tool boundingBox], touchLocation)) {
            //If the touch location is within a tool
            int oldCount = [[_toolsCount objectAtIndex:i] intValue];
            if (oldCount == 0) {
                //Check tool count
                return nil;
            }

            //Reduce the tool count, get the tool return it.
            int newCount = oldCount - 1;
            _toolsCount[i] = [NSNumber numberWithInt:newCount];
            [self refreshLabels:i to:[_toolsCount[i] intValue]];
            return tool;
        }
    }
    return nil;
}

- (void)loadWithLevel:(Level *)level l1:(CCLabelTTF *)l1 l2:(CCLabelTTF *)l2 l3:(CCLabelTTF *)l3
    withScene:(GameScene *)scene {
    //Initialize Tool box
    self.toolsToLoad = [[NSMutableArray alloc] init];
    self.toolsCount = [[NSMutableArray alloc] init];
    _toolsOnScene = [[NSMutableArray alloc] init];
    //Load three kinds of tools
    toolCountArr = [[NSMutableArray alloc] initWithObjects:l1, l2, l3, nil];
    for (CCLabelTTF *labels in toolCountArr) {
        [labels.physicsNode setPhysicsBody:nil];
    }

    if ([level countToolStick] > 0) {
        Tool *stick = [GameScene loadToolByType:Stick];
        [self addToToolsToLoad:stick];
        [self.toolsCount addObject:[NSNumber numberWithInt:[level countToolStick]]];
    }

    if ([level countToolTri] > 0) {
        Tool *tri = [GameScene loadToolByType:Triangle];
        [self addToToolsToLoad:tri];
        [self.toolsCount addObject:[NSNumber numberWithInt:[level countToolTri]]];
    }

    if ([level countToolPlate] > 0) {
        Tool *plate = [GameScene loadToolByType:PlateTool];
        [self addToToolsToLoad:plate];
        [self.toolsCount addObject:[NSNumber numberWithInt:[level countToolPlate]]];
    }

    for (int i = 0; i < [self.toolsToLoad count]; i++) {
        Tool *toolToAdd = [self.toolsToLoad objectAtIndex:i];
        toolToAdd.positionType = CCPositionTypeMake(CCPositionUnitNormalized, CCPositionUnitNormalized,
                CCPositionReferenceCornerBottomRight);
        toolToAdd.position = CGPointMake(0.05 + 0.3 * (i + 1), 0.5);
        toolToAdd.anchorPoint = CGPointMake(0.0, 0.5);
        toolToAdd.scale = 0.8f;
        [self addChild:toolToAdd];

        CCLabelTTF *labelForTool = [toolCountArr objectAtIndex:i];

        [labelForTool setString:[NSString stringWithFormat:@"X %d",
                                                           [(NSNumber *) [self.toolsCount objectAtIndex:i] intValue]]];
        labelForTool.visible = true;
    }

    gameScene = scene;
}

- (void)addToToolsToLoad:(Tool *)tool {
    tool.inToolBox = true;
    tool.userInteractionEnabled = NO;
    [tool.physicsNode setPhysicsBody:nil];
    [self.toolsToLoad addObject:tool];
}

- (void)restoreToolToBox:(Tool *)releasedTool {
    if (_toolSelected == releasedTool) {
        _toolSelected = nil;
    }
    //Check the tools to load array, find the correspondent tool and add the count.
    for (int i = 0; i < [_toolsToLoad count]; ++i) {
        if (releasedTool.toolType == ((Tool *) _toolsToLoad[i]).toolType) {
            _toolsCount[i] = [NSNumber numberWithInt:[_toolsCount[i] intValue] + 1];
            [self refreshLabels:i to:[_toolsCount[i] intValue]];
            return;
        }
    }
}

- (void)refreshLabels:(int)pos to:(int)newCount {
    CCLabelTTF *labelToChange = toolCountArr[pos];
    Tool *toolToChange = _toolsToLoad[pos];
    [labelToChange setString:[NSString stringWithFormat:@"X %d",
                                                        newCount]];
    if (newCount == 0) {
        [labelToChange setVisible:false];
        [toolToChange setVisible:false];
    } else {
        [labelToChange setVisible:true];
        [toolToChange setVisible:true];
    }
}

// -----------------------------------------------------------------------------
// UI touch to launch or place tool
// -----------------------------------------------------------------------------
- (void)touchBegan:(CCTouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"ToolBox touch begins");
    Tool *toolTouched = [self checkTouch:touch];

    if (toolTouched != nil) {
        toolToPlace = [GameScene loadToolByType:toolTouched.toolType];
        oriToolToPlaceCollisionType = [[toolToPlace physicsBody] collisionType];
        [[toolToPlace physicsBody] setCollisionMask:nil];
        [[toolToPlace physicsBody] setCollisionType:@"ToolToPlace"];
        [gameScene addObjToPhysicNode:toolToPlace];
        toolToPlace.gameScene = gameScene;
        toolToPlace.inToolBox = false;
        toolToPlace.toolBox = self;
        toolToPlace.position = [touch locationInNode:[self parent]];
    } else {
        [super touchBegan:touch withEvent:event];
    }
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchLocation = [touch locationInNode:[self parent]];

    if (toolToPlace != nil) {
        [toolToPlace setPosition:touchLocation];
    }
}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    NSLog(@"Toolbox touch ends!");
    if (toolToPlace != nil) {
        if (toolToPlace.placeColliding) {
            [self restoreToolToBox:toolToPlace];
            [toolToPlace removeFromParent];
        } else {
            [[toolToPlace physicsBody] setCollisionMask:nil];
            [[toolToPlace physicsBody] setCollisionType:oriToolToPlaceCollisionType];
            [_toolsOnScene addObject:toolToPlace];
        }
        toolToPlace = nil;
    }
}

- (void)toolSelected:(Tool *) tool {
    if (tool == _toolSelected) {
        self.toolSelected = nil;
        [tool removeAllChildren];
    } else {
        if (_toolSelected != nil) {
            [_toolSelected removeAllChildren];
        }
        _toolSelected = tool;
        [ToolBox addGlowEffect:tool color:[CCColor darkGrayColor]];
    }
}

+ (void)addGlowEffect:(Tool *)tool color:(CCColor *)colour {

    CGPoint pos = ccp(tool.contentSize.width / 2, tool.contentSize.height / 2);

    CCSprite* glowSprite = [CCSprite spriteWithImageNamed:@"ccbResources/ccbParticleFire.png"];

    [glowSprite setColor:colour];
    [glowSprite setPosition:pos];

    [glowSprite setScaleX:(tool.contentSize.width/glowSprite.contentSize.width * 2.5)];
    [glowSprite setScaleY:(tool.contentSize.height/glowSprite.contentSize.height * 2.5)];



    [tool addChild:glowSprite z:tool.zOrder - 1 name:@"shield"];

    // Run some animation which scales a bit the glow
//    CCActionSequence * s1 = [CCActionSequence actionOne:[CCActionScaleTo actionWithDuration:0.9f scale:1.0f]
//                                                    two:[CCActionScaleTo actionWithDuration:0.9f scale:0.75f]];
//    CCActionRepeatForever *r = [CCActionRepeatForever actionWithAction:s1];
//    [glowSprite runAction:r];

}


@end
