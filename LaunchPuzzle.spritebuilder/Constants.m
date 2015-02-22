//
//  Constants.m
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Constants.h"

@implementation Constants

+(NSDictionary*)getTypeToCCBNameDict {
    static NSDictionary *dict = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        dict = @{
                 [NSNumber numberWithInt:Stick]: @"Sprites/tool_stick",
                 [NSNumber numberWithInt:Triangle]: @"Sprites/tool_triangle",
                 [NSNumber numberWithInt:Spring]: @"Sprites/tool_spring"
        };
    });
    
    return dict;
}
@end
