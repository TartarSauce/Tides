//
//  PCEPrediction.m
//  HW6
//
//  Created by Paul Goracke on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCEPrediction.h"
#import "PCETideStation.h"

NSString* const PCEPredictionKeyDateTime = @"dateTime";
NSString* const PCEPredictionKeyEventCode = @"eventCode";
NSString* const PCEPredictionKeyValue = @"value";
NSString* const PCEPredictionKeyStation = @"station";

@implementation PCEPrediction

@dynamic dateTime;
@dynamic eventCode;
@dynamic value;
@dynamic station;

+ (NSString*) entityName {
	return @"PCEPrediction";
}

+ (PCEPrediction*) predictionForStation:(PCETideStation*)station dateTime:(NSDate*)dateTime {
	NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
	request.predicate = [NSPredicate predicateWithFormat:
								@"%K == %@ && %K == %@", 
								PCEPredictionKeyStation, 
								station,
								PCEPredictionKeyDateTime,
								dateTime
								];
	
	NSError* error = nil;
	NSArray* results = [station.managedObjectContext executeFetchRequest:request error:&error];
	if ( results == nil ) {
		NSLog(@"ERR: %@", [error localizedDescription]);
	}
	
	return [results lastObject];

}

- (NSString*) eventCodeString {
	NSString* typeString = nil;
	switch ( self.eventCode ) {
		case PCETideStationTypeHighTide:
			typeString = @"High Tide";
			break;
		case PCETideStationTypeLowTide:
			typeString = @"Low Tide";
			break;
		case PCETideStationTypeSunrise:
			typeString = @"Sunrise";
			break;
		case PCETideStationTypeSunset:
			typeString = @"Sunset";
			break;
		case PCETideStationTypeNewMoon:
			typeString = @"New Moon";
			break;
		default:
			typeString = [NSString stringWithFormat:@"<Unknown %i>", self.eventCode];
			break;
	}
	return typeString;
}
@end
