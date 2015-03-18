#import "MainScene.h"
#import "GameScene.h"

@implementation MainScene

-(void)play {
    CCScene *gameScene = [CCBReader loadAsScene:@"GameScene"];
    [[CCDirector sharedDirector] replaceScene:gameScene];
}

@end
