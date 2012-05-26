//
//  PCEParseXMLOperation.m
//  HW6
//
//  Created by Paul Goracke on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCEParseXMLOperation.h"

@interface PCEParseXMLOperation ()

@property (retain,nonatomic) NSData* xmlData;
@property (retain,nonatomic) NSManagedObjectContext* managedObjectContext;
@property (retain,nonatomic) NSMutableString* parsedString;

@end

@implementation PCEParseXMLOperation

@synthesize xmlData = _xmlData;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize parsedString = _parsedString;

- (void) dealloc {
	[_xmlData release];
	[_parsedString release];
	[_managedObjectContext release];
	
	[super dealloc];
}

- (id) initWithData:(NSData*)xmlData context:(NSManagedObjectContext*)context {
	self = [self init];
	if ( self != nil ) {
		_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
		[_managedObjectContext setParentContext:context];
		_xmlData = [xmlData copy]; // copy in case the caller clears or mutates the data
		_parsedString = [[NSMutableString alloc] init];
	}
	return self;
}

- (void) main {
	NSXMLParser* parser = [[NSXMLParser alloc] initWithData:self.xmlData];
	parser.delegate = self;
	[parser parse];
	[parser release];
}

- (NSString*) parsedAndTrimmedString {
	NSString* value = [self.parsedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	// clear the string now that it's retrieved.
	// this is a pretty big assumption, that the caller only needs this at the end of an element.
	// but it's holding true for our usage.
	[self.parsedString setString:@""];
	
	return value;
}

#pragma mark - NSXMLParserDelegate

- (void) parserDidStartDocument:(NSXMLParser *)parser {
//	NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
//	NSLog(@"%s", __PRETTY_FUNCTION__);
	NSError* error = nil;
	BOOL saved = [self.managedObjectContext save:&error];
	if ( ! saved ) {
		NSLog(@"ERR: %@", [error localizedDescription]);
	}
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	[self.parsedString appendString:string];
}


@end
