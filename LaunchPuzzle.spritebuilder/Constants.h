//
//  Constants.h
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
enum ToolType {
    Stick,Triangle,Spring
};

static NSString *plateCCBName = @"Sprites/plate";

@interface Constants : NSObject

+(NSDictionary*)getTypeToCCBNameDict;

+(NSDictionary*)getTypeToImgNameDict;

+(NSString*)getPlateCCBName;

@end
