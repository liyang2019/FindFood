//
//  YelpAnnotation.h
//  FindFood
//
//  Created by Li Yang on 10/18/17.
//  Copyright © 2017 Rice University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YelpDataModel.h"
@import MapKit;

@interface YelpAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly) YelpDataModel *dataModel;
- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle dataModel:(YelpDataModel *)dataModel;

+ (NSArray <YelpAnnotation *>*)buildAnnotationArrayFromDataArray:(NSArray<YelpDataModel *> *)dataArray;

@end
