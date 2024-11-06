#import <Foundation/Foundation.h>

@interface TradeObjectModel : NSObject


@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSNumber *askPrice;
@property (nonatomic, strong, nullable) NSNumber *lastPrice;
@property (nonatomic, strong, nullable) NSNumber *bidPrice;
@property (nonatomic, strong, nullable) NSNumber *highPrice;
@property (nonatomic, strong, nullable) NSString *symbol;


- (instancetype _Nonnull ) initWithDictionary: (NSDictionary *_Nonnull)dictionary;
- (instancetype _Nonnull ) initWithDefaultValues: (NSString *_Nonnull)topic;
@end
