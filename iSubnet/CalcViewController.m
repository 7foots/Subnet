//
//  CalcViewController.m
//  iSubnet
//
//  Created by 7foots on 22.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalcViewController.h"


@implementation CalcViewController

@synthesize webView;

- (void)load:(NSString *)str
{
    temp = str;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.title = @"Calculations";
	webView.dataDetectorTypes = UIDataDetectorTypeNone;
    webView.userInteractionEnabled = YES;
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [webView loadHTMLString:temp baseURL:baseURL];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [super dealloc];
}

@end