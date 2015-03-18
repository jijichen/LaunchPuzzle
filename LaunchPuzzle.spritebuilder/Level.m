//
//  Level.m
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Level.h"

@implementation Level

- (void)didLoadFromCCB {
    self.presetObjs = self->_children;

    int c = 0;
    for (CCNode *preObj in self.presetObjs) {
        if (preObj.name == @"Target"){
            c += 1;
        }
    }
    self.targetCount = c;
}

@end
