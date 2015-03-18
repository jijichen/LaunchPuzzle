//
//  Level.m
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Level.h"

@implementation Level

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    self.presetObjs = self->_children;
}

@end
