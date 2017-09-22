#import "BLBubbleNode.h"
#import "BLConsts.h"


double BLBubbleFiltersAnimationDuration = 0.2;
double BLBubbleFiltersIconPercentualInset = 0.4;


#pragma mark Private Interface
@interface BLBubbleNode()

//Setup
- (void)configure;

//UI
- (void)setBackgroundImage:(SKTexture * __nullable)backgroundImage;
- (void)setIconImage:(SKTexture * __nullable)iconImage;
@property (nonatomic, strong) SKCropNode *backgroundNode;
@property (nonatomic, strong) SKSpriteNode *icon;

//State and animations
- (BLBubbleNodeState)stateForKey:(NSString *)key;
- (NSString * __nullable)animationKeyForState:(BLBubbleNodeState)state;

@end


#pragma mark - Main Implementation
@implementation BLBubbleNode

#pragma Convenience initialiser
- (instancetype)initWithRadius:(CGFloat)radius
{
    self = [BLBubbleNode shapeNodeWithCircleOfRadius:radius];
    if (self) {
        _state = BLBubbleNodeStateNormal;
        
        [self configure];
    }
    
    return self;
}

#pragma mark Setup
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    _state = [aDecoder decodeIntegerForKey:@"state"];
    
    return [super initWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_state
                   forKey:@"state"];
    
    [super encodeWithCoder:aCoder];
}

- (void)configure
{
    self.name = @"bubble";
    
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:1.5 + CGPathGetBoundingBox(self.path).size.width / 2.0];
    self.physicsBody.dynamic = YES;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.mass = 0.3;
    self.physicsBody.friction = 0.0;
    self.physicsBody.linearDamping = 3;
    
    _backgroundNode = [[SKCropNode alloc] init];
    _backgroundNode.userInteractionEnabled = NO;
    _backgroundNode.position = CGPointZero;
    _backgroundNode.zPosition = 0;
    [self addChild:_backgroundNode];
    
    _label = [DSMultilineLabelNode labelNodeWithFontNamed:@""];
    _label.position = CGPointZero;
    _label.fontColor = [SKColor whiteColor];
    _label.fontSize = 20;
    _label.fontName = @"Cubano-Regular";
    _label.paragraphWidth = 90.0;
    _label.userInteractionEnabled = NO;
    _label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _label.zPosition = 2;
    [self addChild:_label];
}

#pragma mark Data Model
- (void)setModel:(id<BLBubbleModel>)model
{
    _model = model;
    _label.text = [model bubbleText];

    [self setState:[model bubbleState]];
}

#pragma mark State and animations
@synthesize state = _state;
@synthesize label = _label;

- (void)setState:(BLBubbleNodeState)state
{
    if (_state != state) {
        //Animate
        [self removeAllActions];
        [_icon removeAllActions];
        [_label removeAllActions];
        [self runAction:[self actionForKey:[self animationKeyForState:state]]];
        self.model.bubbleState = state;
    }
    
    _state = state;
}

- (SKAction *)actionForKey:(NSString *)key
{
    __weak typeof(self) weakSelf = self;
    return [SKAction group:@[[SKAction scaleTo:1.0 duration:BLBubbleFiltersAnimationDuration], [SKAction runBlock:^{
        [[weakSelf icon] runAction:[SKAction fadeOutWithDuration:BLBubbleFiltersAnimationDuration] completion:^{
            [[weakSelf icon] removeFromParent];
        }];
        [[weakSelf label] runAction:[SKAction group:@[[SKAction moveTo:CGPointZero duration:BLBubbleFiltersAnimationDuration], [SKAction scaleTo:1.0 duration:BLBubbleFiltersAnimationDuration]]]];
    }]]];
    
}

- (void)removeFromParent
{
    SKAction *action = [self actionForKey:[self animationKeyForState:BLBubbleNodeStateRemoved]];
    if (action) {
        [self runAction:action
             completion:^
         {
             [super removeFromParent];
         }];
        return;
    }
    [super removeFromParent];
}

- (BLBubbleNodeState)stateForKey:(NSString *)key
{
    for (int i=(int)BLBubbleNodeStateCountFirst; i<(int)BLBubbleNodeStateCountLast + 1; i++) {
        if ([[self animationKeyForState:(NSInteger)i] isEqualToString:key]) {
            return i;
        }
    }
    return BLBubbleNodeStateNormal;
}

- (NSString * __nullable)animationKeyForState:(BLBubbleNodeState)state
{
    switch (state) {
        case BLBubbleNodeStateRemoved:
            return @"BLBubbleNodeStateRemoved";
        case BLBubbleNodeStateNormal:
            return @"BLBubbleNodeStateNormal";
        case BLBubbleNodeStateHighlighted:
            return @"BLBubbleNodeStateHighlighted";
        default:
            return nil;
    }
}


#pragma mark Aux
- (BLBubbleNodeState)nextState
{
    switch (self.state) {
        case BLBubbleNodeStateNormal:
            return BLBubbleNodeStateHighlighted;
        case BLBubbleNodeStateHighlighted:
            return BLBubbleNodeStateNormal;
        default:
            return BLBubbleNodeStateNormal;
    }
}

@end
