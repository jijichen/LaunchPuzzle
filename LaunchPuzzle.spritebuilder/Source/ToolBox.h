//
//  ToolBox.h
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Tool.h"

@interface ToolBox : CCNode

- (Tool*) checkTouch:(CCTouch*) touch;

@property NSMutableArray* toolsToLoad;
@property NSMutableArray* toolsCount;

@end
