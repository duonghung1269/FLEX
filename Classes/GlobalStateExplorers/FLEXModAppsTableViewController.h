//
//  FLEXModAppsTableViewController.h
//  FLEX
//
//  Created by Dang Duong Hung on 15/1/19.
//  Copyright © 2019 Flipboard. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FLEXModAppsTableViewControllerDelegate;

@interface FLEXModAppsTableViewController : UITableViewController

@property (nonatomic, weak) id <FLEXModAppsTableViewControllerDelegate> delegate;

@end

@protocol FLEXModAppsTableViewControllerDelegate <NSObject>

- (void)modAppsViewControllerDidFinish:(FLEXModAppsTableViewController *)modAppsViewController;

@end

