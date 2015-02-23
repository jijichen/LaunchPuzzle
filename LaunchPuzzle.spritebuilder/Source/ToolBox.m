//
//  ToolBox.m
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "ToolBox.h"

@implementation ToolBox

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
    for (Tool* tool in self.toolsToLoad) {
        if (CGRectContainsPoint([tool boundingBox], touchLocation)) {
            //NSLog(@"Touch of tool");
            return tool;
        }
    }
    return nil;
}

@end
