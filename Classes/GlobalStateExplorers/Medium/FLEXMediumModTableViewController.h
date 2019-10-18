//
//  FLEXMediumModTableViewController.h
//  FLEX
//
//  Created by Dang Duong Hung on 18/10/19.
//  Copyright © 2019 Flipboard. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FLEXMediumModTableViewControllerDelegate;

@interface FLEXMediumModTableViewController : UITableViewController

@property (nonatomic, weak) id <FLEXMediumModTableViewControllerDelegate> delegate;

@end

@protocol FLEXMediumModTableViewControllerDelegate <NSObject>

- (void)modAppsViewControllerDidFinish:(FLEXMediumModTableViewController *)mediumViewController;

@end
