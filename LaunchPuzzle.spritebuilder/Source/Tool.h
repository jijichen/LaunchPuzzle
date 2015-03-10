//
//  Tool.h
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "Constants.h"

@class ToolBox;

@interface Tool : CCSprite


-(void) disableInteraction;

@property enum ToolType toolType;
@property BOOL inToolBox;
@property (weak) ToolBox* toolBox;

@end
