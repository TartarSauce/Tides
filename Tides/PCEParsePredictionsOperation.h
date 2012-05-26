//
//  PCEParsePredictionsOperation.h
//  HW6
//
//  Created by Paul Goracke on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCEParseXMLOperation.h"

@class PCETideStation;

/*
 Parses prediction list feed on a background queue, into the same MOC as the specified tide station.
 */

@interface PCEParsePredictionsOperation : PCEParseXMLOperation

- (void) setTideStation:(PCETideStation*)tideStation;

@end
