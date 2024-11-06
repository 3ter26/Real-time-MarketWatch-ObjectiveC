#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TradeObjectModel.h"


@interface CustomCell : UITableViewCell

@property (nonatomic, strong) UILabel *highPriceLabel;
@property (nonatomic, strong) UILabel *askPriceLabel;
@property (nonatomic, strong) UILabel *bidPriceLabel;
@property (nonatomic, strong) UILabel *lastPriceLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *symbolLabel;

- (void)configureWithTradeObject: (TradeObjectModel *)tradeObject;
- (void)highlightLabel: (UIColor *)label;
@end
