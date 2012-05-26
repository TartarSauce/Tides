//
//  PCEPrediction.h
//  HW6
//
//  Created by Paul Goracke on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PCETideStation;

extern NSString* const PCEPredictionKeyDateTime;
extern NSString* const PCEPredictionKeyEventCode;
extern NSString* const PCEPredictionKeyValue;
extern NSString* const PCEPredictionKeyStation;

typedef enum {
	PCETideStationTypeHighTide = 0,
	PCETideStationTypeLowTide = 1,
	PCETideStationTypeSunrise = 6,
	PCETideStationTypeSunset = 7,
	PCETideStationTypeNewMoon = 8,
} PCETideStationType;

@interface PCEPrediction : NSManagedObject

@property (nonatomic, retain) NSDate* dateTime;
@property (nonatomic) int32_t eventCode;
@property (nonatomic, retain) NSNumber* value;
@property (nonatomic, retain) PCETideStation *station;

- (NSString*) eventCodeString;

+ (NSString*) entityName;

+ (PCEPrediction*) predictionForStation:(PCETideStation*)station dateTime:(NSDate*)dateTime;

@end
