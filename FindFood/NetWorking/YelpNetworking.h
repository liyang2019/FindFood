//
//  YelpNetworking.h
//  FindFood
//
//  Created by Li Yang on 10/11/17.
//  Copyright © 2017 Rice University. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "YelpDataModel.h"

@import CoreLocation;

typedef void (^RestaurantCompletionBlock)(NSArray <YelpDataModel *>* dataModelArray);

@interface YelpNetworking : NSObject

+ (YelpNetworking *)sharedInstance;

- (void)fetchRestaurantsBasedOnLocation:(CLLocation *)location term:(NSString *)term completionBlock:(RestaurantCompletionBlock)completionBlock;

@end

