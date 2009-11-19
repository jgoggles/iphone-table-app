//
//  RootViewController.h
//  ResortTable
//
//  Created by Dan Weaver on 10/29/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "Resort.h"

@interface RootViewController : UITableViewController {
	NSMutableArray	*resortsArray;
	NSMutableData	*snowData;
	UITableViewCell *nibLoadedCell;
	UIActivityIndicatorView *activityIndicator;
	UILabel *loadingLabel;
	NSMutableString *snowDataString;
	NSMutableDictionary *currentSnowDataDict;
	NSString *currentElementName;
	NSMutableString *currentText;
	NSSet *interestingTags;
}

@property (nonatomic, retain) IBOutlet UITableViewCell *nibLoadedCell;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UILabel *loadingLabel;

- (IBAction)placeCall;

@end
