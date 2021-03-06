//
//  BuySellChartViewController.m
//  StockListener
//
//  Created by Guozhen Li on 12/14/15.
//  Copyright © 2015 Guangzhen Li. All rights reserved.
//

#import "BuySellChartViewController.h"
#import "stockInfo.h"

// Views
#import "JBBarChartView.h"
#import "JBChartHeaderView.h"
#import "JBBarChartFooterView.h"
#import "JBChartInformationView.h"
#import "JBColorConstants.h"

// Numerics
CGFloat const kJBBarChartViewControllerChartHeight = 50.0f;
CGFloat const kJBBarChartViewControllerChartPadding = 10.0f;
CGFloat const kJBBarChartViewControllerChartHeaderHeight = 80.0f;
CGFloat const kJBBarChartViewControllerChartHeaderPadding = 0.0f;
CGFloat const kJBBarChartViewControllerChartFooterHeight = 5.0f;
CGFloat const kJBBarChartViewControllerChartFooterPadding = 5.0f;
CGFloat const kJBBarChartViewControllerBarPadding = 1.0f;
NSInteger const kJBBarChartViewControllerMaxBarHeight = 10;
NSInteger const kJBBarChartViewControllerMinBarHeight = 5;

// Strings
NSString * const kJBBarChartViewControllerNavButtonViewKey = @"view";

@interface BuySellChartViewController() <JBBarChartViewDelegate, JBBarChartViewDataSource> {
    UIView* view;
    NSInteger maxCount;
}
@property (nonatomic, strong) JBBarChartView *barChartView;

@end

@implementation BuySellChartViewController

-(id) initWithParentView:(UIView*)parentView {
    if (self = [super init]) {
        view = parentView;
        maxCount = 0;
    }
    return self;
}

- (void)dealloc
{
    _barChartView.delegate = nil;
    _barChartView.dataSource = nil;
}

- (NSString*) valueToStr:(NSString*)str {
    //    NSString* str = [NSString stringWithFormat:@"%.3f", value];
    int index = (int)[str length] - 1;
    for (; index >= 0; index--) {
        char c = [str characterAtIndex:index];
        if (c !='0') {
            break;
        }
    }
    if (index <= 0) {
        return @"0";
    }
    if ([str characterAtIndex:index] == '.') {
        index--;
    }
    if (index <= 0) {
        return @"0";
    }
    str = [str substringToIndex:index+1];
    return str;
}

- (void)loadView:(int)yOffset
{
    self.barChartView = [[JBBarChartView alloc] init];
    int width = view.bounds.size.width - (kJBBarChartViewControllerChartPadding *2);
    self.barChartView.frame = CGRectMake(kJBBarChartViewControllerChartPadding, yOffset, width, kJBBarChartViewControllerChartHeight);
    self.barChartView.delegate = self;
    self.barChartView.dataSource = self;
    self.barChartView.headerPadding = kJBBarChartViewControllerChartHeaderPadding;
    self.barChartView.minimumValue = 0.0f;
    self.barChartView.inverted = NO;
    self.barChartView.backgroundColor = kJBColorBarChartBackground;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    label.text = @"^";
    
    [view addSubview:self.barChartView];
    [view addSubview:label];
    CGRect rect = label.frame;
    rect.origin.x = view.bounds.size.width/2 - rect.size.width/2;
    rect.origin.y = self.barChartView.frame.size.height + self.barChartView.frame.origin.y;
    [label setFrame:rect];
}

#define degreeTOradians(x) (M_PI * (x)/180)
-(void) loadViewVertical:(CGRect) rect {
    self.barChartView = [[JBBarChartView alloc] init];
    self.barChartView.frame = CGRectMake(rect.origin.x-rect.size.height/2+rect.size.width/2,
                                         rect.origin.y + rect.size.height/2 - rect.size.width/2,
                                         rect.size.height, rect.size.width);
    self.barChartView.delegate = self;
    self.barChartView.dataSource = self;
//    self.barChartView.headerPadding = kJBBarChartViewControllerChartHeaderPadding;
    self.barChartView.minimumValue = 0.0f;
    self.barChartView.inverted = NO;
    self.barChartView.backgroundColor = kJBColorBarChartBackground;
    
    [view addSubview:self.barChartView];

    self.barChartView.transform =  CGAffineTransformMakeRotation(degreeTOradians(270));
    self.barChartView.layer.borderWidth = 0.5;
    self.barChartView.layer.borderColor = [[UIColor grayColor] CGColor];
}

- (void) reload {
    maxCount = 0;
    if (_stockInfo.buyFiveCount > maxCount) {
        maxCount = _stockInfo.buyFiveCount;
    }
    if (_stockInfo.buyFourCount > maxCount) {
        maxCount = _stockInfo.buyFourCount;
    }
    if (_stockInfo.buyThreeCount > maxCount) {
        maxCount = _stockInfo.buyThreeCount;
    }
    if (_stockInfo.buyTwoCount > maxCount) {
        maxCount = _stockInfo.buyTwoCount;
    }
    if (_stockInfo.buyOneCount > maxCount) {
        maxCount = _stockInfo.buyOneCount;
    }
    if (_stockInfo.sellFiveCount > maxCount) {
        maxCount = _stockInfo.sellFiveCount;
    }
    if (_stockInfo.sellFourCount > maxCount) {
        maxCount = _stockInfo.sellFourCount;
    }
    if (_stockInfo.sellThreeCount > maxCount) {
        maxCount = _stockInfo.sellThreeCount;
    }
    if (_stockInfo.sellTwoCount > maxCount) {
        maxCount = _stockInfo.sellTwoCount;
    }
    if (_stockInfo.sellOneCount > maxCount) {
        maxCount = _stockInfo.sellOneCount;
    }

    [self.barChartView reloadData];
    
    [self.barChartView setState:JBChartViewStateExpanded];
}

#pragma mark - JBChartViewDataSource

- (BOOL)shouldExtendSelectionViewIntoHeaderPaddingForChartView:(JBChartView *)chartView
{
    return NO;
}

- (BOOL)shouldExtendSelectionViewIntoFooterPaddingForChartView:(JBChartView *)chartView
{
    return NO;
}

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
//    float count = self.stockInfo.todayHighestPrice - self.stockInfo.todayLoestPrice;
//    if (self.stockInfo.price < 2) {
//        count = count * 1000 + 1;
//    } else {
//        count = count * 100 + 1;
//    }
//    if (count < 10) {
//        count = 10;
//    }
    return 20;
}

- (void)barChartView:(JBBarChartView *)barChartView didSelectBarAtIndex:(NSUInteger)index touchPoint:(CGPoint)touchPoint
{
}

- (void)didDeselectBarChartView:(JBBarChartView *)barChartView
{
}

#pragma mark - JBBarChartViewDelegate

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtIndex:(NSUInteger)index
{
    long tmpIndex = index - 5;
    switch (tmpIndex) {
        case 0:
            return _stockInfo.buyFiveCount;
        case 1:
            return _stockInfo.buyFourCount;
        case 2 :
            return _stockInfo.buyThreeCount;
        case 3:
            return _stockInfo.buyTwoCount;
        case 4:
            return _stockInfo.buyOneCount;
        case 5:
            return _stockInfo.sellOneCount;
        case 6:
            return _stockInfo.sellTwoCount;
        case 7:
            return _stockInfo.sellThreeCount;
        case 8:
            return _stockInfo.sellFourCount;
        case 9:
            return _stockInfo.sellFiveCount;
        default:
            break;
    }
    float price = 0;
    float start = 0;
    if (index >= 15) {
        start = _stockInfo.sellFivePrice;
    } else {
        start = _stockInfo.buyFivePrice;
    }
    if (_stockInfo.price < 2) {
        price = start + tmpIndex * 0.001;
    } else {
        price = start + tmpIndex * 0.01;
    }
    if (_stockInfo.price < 2) {
        price *= 1000;
    } else {
        price *= 100;
    }
    if (((int)(price*10) % 10) >= 5) {
        price += 1;
    }
    price = (int)price;
    if (_stockInfo.price < 2) {
        price /= 1000;
    } else {
        price /= 100;
    }
    NSNumber* number = [_stockInfo.buySellDic objectForKey:[NSNumber numberWithFloat:price]];
    if ([number integerValue] > maxCount) {
        return maxCount;
    }
    return [number integerValue];
}

- (UIColor *)barChartView:(JBBarChartView *)barChartView colorForBarViewAtIndex:(NSUInteger)index
{
    long tmpIndex = index - 5;
    float price = 0;
    switch (tmpIndex) {
        case 0:
            price = self.stockInfo.buyFivePrice;
            break;
        case 1:
            price = self.stockInfo.buyFourPrice;
            break;
        case 2 :
            price = self.stockInfo.buyThreePrice;
            break;
        case 3:
            price = self.stockInfo.buyTwoPrice;
            break;
        case 4:
            price = self.stockInfo.buyOnePrice;
            break;
        case 5:
            price = self.stockInfo.sellOnePrice;
            break;
        case 6:
            price = self.stockInfo.sellTwoPrice;
            break;
        case 7:
            price = self.stockInfo.sellThreePrice;
            break;
        case 8:
            price = self.stockInfo.sellFourPrice;
            break;
        case 9:
            price = self.stockInfo.sellFivePrice;
            break;
        default:
            break;
    }
    if (price == 0) {
        float start = 0;
        if (index >= 15) {
            start = _stockInfo.sellFivePrice;
        } else {
            start = _stockInfo.buyFivePrice;
        }
        if (_stockInfo.price < 2) {
            price = start + tmpIndex * 0.001;
        } else {
            price = start + tmpIndex * 0.01;
        }
    }

    float average = _stockInfo.dealTotalMoney/_stockInfo.dealCount;
    float current = _stockInfo.price;
    
    if (_stockInfo.price < 2) {
        price *= 1000;
        average *= 1000;
        current *= 1000;
    } else {
        price *= 100;
        average *= 100;
        current *= 100;
    }
    if (((int)(price*10) % 10) >= 5) {
        price += 1;
    }
    if (((int)(average*10) % 10) >= 5) {
        average += 1;
    }
    if (((int)(current*10) % 10) >= 5) {
        current += 1;
    }

    if ((int)price == (int)current) {
        return kJBColorBarChartBarBlue;
    }
    if ((int)price == (int)average) {
        return kJBColorBarChartBarYello;
    }
    
    if (index < 5 || index > 14) {
        return kJBColorBarChartBarGray;
    }
 
    return (index > 9) ? kJBColorBarChartBarGreen : kJBColorBarChartBarRed;
}

- (UIColor *)barSelectionColorForBarChartView:(JBBarChartView *)barChartView
{
    return [UIColor whiteColor];
}

- (CGFloat)barPaddingForBarChartView:(JBBarChartView *)barChartView
{
    return kJBBarChartViewControllerBarPadding;
}
@end
