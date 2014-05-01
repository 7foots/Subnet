//
//  iSubnetAppDelegate.h
//  iSubnet
//
//  Created by 7foots on 21.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface iSubnetAppDelegate : NSObject <UIApplicationDelegate>
{

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet RootViewController *myrootViewController;

@end
