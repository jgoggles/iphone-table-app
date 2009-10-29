//
//  Movie.h
//  Movie
//
//  Created by Dan Weaver on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Resort : NSObject {
	NSString *name;
	NSNumber *snowTwoDays;
}

- (id)initWithName:(NSString *)newName
	 snowTwoDays:(NSNumber *)snowTwoDays;

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSNumber *snowTwoDays;

@end
