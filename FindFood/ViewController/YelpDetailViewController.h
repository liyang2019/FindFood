//
//  YelpDetailViewController.h
//  FindFood
//
//  Created by Li Yang on 10/21/17.
//  Copyright © 2017 Rice University. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YelpDataModel;

@interface YelpDetailViewController : UIViewController

- (instancetype)initWithDataModel:(YelpDataModel *)dataModel;

@end
