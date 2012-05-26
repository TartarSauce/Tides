//
//  PCEParsePredictionsOperation.m
//  HW6
//
//  Created by Paul Goracke on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCEParsePredictionsOperation.h"

#import "PCETideStation.h"
#import "PCEPrediction.h"

@interface PCEParsePredictionsOperation ()

@property (nonatomic,retain) NSManagedObjectID* tideStationID;
@property (retain,nonatomic) PCEPrediction* currentPrediction;

@end

@implementation PCEParsePredictionsOperation

@synthesize tideStationID = _tideStationID;
@synthesize currentPrediction = _currentPrediction;

- (void) dealloc {
	[_tideStationID release];
	[_currentPrediction release];
	[super dealloc];
}

- (void) setTideStation:(PCETideStation *)tideStation {
	// need to use the station's objectID because we'll be operating on a separate
	// child MOC in the background
	self.tideStationID = [tideStation objectID];
}

#pragma mark - NSXMLParserDelegate

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	if ( [elementName isEqualToString:@"prediction"] ) {
		// create a new Prediction object to capture the attributes that follow
		self.currentPrediction = [NSEntityDescription insertNewObjectForEntityForName:[PCEPrediction entityName]
																			 inManagedObjectContext:self.managedObjectContext];
		PCETideStation* station = (PCETideStation*)[self.managedObjectContext objectWithID:self.tideStationID];
		self.currentPrediction.station = station;
	}
	
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	NSString* value = [self parsedAndTrimmedString];
	
	if ( [elementName isEqualToString:@"prediction"] ) {
		self.currentPrediction = nil;
	}
	else if ( [elementName isEqualToString:@"posixtime"] ) {
		// This is our unique identifier for the object; check if we already have one
		NSTimeInterval posixtime = [value doubleValue];
		NSDate* date = [NSDate dateWithTimeIntervalSince1970:posixtime];
		NSAssert( date != nil, @"date unparsed" );
		PCETideStation* station = (PCETideStation*)[self.managedObjectContext objectWithID:self.tideStationID];
		PCEPrediction* existingPrediction = [PCEPrediction predictionForStation:station dateTime:date];
		if ( existingPrediction != nil && existingPrediction != self.currentPrediction ) {
			// if there's already a prediction in the store for this identifier, use it
			// copy over any elements we've already parsed
			existingPrediction.value = self.currentPrediction.value;
			existingPrediction.eventCode = self.currentPrediction.eventCode;
			// don't store the "temporary" object we'd been using
			[self.managedObjectContext deleteObject:self.currentPrediction];
			// start storing attributes in the existing object
			self.currentPrediction = existingPrediction;
		}
		else {
			// no existing object--carry on
			self.currentPrediction.dateTime = date;
		}
	}
	else if ( [elementName isEqualToString:@"value"] ) {
		self.currentPrediction.value = [NSNumber numberWithFloat:[value floatValue]];
	}
	else if ( [elementName isEqualToString:@"eventcode"] ) {
		self.currentPrediction.eventCode = [value intValue];
	}
}

@end
