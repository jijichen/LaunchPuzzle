//
//  Constants.m
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Constants.h"

@implementation Constants

+ (int)startLevel {
    return 1;
}

+ (double)epsilon {
    return 0.0000001f;
}

+ (int)totalLevelCount {
    return 8;
}

+ (NSDictionary *)getTypeToCCBNameDict {
    static NSDictionary *dict = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        dict = @{
                [NSNumber numberWithInt:Stick] : @"Sprites/tool_stick",
                [NSNumber numberWithInt:Triangle] : @"Sprites/tool_tri",
                [NSNumber numberWithInt:PlateTool] : @"Sprites/tool_plate"
        };
    });

    return dict;
}

+ (NSDictionary *)getTypeToImgNameDict {
    static NSDictionary *dict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dict = @{
                [NSNumber numberWithInt:Stick] : @"Resources/stick_wood_short.png",
                [NSNumber numberWithInt:Triangle] : @"Sprites/tool_tri",
                [NSNumber numberWithInt:PlateTool] : @"Sprites/tool_plate"
        };
    });

    return dict;
}

+ (NSString *)getPlateCCBName {
    return plateCCBName;
}

+(void) preLoadEffects {
    [[OALSimpleAudio sharedInstance] preloadEffect:@"Musics/BombSmall.mp3"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"Musics/Sweep.caf"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"Musics/hit.caf"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"Musics/ding.caf"];
}


@end
