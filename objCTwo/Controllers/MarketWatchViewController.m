#import "MarketWatchViewController.h"
#import "TradeObjectModel.h"
#import "TradeObjectService.h"
#import "WebSocketService.h"
#import <Foundation/Foundation.h>
#import "CustomCell.h"

@implementation MarketWatchViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[CustomCell class] forCellReuseIdentifier:@"TradeObjectCell"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUI:) name:@"TradeObjectUpdatedNotification" object:nil];
    [self fillTradeObjectsManually];
    //[self fetchTradeObjects]; //part-1 in the exercise
    WebSocketService *shared = [WebSocketService singletonWsConnection];
    [shared connectToWebSocket];
}

- (void) dealloc {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tradeObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TradeObjectCell" forIndexPath:indexPath];
    TradeObjectModel *tradeObject = _tradeObjects[indexPath.row];
    [cell configureWithTradeObject:tradeObject];

    return cell;
}


- (void)fillTradeObjectsManually{
    [[TradeObjectService singleton]fillTradeObjects:^(NSArray *tradeObjects) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_tradeObjects = tradeObjects;
            [self.tableView reloadData];
        });
    }];
}

-(void)updateUI:(NSNotification *)notification {
    NSString *symbolThatNeedsUpdate = notification.userInfo[@"symbol"];
    NSDictionary *updatedData = notification.userInfo[@"updatedData"];

    NSString *formattedSymbol = [[NSString alloc]init];
    
    for(TradeObjectModel *tradeObj in _tradeObjects){
            formattedSymbol = [NSString stringWithFormat:@"QO.%@",tradeObj.symbol];
        if([symbolThatNeedsUpdate isEqual:formattedSymbol]){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (updatedData[@"askPrice"]) {
                    tradeObj.askPrice = updatedData[@"askPrice"];
                    }
                  if (updatedData[@"lastPrice"]) {
                    tradeObj.lastPrice = updatedData[@"lastPrice"];
                    }
                  if (updatedData[@"highPrice"]) {
                    tradeObj.highPrice = updatedData[@"highPrice"];
                   }
                   if (updatedData[@"bidPrice"]) {
                    tradeObj.bidPrice = updatedData[@"bidPrice"];
                    }
                [self.tableView reloadData];
            });
            break;
        }
    }
}







//part-1 in the exercise:
- (void)fetchTradeObjects {
    [[TradeObjectService singleton] getTradeObjects:^(NSArray *tradeObjects) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_tradeObjects = tradeObjects;
                [self.tableView reloadData];
            });
        }];
}
@end
