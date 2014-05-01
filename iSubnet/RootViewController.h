//
//  RootViewController.h
//  iSubnet
//
//  Created by 7foots on 21.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Subneter.h"

@interface RootViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDataSource>
{
    UILabel *labelIP;
    UITextField *textFieldIp;
	UILabel *labelBits;
	UISlider *sliderBits;
	UITableView *resultsTable;
	UISegmentedControl *segmentNumberSystem;
    UIWebView *webView;
	NSArray *arrayResults;
    Subneter *subneter;
}

- (void)orientationSizer:(UIInterfaceOrientation)interfaceOrientation;
- (void)updateAll;
- (void)save;
@end
