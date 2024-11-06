#import <Foundation/Foundation.h>

@interface WebSocketService : NSObject <NSURLSessionWebSocketDelegate>

+ (instancetype _Nullable)sharedInstance;
- (void)connectToWebSocket;
- (void)sendUUIDWithCompletion:(void (^_Nullable)(void))completionHandler;
- (void)startMessageListener;
- (void)subscribeToTopics;
- (void)manageSubscriptionForSymbol:(NSString *_Nonnull)symbol;
- (void)sendMessage:(NSString *_Nonnull)messageString;
- (void)handleReceivedStringMessage:(NSString *_Nonnull)text;
- (void)handleParsedMessage:(NSDictionary *_Nonnull)response;
- (void)startPingTimer;
- (void)stopPingTimer;
- (void)ping;

@end
