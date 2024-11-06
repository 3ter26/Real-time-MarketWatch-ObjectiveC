#import <Foundation/Foundation.h>
#import "WebSocketService.h"
#import "MarketWatchViewController.h"
#import "TradeObjectService.h"

@interface WebSocketService ()
@property (nonatomic, strong) NSURLSessionWebSocketTask *webSocketTask;
@property (nonatomic, strong) NSTimer *pingTimer;
@end

@implementation WebSocketService

+ (instancetype)sharedInstance {
    static WebSocketService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)connectToWebSocket {
    NSURL *url = [NSURL URLWithString:@"removed_for_company_security_reasons"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    self.webSocketTask = [session webSocketTaskWithURL:url];
    [self.webSocketTask resume];
}

- (void)sendUUIDWithCompletion:(void (^)(void))completionHandler {
    NSString *uuidString = [NSString stringWithFormat:@"uid=%@", [NSUUID UUID].UUIDString];
    NSURLSessionWebSocketMessage *message = [[NSURLSessionWebSocketMessage alloc] initWithString:uuidString];
    
    [self.webSocketTask sendMessage:message completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error sending UUID: %@", error.localizedDescription);
        } else {
            NSLog(@"UUID sent successfully: %@", uuidString);
            if (completionHandler) completionHandler();
        }
    }];
}

- (void)subscribeToTopics {
    NSArray *trades = [TradeObjectService singleton].tradeObjs;
    for (TradeObjectModel *tradeObject in trades) {
        [self manageSubscriptionForSymbol:tradeObject.symbol];
    }
}

- (void)manageSubscriptionForSymbol:(NSString *)symbol {
    NSString *unsubscribeMessage = [NSString stringWithFormat:@"unsubscribe=QO.%@", symbol];
    NSString *subscribeMessage = [NSString stringWithFormat:@"subscribe=QO.%@", symbol];
    
    [self sendMessage:unsubscribeMessage];
    [self sendMessage:subscribeMessage];
}

- (void)sendMessage:(NSString *)messageString {
    NSURLSessionWebSocketMessage *message = [[NSURLSessionWebSocketMessage alloc] initWithString:messageString];
    [self.webSocketTask sendMessage:message completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error sending message: %@", error.localizedDescription);
        } else {
            NSLog(@"Message sent: %@", messageString);
        }
    }];
}

- (void)startMessageListener {
    __weak typeof(self) weakSelf = self;
    [self.webSocketTask receiveMessageWithCompletionHandler:^(NSURLSessionWebSocketMessage * _Nullable message, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error receiving message: %@", error.localizedDescription);
        } else {
            [weakSelf processReceivedMessage:message];
            [weakSelf startMessageListener];
        }
    }];
}

- (void)processReceivedMessage:(NSURLSessionWebSocketMessage *)message {
    if (message.type == NSURLSessionWebSocketMessageTypeString) {
        [self handleReceivedStringMessage:message.string];
    } else if (message.type == NSURLSessionWebSocketMessageTypeData) {
        NSLog(@"Received data message: %@", message.data);
    } else {
        NSLog(@"Unknown message type received");
    }
}

- (void)handleReceivedStringMessage:(NSString *)text {
    NSError *error = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[text dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    if (!error && [dictionary isKindOfClass:[NSDictionary class]]) {
        [self handleParsedMessage:dictionary];
    } else {
        NSLog(@"Error parsing message: %@", error.localizedDescription);
    }
}

- (void)handleParsedMessage:(NSDictionary *)response {
    NSString *responseSymbol = response[@"topic"];
    NSMutableDictionary *updatedData = [NSMutableDictionary dictionary];
    
    updatedData[@"askPrice"] = response[@"askprice"];
    updatedData[@"highPrice"] = response[@"high"];
    updatedData[@"lastPrice"] = response[@"lasttradeprice"];
    updatedData[@"bidPrice"] = response[@"bidprice"];
    
    NSLog(@"Response symbol: %@", responseSymbol);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TradeObjectUpdatedNotification"
                                                        object:nil
                                                      userInfo:@{ @"symbol": responseSymbol, @"updatedData": updatedData }];
}

- (void)startPingTimer {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.pingTimer invalidate];
        weakSelf.pingTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:weakSelf selector:@selector(ping) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:weakSelf.pingTimer forMode:NSRunLoopCommonModes];
    });
}

- (void)stopPingTimer {
    [self.pingTimer invalidate];
    self.pingTimer = nil;
}

- (void)ping {
    [self.webSocketTask sendPingWithPongReceiveHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Ping failed: %@", error.localizedDescription);
        } else {
            NSLog(@"Ping succeeded");
        }
    }];
}

#pragma mark - URLSessionWebSocketDelegate Methods

- (void)URLSession:(NSURLSession *)session webSocketTask:(NSURLSessionWebSocketTask *)webSocketTask didOpenWithProtocol:(NSString *)protocol {
    NSLog(@"WebSocket connected");
    [self sendUUIDWithCompletion:^{
        [self startMessageListener];
        [self subscribeToTopics];
        [self startPingTimer];
    }];
}

- (void)URLSession:(NSURLSession *)session webSocketTask:(NSURLSessionWebSocketTask *)webSocketTask didCloseWithCode:(NSURLSessionWebSocketCloseCode)closeCode reason:(NSData *)reason {
    NSLog(@"WebSocket disconnected with code: %ld", (long)closeCode);
    [self stopPingTimer];
}

@end
