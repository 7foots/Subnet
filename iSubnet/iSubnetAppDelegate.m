//
//  iSubnetAppDelegate.m
//  iSubnet
//
//  Created by 7foots on 21.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iSubnetAppDelegate.h"
#import "RootViewController.h"

@implementation iSubnetAppDelegate


@synthesize window=_window;
@synthesize navigationController=_navigationController;
@synthesize myrootViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // load
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [myrootViewController save];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [myrootViewController save];
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
