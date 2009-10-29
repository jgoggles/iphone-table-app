//
//  Movie.m
//  Movie
//
//  Created by Dan Weaver on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Resort.h"

@implementation Resort

@synthesize name;
@synthesize snowTwoDays;

- (id)initWithName:(NSString *)newName
	 snowTwoDays:(NSNumber *)newSnowTwoDays {
	self = [super init];
	if(nil != self) {
		self.name = newName;
		self.snowTwoDays = newSnowTwoDays;
	}
	return self;
}

- (void) dealloc {
	self.name = nil;
	self.snowTwoDays = nil;
	[super dealloc];
}

@end
