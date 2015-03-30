//
//  Level.h
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCScene.h"

@interface Level : CCScene

@property (atomic, readonly) int countToolStick;
@property (atomic, readonly) int countToolTri;
@property (atomic, readonly) int countToolPlate;

@property (atomic) int liveCount;
@property (atomic) int targetCount;

@property NSArray* presetObjs;
@property NSArray* presetBombs;
- (NSArray *)getBombs;
@end
