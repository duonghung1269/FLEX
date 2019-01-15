//
//  FLEX8BallPoolModTableViewController.h
//  FLEX
//
//  Created by Dang Duong Hung on 15/1/19.
//  Copyright © 2019 Flipboard. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FLEX8BallPoolModTableViewControllerDelegate;

@interface FLEX8BallPoolModTableViewController : UITableViewController

@property (nonatomic, weak) id <FLEX8BallPoolModTableViewControllerDelegate> delegate;

@end

@protocol FLEX8BallPoolModTableViewControllerDelegate <NSObject>

- (void)modAppsViewControllerDidFinish:(FLEX8BallPoolModTableViewController *)ballPoolViewController;

@end
