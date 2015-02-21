//
//  Constants.h
//  LaunchPuzzle
//
//  Created by Yizhe Chen on 2/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

//Tool types
enum ToolType {
  Stick,Triangle,Spring
};
+(NSDictionary*)getTypeToCCBNameDict;

@end
