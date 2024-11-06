#import <Foundation/Foundation.h>
#import "TradeObjectService.h"
#import "TradeObjectModel.h"

@implementation TradeObjectService

+ (instancetype)sharedInstance {
    static TradeObjectService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)fetchTradeObjectsWithCompletion:(void (^)(NSArray *tradeObjects))completionHandler {
    NSURL *url = [NSURL URLWithString:@"removed_for_company_security_reasons"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error fetching trade objects: %@", error.localizedDescription);
            completionHandler(nil);
            return;
        }
        
        NSError *jsonError;
        NSArray *parsedJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        if (jsonError) {
            NSLog(@"JSON parsing error: %@", jsonError.localizedDescription);
            completionHandler(nil);
            return;
        }
        
        NSMutableArray *tradeObjects = [NSMutableArray array];
        for (NSDictionary *dictionary in parsedJson) {
            TradeObjectModel *tradeObject = [[TradeObjectModel alloc] initWithDictionary:dictionary];
            [tradeObjects addObject:tradeObject];
        }
        
        completionHandler([tradeObjects copy]);
    }];
    [task resume];
}

- (void)loadDefaultTradeObjectsWithCompletion:(void (^)(NSArray *tradeObjects))completionHandler {
    NSArray *symbols = @[@"2010.TAD", @"4180.TAD", @"4061.TAD", @"2140.TAD", @"4130.TAD", @"6070.TAD", @"1120.TAD", @"2170.TAD", @"1080.TAD", @"3010.TAD", @"2210.TAD"];
    NSMutableArray *tradeObjects = [NSMutableArray array];
    
    for (NSString *symbol in symbols) {
        TradeObjectModel *tradeObject = [[TradeObjectModel alloc] initWithDefaultValues:symbol];
        [tradeObjects addObject:tradeObject];
    }
    _tradeObjs = [tradeObjects copy];
    completionHandler(_tradeObjs);
}

@end
