//
//  FindFoodTableViewCell.h
//  FindFood
//
//  Created by Li Yang on 10/15/17.
//  Copyright © 2017 Rice University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YelpDataModel;

@interface FindFoodTableViewCell : UITableViewCell

- (void)updateBasedOnDataModel:(YelpDataModel *)dataModel;

@end
