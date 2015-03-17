#import "MainScene.h"
#import "GameScene.h"

@implementation MainScene

-(void)play {
    GameScene *gameScene = [CCBReader loadAsScene:@"GameScene"];
    [[CCDirector sharedDirector] replaceScene:gameScene];
}

@end
