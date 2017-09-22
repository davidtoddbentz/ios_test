#import "Bubble.h"


@implementation Bubble

- (instancetype)initWithIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        self.index = index;
    }
    return self;
}

- (instancetype)initWithIndex:(NSInteger)index title:(NSString*)title
{
    self = [super init];
    if (self) {
        self.index = index;
        self.title = title;
        
    }
    return self;
}

- (NSString *)bubbleText
{
    return self.title;
}

@synthesize bubbleState = _bubbleState;

@end
