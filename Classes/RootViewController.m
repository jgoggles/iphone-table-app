//
//  RootViewController.m
//  ResortTable
//
//  Created by Dan Weaver on 10/29/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "RootViewController.h"

#define INTERESTING_TAG_NAMES @"Name", @"TopDepth", @"Open", @"NewSnow24", @"NumLiftsTotal", @"NumLiftsOpen", @"CallAheadPhone", nil


@implementation RootViewController

@synthesize nibLoadedCell;
@synthesize activityIndicator;
@synthesize loadingLabel;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIApplication* app = [UIApplication sharedApplication]; 
	app.networkActivityIndicatorVisible = YES;
	
	CGFloat x = 320/2 - 120/2;
	CGFloat y = 480/2 - 45/2;
	CGRect rect = CGRectMake(x , y, 120.0f, 45.0f);

	loadingLabel = [[[UILabel alloc] initWithFrame:rect] autorelease];
	[loadingLabel setText:@"Loading..."];
	loadingLabel.backgroundColor = [UIColor clearColor];
	loadingLabel.font = [UIFont fontWithName:@"Helvetica" size: 14.0];
	loadingLabel.textColor = [UIColor grayColor]; 
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[activityIndicator setCenter:CGPointMake(120.0f, 193.0f)];
	[loadingLabel setCenter:CGPointMake(200.0f, 193.0f)];
	[self.view addSubview:activityIndicator];
	[activityIndicator startAnimating];
	[self.view addSubview:loadingLabel];
	//[self.view addSubview:loadingSubView];
	
	interestingTags = [[NSSet alloc] initWithObjects: INTERESTING_TAG_NAMES];
	[resortsArray release];
	resortsArray = [[NSMutableArray alloc] init];

	[snowData release];
	snowData = [[NSMutableData alloc] init];
	NSURL *url = [NSURL URLWithString: @"http://postnewstools.com/widgets/snow_report.xml"];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/xml" forHTTPHeaderField:@"Accept"];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[connection release];
	[request release];
	
//	[self.navigationItem.titleView sizeToFit];
//	UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"snow_iphone_1.png"]];
//	self.navigationItem.titleView = titleImageView;
//	[titleImageView release];
	
}

- (void)startParsingSnowData {
	NSXMLParser *snowDataParser = [[NSXMLParser alloc] initWithData:snowData];
	snowDataParser.delegate = self;
	[snowDataParser parse];
	[snowDataParser release];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	[snowDataString release];
	snowDataString = [[NSMutableString alloc] init];
	currentElementName = nil;
	currentText = nil;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
		namespaceURI:(NSString *)namespaceURI
		qualifiedName:(NSString *)qualifiedName
		attributes:(NSDictionary *)attributesDict {
	if ([elementName isEqualToString:@"SkiArea"]) {
		[currentSnowDataDict release];
		currentSnowDataDict = [[NSMutableDictionary alloc]
							   initWithCapacity:[interestingTags count]];
	} else if ([interestingTags containsObject:elementName]) {
		currentElementName = elementName;
		currentText = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	[currentText appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
		namespaceURI:(NSString *)namespaceURI
		qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:currentElementName]) {
		[currentSnowDataDict setValue:currentText forKey:currentElementName];
	} else if ([elementName isEqualToString:@"SkiArea"]) {
		Resort *aResort = [[Resort alloc] init];
		aResort.name = [currentSnowDataDict valueForKey:@"Name"];
		aResort.snowOneDay = [currentSnowDataDict valueForKey:@"NewSnow24"];
		aResort.baseSnow = [currentSnowDataDict valueForKey:@"TopDepth"];
		aResort.status = [currentSnowDataDict valueForKey:@"Open"];
		if ([[currentSnowDataDict valueForKey:@"NumLiftsOpen"] isEqualToString:@"N/A"]) {
			aResort.liftsOpen = @"0";
		} else {
			aResort.liftsOpen = [currentSnowDataDict valueForKey:@"NumLiftsOpen"];
		}
		aResort.totalLifts = [currentSnowDataDict valueForKey:@"NumLiftsTotal"];
		aResort.callAheadNumber = [currentSnowDataDict valueForKey:@"CallAheadPhone"];
		//NSLog(@"%@: %@", aResort.name, aResort.callAheadNumber);
		//NSLog(@"%@: %@", aResort.name, aResort.status);
		[resortsArray addObject: aResort];
		[aResort release];
		NSLog(@"%@", currentSnowDataDict);
	}
	[currentText release];
	currentText = nil;
}	

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[snowData appendData:data];
}

- (void)connectionDidFinishLoading: (NSURLConnection*)connection {
	[self startParsingSnowData];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"Items in array: %d", [resortsArray count]);
	NSLog(@"Array references in memory: %1x", [resortsArray retainCount]);
	[activityIndicator stopAnimating];
	UIApplication* app = [UIApplication sharedApplication]; 
	app.networkActivityIndicatorVisible = NO;
	[self.tableView reloadData];
	[loadingLabel setHidden:YES];
}

- (void)placeCall:(id)sender {
	UIView *button = sender;
	
	for (UIView *parent = [button superview]; parent != nil; parent = [parent superview]) {
		if ([parent isKindOfClass: [UITableViewCell class]]) {
			UITableViewCell *cell = (UITableViewCell *) parent;               
//			NSIndexPath *path = [self.tableView indexPathForCell: cell];
			UILabel *phoneNumberLabel = (UILabel*) [cell viewWithTag:7];
			NSLog([NSString stringWithFormat:@"phone: %@", phoneNumberLabel.text]);
			NSString *phoneNumber = [NSString stringWithFormat:@"tel:%@", phoneNumberLabel.text];
			phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
			phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@") " withString:@"-"];
			NSLog([NSString stringWithFormat:@"%@", phoneNumber]);
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
			[phoneNumber release];
			
			break; // for
		}
	}
	
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
/*
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [resortsArray count];
	//return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		[[NSBundle mainBundle] loadNibNamed:@"ResortTableCell" owner:self options:NULL];
		cell = nibLoadedCell;
    }
    
	// Configure the cell.
	Resort *aResort = [resortsArray objectAtIndex:indexPath.row];
	UILabel *nameLabel = (UILabel*) [cell viewWithTag:1];
	nameLabel.text = aResort.name;
	//nameLabel.text = snowDataString;
	UILabel *statusLabel = (UILabel*) [cell viewWithTag:2];
	statusLabel.text = aResort.status;
	UILabel *phoneNumberLabel = (UILabel*) [cell viewWithTag:7];
	phoneNumberLabel.text = aResort.callAheadNumber;
	UIButton *callAheadNumberButton = (UIButton*) [cell viewWithTag:6];
	[callAheadNumberButton setTitle:aResort.status forState:UIControlStateNormal];
	[callAheadNumberButton addTarget:self action:@selector(placeCall:) forControlEvents:UIControlEventTouchUpInside];
	if ( [statusLabel.text isEqualToString:@"Open"] ) {
		[callAheadNumberButton setHidden:YES];
		[statusLabel setHidden:NO];

	} else {
		[statusLabel setHidden:YES];
		[callAheadNumberButton setHidden:NO];
	}
	
	UILabel *liftsLabel = (UILabel*) [cell viewWithTag:3];
	liftsLabel.text = [NSString stringWithFormat:@"Lifts open: %@ of %@", aResort.liftsOpen, aResort.totalLifts];
	UILabel *snowOneDayLabel = (UILabel*) [cell viewWithTag:4];
	snowOneDayLabel.text = [NSString stringWithFormat:@"24hr: %@\"", aResort.snowOneDay];
	UILabel *baseSnowLabel = (UILabel*) [cell viewWithTag:5];
	baseSnowLabel.text = [NSString stringWithFormat:@"Base: %@\"", aResort.baseSnow];
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100;
}





/*
// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // Navigation logic may go here -- for example, create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController animated:YES];
	// [anotherViewController release];
}
*/


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    [super dealloc];
}


@end