//
//  ToolBox.m
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "ToolBox.h"
#import "Level.h"
#import "GameScene.h"

@implementation ToolBox{
    NSMutableArray* toolCountArr;
};

// -----------------------------------------------------------------------------
// UI touch to launch
// -----------------------------------------------------------------------------
-(void) touchBegan:(CCTouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"Touch begin");
}

-(void) touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    NSLog(@"Touch Moving");

}

-(void) touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    NSLog(@"Touch end");
}

- (Tool*) checkTouch:(CCTouch*) touch {

    CGPoint touchLocation = [touch locationInNode:self];
    for (int i = 0; i < [_toolsToLoad count]; ++i) {
        Tool* tool = [_toolsToLoad objectAtIndex:i];
        if (CGRectContainsPoint([tool boundingBox], touchLocation)) {
            int oldCount = [[_toolsCount objectAtIndex:i] intValue];
            if (oldCount == 0) {
                return nil;
            }

            int newCount = oldCount - 1;
            _toolsCount[i] = [NSNumber numberWithInt:newCount];
            CCLabelTTF * labelToChange = [toolCountArr objectAtIndex:i];
            [labelToChange setString:[NSString stringWithFormat:@"X %d",
                                                                newCount]];
            if ([[_toolsCount objectAtIndex:i] integerValue] == 0) {
                [labelToChange setVisible:false];
                [tool setVisible:false];
            }
            return tool;
        }
    }
    return nil;
}

- (void)loadWithLevel:(Level *)level andLabels:(CCLabelTTF *)labels :(CCLabelTTF *)param :(CCLabelTTF *)param1 :(void *)param2 {

}

- (void)loadWithLevel:(Level *)level l1:(CCLabelTTF *)l1 l2:(CCLabelTTF *)l2 l3:(CCLabelTTF *)l3{
    //Initialize Tool box
    self.toolsToLoad = [[NSMutableArray alloc] init];
    self.toolsCount = [[NSMutableArray alloc] init];

    //Load three kinds of tools
    toolCountArr = [[NSArray alloc] initWithObjects:l1,l2,l3,nil];
    if (level.countToolStick > 0) {
        Tool *stick = [GameScene loadToolByType:Stick];
        stick.userInteractionEnabled = NO;
        [self.toolsToLoad addObject:stick];
        [self.toolsCount addObject:[NSNumber numberWithInt:level.countToolStick]];
    }

    if (level.countToolTri > 0) {
        Tool *tri = [GameScene loadToolByType:Triangle];
        tri.userInteractionEnabled = NO;
        [self.toolsToLoad addObject:tri];
        [self.toolsCount addObject:[NSNumber numberWithInt:level.countToolTri]];
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
@end
