//
//  ToolBox.h
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Tool.h"

@class Level;

@interface ToolBox : CCNode

- (Tool*) checkTouch:(CCTouch*) touch;

- (void)loadWithLevel:(Level *)level l1:(CCLabelTTF *)l1 l2:(CCLabelTTF *)l2 l3:(CCLabelTTF *)l3;

- (void)restoreToolToBox:(Tool*)releasedTool;

@property NSMutableArray* toolsToLoad;
@property NSMutableArray* toolsCount;

@end
