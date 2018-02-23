//
//  TableViewCell.h
//  SelectColor
//
//  Created by Demon on 2018/2/9.
//  Copyright © 2018年 Demon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *colorName;
@property (weak, nonatomic) IBOutlet UILabel *darkColor;
@property (weak, nonatomic) IBOutlet UILabel *lightColor;
@property (weak, nonatomic) IBOutlet UILabel *darkColorName;
@property (weak, nonatomic) IBOutlet UILabel *lightColorName;

@end
