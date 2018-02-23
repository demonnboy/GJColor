//
//  ViewController.h
//  SelectColor
//
//  Created by Demon on 2018/2/9.
//  Copyright © 2018年 Demon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@end

@interface GJColorModel : NSObject

@property(nonatomic, copy) NSString *colorName;

@property(nonatomic, copy) NSString *darkColor;

@property(nonatomic, copy) NSString *lightColor;

@end

