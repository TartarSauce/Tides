//
//  PCETideStationFetcher.h
//  HW6
//
//  Created by Paul Goracke on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PCEFetcher.h"

/*
 Fetches stations around a location (currently hardcoded) and parses them into the specified MOC.
 This happens asynchronously.
 */

@interface PCETideStationFetcher : PCEFetcher

+ (void) fetchTideStationsInContext:(NSManagedObjectContext*)context;

@end
