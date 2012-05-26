//
//  PCEParseXMLOperation.h
//  HW6
//
//  Created by Paul Goracke on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Provide base class parsing an XML feed on a background queue
 */

@interface PCEParseXMLOperation : NSOperation <NSXMLParserDelegate>

@property (retain,nonatomic,readonly) NSData* xmlData;
@property (retain,nonatomic,readonly) NSManagedObjectContext* managedObjectContext;

- (id) initWithData:(NSData*)xmlData context:(NSManagedObjectContext*)context;

- (NSString*) parsedAndTrimmedString;

@end
