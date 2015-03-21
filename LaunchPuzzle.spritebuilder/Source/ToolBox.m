//
//  ToolBox.m
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <SSZipArchive/unzip.h>
#import "ToolBox.h"
#import "Level.h"
#import "GameScene.h"

@implementation ToolBox{
    NSMutableArray* toolCountArr;
};

- (Tool*) checkTouch:(CCTouch*) touch {
    CGPoint touchLocation = [touch locationInNode:self];
    for (int i = 0; i < [_toolsToLoad count]; ++i) {
        Tool* tool = [_toolsToLoad objectAtIndex:i];
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

- (void)loadWithLevel:(Level *)level l1:(CCLabelTTF *)l1 l2:(CCLabelTTF *)l2 l3:(CCLabelTTF *)l3{
    //Initialize Tool box
    self.toolsToLoad = [[NSMutableArray alloc] init];
    self.toolsCount = [[NSMutableArray alloc] init];

    //Load three kinds of tools
    toolCountArr = [[NSMutableArray alloc] initWithObjects:l1,l2,l3,nil];
    for (CCLabelTTF *labels in toolCountArr) {
        [labels.physicsNode setPhysicsBody:nil];
    }

    if (level.countToolStick > 0) {
        Tool *stick = [GameScene loadToolByType:Stick];
        [self addToToolsToLoad:stick];
        [self.toolsCount addObject:[NSNumber numberWithInt:level.countToolStick]];
    }

    if (level.countToolTri > 0) {
        Tool *tri = [GameScene loadToolByType:Triangle];
        [self addToToolsToLoad:tri];
        [self.toolsCount addObject:[NSNumber numberWithInt:level.countToolTri]];
    }

    if (level.countToolPlate > 0) {
        Tool *plate = [GameScene loadToolByType:Plate];
        [self addToToolsToLoad:plate];
        [self.toolsCount addObject:[NSNumber numberWithInt:level.countToolPlate]];
    }

    for (int i = 0; i < [self.toolsToLoad count]; i++) {
        Tool* toolToAdd = [self.toolsToLoad objectAtIndex:i];
        toolToAdd.positionType = CCPositionTypeMake(CCPositionUnitNormalized, CCPositionUnitNormalized,
                CCPositionReferenceCornerBottomRight);
        toolToAdd.position = CGPointMake(0.05 + 0.3 * (i + 1), 0.5);
        toolToAdd.anchorPoint = CGPointMake(0.0, 0.5);
        toolToAdd.scale = 0.7f;
        [self addChild:toolToAdd];

        CCLabelTTF* labelForTool = [toolCountArr objectAtIndex:i];

        [labelForTool setString:[NSString stringWithFormat:@"X %d",
                                                           [(NSNumber*)[self.toolsCount objectAtIndex:i] intValue]]];
        labelForTool.visible = true;
    }
}

- (void)addToToolsToLoad:(Tool *)tool {
    tool.inToolBox = true;
    tool.userInteractionEnabled = NO;
    [tool.physicsNode setPhysicsBody:nil];
    [self.toolsToLoad addObject:tool];
}

- (void)restoreToolToBox:(Tool*)releasedTool {
    //Check the tools to load array, find the correspondent tool and add the count.
    for (int i = 0; i < [_toolsToLoad count]; ++i) {
        if (releasedTool.toolType == ((Tool*)_toolsToLoad[i]).toolType) {
            _toolsCount[i] = [NSNumber numberWithInt:[_toolsCount[i] intValue] + 1];
            [self refreshLabels:i to:[_toolsCount[i] intValue]];
            return;
        }
    }
}

- (void)refreshLabels:(int)pos to:(int)newCount {
    CCLabelTTF * labelToChange = toolCountArr[pos];
    Tool* toolToChange = _toolsToLoad[pos];
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

@end
