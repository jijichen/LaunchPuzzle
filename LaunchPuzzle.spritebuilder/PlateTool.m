//
// Created by Yizhe Chen on 4/8/15.
// Copyright (c) 2015 Apportable. All rights reserved.
//

#import "PlateTool.h"


@implementation PlateTool {

}

- (void) didLoadFromCCB {
    self.physicsBody.collisionType = @"toolPlate";
    self.name = @"toolPlate";
}

@end