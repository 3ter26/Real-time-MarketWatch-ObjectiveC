#import <Foundation/Foundation.h>
#import "CustomCell.h"

@implementation CustomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLabels];
        [self setupLabelColors];
        [self addLabelsToContentView];
    }
    return self;
}

- (void)initLabels {
    _nameLabel = [self createLabelWithFontSize:12];
    _symbolLabel = [self createLabelWithFontSize:12];
    _askPriceLabel = [self createLabelWithFontSize:12];
    _highPriceLabel = [self createLabelWithFontSize:12];
    _bidPriceLabel = [self createLabelWithFontSize:12];
    _lastPriceLabel = [self createLabelWithFontSize:12];
}

- (UILabel *)createLabelWithFontSize:(CGFloat)fontSize {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}

- (void)setupLabelColors {
    _askPriceLabel.textColor = [UIColor blueColor];
    _highPriceLabel.textColor = [UIColor redColor];
    _lastPriceLabel.textColor = [UIColor orangeColor];
    _bidPriceLabel.textColor = [UIColor purpleColor];
}

- (void)addLabelsToContentView {
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_symbolLabel];
    [self.contentView addSubview:_askPriceLabel];
    [self.contentView addSubview:_highPriceLabel];
    [self.contentView addSubview:_bidPriceLabel];
    [self.contentView addSubview:_lastPriceLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat labelHeight = self.contentView.frame.size.height - 20;
    CGFloat labelWidth = (self.contentView.frame.size.width / 6) - 10;
    CGFloat padding = 8.0;
    
    _nameLabel.frame = CGRectMake(padding, 10, 35, labelHeight);
    _symbolLabel.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame) + padding, 10, 85, labelHeight);
    _askPriceLabel.frame = CGRectMake(CGRectGetMaxX(_symbolLabel.frame) + padding, 10, labelWidth, labelHeight);
    _highPriceLabel.frame = CGRectMake(CGRectGetMaxX(_askPriceLabel.frame) + padding, 10, labelWidth, labelHeight);
    _lastPriceLabel.frame = CGRectMake(CGRectGetMaxX(_highPriceLabel.frame) + padding, 10, labelWidth, labelHeight);
    _bidPriceLabel.frame = CGRectMake(CGRectGetMaxX(_lastPriceLabel.frame) + padding, 10, labelWidth, labelHeight);
}

- (void)configureWithTradeObject:(TradeObjectModel *)tradeObject {
    _nameLabel.text = tradeObject.name;
    _symbolLabel.text = tradeObject.symbol;
    _askPriceLabel.text = [NSString stringWithFormat:@"%@", tradeObject.askPrice];
    _lastPriceLabel.text = [NSString stringWithFormat:@"%@", tradeObject.lastPrice];
    _bidPriceLabel.text = [NSString stringWithFormat:@"%@", tradeObject.bidPrice];
    _highPriceLabel.text = [NSString stringWithFormat:@"%@", tradeObject.highPrice];
}

- (void)highlightLabel:(UILabel *)label {
    label.backgroundColor = [UIColor redColor];
}

@end
