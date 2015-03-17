//
//  Target.m
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Target.h"

@implementation Target
//TODO find child by name
- (void) didLoadFromCCB {
    self.physicsBody.collisionType = @"Target";
    self.name = @"Target";
}
@end
