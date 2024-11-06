#import <Foundation/Foundation.h>

@interface TradeObjectService : NSObject

@property (nonatomic, strong, readonly) NSArray *tradeObjs;

+ (instancetype)sharedInstance;
- (void)fetchTradeObjectsWithCompletion:(void (^)(NSArray *tradeObjects))completionHandler;
- (void)loadDefaultTradeObjectsWithCompletion:(void (^)(NSArray *tradeObjects))completionHandler;

@end
