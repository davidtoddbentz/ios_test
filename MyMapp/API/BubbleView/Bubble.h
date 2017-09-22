#import <Foundation/Foundation.h>
#import "BLBubbleFilters.h"


@interface Bubble : NSObject <BLBubbleModel>

- (instancetype)initWithIndex:(NSInteger)index;
- (instancetype)initWithIndex:(NSInteger)index title:(NSString*)title;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic) NSString *title;

@end
