//
//  YelpDataStore.h
//  FindFood
//
//  Created by Li Yang on 10/18/17.
//  Copyright © 2017 Rice University. All rights reserved.
//


#import <Foundation/Foundation.h>

@class YelpDataModel;

@import CoreLocation;

@interface YelpDataStore : NSObject
@property (nonatomic, copy) NSArray <YelpDataModel *> *dataModels;
@property (nonatomic) CLLocation *userLocation;

+ (YelpDataStore *)sharedInstance;
@end

