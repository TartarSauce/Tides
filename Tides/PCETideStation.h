//
//  PCETideStation.h
//  HW6
//
//  Created by Paul Goracke on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PCEPrediction;

extern NSString* const PCETideStationKeyName;
extern NSString* const PCETideStationKeyStationIdentifier;
extern NSString* const PCETideStationKeyLatitude;
extern NSString* const PCETideStationKeyLongitude;
extern NSString* const PCETideStationKeyPredictions;

@interface PCETideStation : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString* stationIdentifier;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic, retain) PCEPrediction *predictions;

+ (NSString*) entityName;

+ (PCETideStation*) stationWithIdentifier:(NSString*)stationIdentifier inContext:(NSManagedObjectContext*)context;

@end
