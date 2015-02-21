//
//  Target.m
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Target.h"

@implementation Target

- (void) didLoadFromCCB {
    self.physicsBody.collisionType = @"Target";
}
@end
