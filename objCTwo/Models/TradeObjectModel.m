#import "TradeObjectModel.h"

@implementation TradeObjectModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    _name = dictionary[@"name"];
    _askPrice = dictionary[@"ask-price"];
    _lastPrice = dictionary[@"last-price"];
    _bidPrice = dictionary[@"bid-price"];
    _highPrice = dictionary[@"high-price"];
    return self;
}

- (instancetype)initWithDefaultValues:(NSString *)topic{
    self = [super init];
    _name = @"-";
    _askPrice = @0.0;
    _lastPrice = @0.0;
    _bidPrice = @0.0;
    _highPrice = @0.0;
    _symbol = topic;
    return self;
}

@end
