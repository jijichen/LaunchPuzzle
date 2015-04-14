//
//  Constants.h
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
enum ToolType {
    Stick,Triangle, PlateTool
};

static NSString *plateCCBName = @"Sprites/plate";

@interface Constants : NSObject

+(int)totalLevelCount;

+(NSDictionary*)getTypeToCCBNameDict;

+(NSDictionary*)getTypeToImgNameDict;

+(NSString*)getPlateCCBName;


+ (int)startLevel;
@end
