//
//  ViewController.m
//  SelectColor
//
//  Created by Demon on 2018/2/9.
//  Copyright © 2018年 Demon. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"

typedef NS_ENUM(NSUInteger,LookType) {
    LookType_ALL,
    LookType_BLACK,
    LoolType_WHITE
};

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate>
{
    UIButton *currentBtn;
}
@property(nonatomic, assign) LookType lookType;

@property (weak, nonatomic) IBOutlet UITableView *selectTableView;

@property(nonatomic, strong) UISearchController *searchController;

@property(nonatomic, strong) NSMutableArray<GJColorModel *> *colorArray;

@property(nonatomic, strong) NSMutableArray<GJColorModel *> *datas;
@property (weak, nonatomic) IBOutlet UIButton *lookAllBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableviewTop;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lookType = LookType_ALL;
    currentBtn = self.lookAllBtn;
    [self.selectTableView registerNib:[UINib nibWithNibName:NSStringFromClass([TableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    self.selectTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.selectTableView.estimatedRowHeight = 30;
    self.selectTableView.rowHeight = UITableViewAutomaticDimension;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"请输入十六进制色值(如:ffffff)";
    self.selectTableView.tableHeaderView = self.searchController.searchBar;
    [self themePlist];
}

- (IBAction)selectSearchModel:(UIButton *)sender {
    if (currentBtn == sender) return;
    currentBtn.selected = !currentBtn.selected;
    sender.selected = !sender.selected;
    currentBtn = sender;
    switch (sender.tag) {
        case 0:
            self.lookType = LookType_BLACK;
            break;
        case 1:
            self.lookType = LoolType_WHITE;
            break;
        case 2:
            self.lookType = LookType_ALL;
            break;
        default:
            self.lookType = LookType_ALL;
            break;
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *inputStr = searchController.searchBar.text;
    inputStr = [[inputStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if (inputStr.length == 6) {
        [self.datas removeAllObjects];
        [self.colorArray enumerateObjectsUsingBlock:^(GJColorModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (self.lookType == LookType_ALL) {
                if ([obj.darkColor isEqualToString:inputStr]) {
                    [self.datas addObject:obj];
                } else if ([obj.lightColor isEqualToString:inputStr]){
                    [self.datas addObject:obj];
                }
            } else if (self.lookType == LookType_BLACK) {
                if ([obj.darkColor isEqualToString:inputStr]) {
                    [self.datas addObject:obj];
                }
            } else if (self.lookType == LoolType_WHITE) {
                if ([obj.lightColor isEqualToString:inputStr]) {
                    [self.datas addObject:obj];
                }
            }
        }];
        [self.selectTableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return self.datas.count;
    }
    return self.colorArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    GJColorModel *model;
    if (self.searchController.active) {
        if (self.datas.count > 0) {
            model = self.datas[indexPath.row];
        }
    } else {
       model  = self.colorArray[indexPath.row];
    }
    cell.colorName.text = model.colorName;
    cell.darkColorName.text = model.darkColor;
    cell.lightColorName.text = model.lightColor;
    cell.darkColor.backgroundColor = [self colorWithHexString:model.darkColor];
    cell.lightColor.backgroundColor = [self colorWithHexString:model.lightColor];
    return cell;
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    if (self.datas.count > 0) {
        [self.datas removeAllObjects];
    }
    [self.selectTableView reloadData];
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    self.tableviewTop.constant = 0;
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    self.tableviewTop.constant = 40;
    [self.selectTableView setScrollsToTop:YES];
}

- (NSMutableArray<GJColorModel *> *)colorArray {
    if (!_colorArray) {
        _colorArray = [NSMutableArray array];
    }
    return _colorArray;
}

- (NSMutableArray<GJColorModel *> *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (UIColor *)colorWithHexString:(NSString *)color {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

- (void)themePlist {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Theme" ofType:@"plist"];
    NSArray *themeArray = [NSArray arrayWithContentsOfFile:path];
    NSDictionary *darkDic = themeArray[0];
    NSDictionary *lightDic = themeArray[1];
    
    NSDictionary *darkColorDic = darkDic[@"ThemeColor"];
    NSDictionary *lightColorDic = lightDic[@"ThemeColor"];
    
    for (NSString *key in darkColorDic.allKeys) {
        GJColorModel *model = [[GJColorModel alloc] init];
        model.colorName = key;
        model.darkColor = darkColorDic[key];
        model.lightColor = lightColorDic[key];
        [self.colorArray addObject:model];
    }
    [self.selectTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


@implementation GJColorModel
@end
