//
//  PCETideStation.m
//  HW6
//
//  Created by Paul Goracke on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCETideStation.h"
#import "PCEPrediction.h"

NSString* const PCETideStationKeyName = @"name";
NSString* const PCETideStationKeyStationIdentifier = @"stationIdentifier";
NSString* const PCETideStationKeyLatitude = @"latitude";
NSString* const PCETideStationKeyLongitude = @"longitude";
NSString* const PCETideStationKeyPredictions = @"predictions";


@implementation PCETideStation

@dynamic name;
@dynamic stationIdentifier;
@dynamic latitude;
@dynamic longitude;
@dynamic predictions;

+ (NSString*) entityName {
	return @"PCETideStation";
}

+ (PCETideStation*) stationWithIdentifier:(NSString *)stationIdentifier inContext:(NSManagedObjectContext *)context {
	NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
	request.predicate = [NSPredicate predicateWithFormat:@"%K == %@", PCETideStationKeyStationIdentifier, stationIdentifier];
	
	NSError* error = nil;
	NSArray* results = [context executeFetchRequest:request error:&error];
	if ( results == nil ) {
		NSLog(@"ERR: %@", [error localizedDescription]);
	}
	
	return [results lastObject];
}

@end
