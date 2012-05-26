//
//  PCEParseStationsOperation.m
//  HW6
//
//  Created by Paul Goracke on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCEParseStationsOperation.h"

#import "PCETideStation.h"

@interface PCEParseStationsOperation ()

@property (retain,nonatomic) PCETideStation* currentStation;

@end

@implementation PCEParseStationsOperation

@synthesize currentStation = _currentStation;

- (void) dealloc {
	[_currentStation release];
	
	[super dealloc];
}

#pragma mark - NSXMLParserDelegate

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	if ( [elementName isEqualToString:@"station"] ) {
		// create a new Station to capture the attributes to follow
		self.currentStation = [NSEntityDescription insertNewObjectForEntityForName:[PCETideStation entityName]
																				  inManagedObjectContext:self.managedObjectContext];
	}
	
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	static NSInteger numStations = 0;
	
	NSString* value = [self parsedAndTrimmedString];
	
	if ( [elementName isEqualToString:@"station"] ) {
		// station element ended. stop adding attributes to it.
		self.currentStation = nil;
		
		// Provide quicker progress appearance by saving periodically instead of
		// requiring entire feed to parse first
		if ( numStations++ % 20 == 0 ) {
			NSError* error = nil;
			BOOL saved = [self.managedObjectContext save:&error];
			if ( ! saved ) {
				NSLog(@"ERR: %@", [error localizedDescription]);
			}
		}
	}
	else if ( [elementName isEqualToString:@"type"] ) {
		// We only want tide stations for now
		if ( ! [value isEqualToString:@"tide"] ) {
			[self.managedObjectContext deleteObject:self.currentStation];
			self.currentStation = nil;
		}
	}
	else if ( [elementName isEqualToString:@"name"] ) {
		self.currentStation.name = value;
	}
	else if ( [elementName isEqualToString:@"index"] ) {
		// This is our unique identifier for the object; check if we already have one
		PCETideStation* existingStation = [PCETideStation stationWithIdentifier:value
																					inContext:self.managedObjectContext];
		if ( existingStation != nil && existingStation != self.currentStation ) {
			// if there's already a station in the store for this identifier, use it
			// copy over any elements we've already parsed
			existingStation.name = self.currentStation.name;
			existingStation.latitude = self.currentStation.latitude;
			existingStation.longitude = self.currentStation.longitude;
			// don't store the "temporary" object we'd been using
			[self.managedObjectContext deleteObject:self.currentStation];
			// start storing attributes in the existing object
			self.currentStation = existingStation;
		}
		else {
			// no existing object--carry on
			self.currentStation.stationIdentifier = value;
		}
	}
	else if ( [elementName isEqualToString:@"latitude"] ) {
		self.currentStation.latitude = [value floatValue];
	}
	else if ( [elementName isEqualToString:@"longitude"] ) {
		self.currentStation.longitude = [value floatValue];
	}
}

@end
