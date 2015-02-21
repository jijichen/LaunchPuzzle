//
//  Tool.h
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"
typedef NS_ENUM(NSInteger, ToolType) {
    Stick,
    Triangle,
    Spring
};

@interface Tool : CCSprite

@property ToolType toolType;

@end
