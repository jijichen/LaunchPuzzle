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
@property (atomic, readonly) int liveCount;
@property (atomic, readonly) int countToolPlate;
@property NSArray* presetObjs;
@property NSArray* presetBombs;
@property (atomic) int targetCount;

- (NSArray *)getBombs;
@end
