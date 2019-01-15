//
//  FLEXModAppsTableViewController.m
//  FLEX
//
//  Created by Dang Duong Hung on 15/1/19.
//  Copyright © 2019 Flipboard. All rights reserved.
//

#import "FLEXModAppsTableViewController.h"
#import "FLEXUtility.h"
#import "FLEXManager+Private.h"
#import "FLEXGlobalsTableViewControllerEntry.h"
#import "FLEX8BallPoolModTableViewController.h"

typedef NS_ENUM(NSUInteger, FLEXModAppsRow) {
    FLEXModAppsRow8BallPool,
    FLEXGlobalsRowCount
};

@interface FLEXModAppsTableViewController ()

@property (nonatomic, readonly, copy) NSArray<FLEXGlobalsTableViewControllerEntry *> *entries;

@end

@implementation FLEXModAppsTableViewController

+ (NSArray<FLEXGlobalsTableViewControllerEntry *> *)defaultGlobalEntries
{
    NSMutableArray<FLEXGlobalsTableViewControllerEntry *> *defaultGlobalEntries = [NSMutableArray array];
    
    for (FLEXModAppsRow defaultRowIndex = 0; defaultRowIndex < FLEXGlobalsRowCount; defaultRowIndex++) {
        FLEXGlobalsTableViewControllerEntryNameFuture titleFuture = nil;
        FLEXGlobalsTableViewControllerViewControllerFuture viewControllerFuture = nil;
        
        switch (defaultRowIndex) {
            case FLEXModAppsRow8BallPool:
                titleFuture = ^{
                    return @"🎱 8 Ball Pool";
                };
                viewControllerFuture = ^{
                    return [[FLEX8BallPoolModTableViewController alloc] init];
                };
                break;
            case FLEXGlobalsRowCount:
                break;
        }
        
        NSParameterAssert(titleFuture);
        NSParameterAssert(viewControllerFuture);
        
        [defaultGlobalEntries addObject:[FLEXGlobalsTableViewControllerEntry entryWithNameFuture:titleFuture viewControllerFuture:viewControllerFuture]];
    }
    
    return defaultGlobalEntries;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"💉📱  Mod Apps";
        _entries = [[[self class] defaultGlobalEntries] arrayByAddingObjectsFromArray:[FLEXManager sharedManager].userGlobalEntries];
    }
    return self;
}

#pragma mark - Public

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed:)];
}

#pragma mark - Table Data Helpers

- (FLEXGlobalsTableViewControllerEntry *)globalEntryAtIndexPath:(NSIndexPath *)indexPath
{
    return self.entries[indexPath.row];
}

- (NSString *)titleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLEXGlobalsTableViewControllerEntry *entry = [self globalEntryAtIndexPath:indexPath];
    
    return entry.entryNameFuture();
}

- (UIViewController *)viewControllerToPushForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLEXGlobalsTableViewControllerEntry *entry = [self globalEntryAtIndexPath:indexPath];
    
    return entry.viewControllerFuture();
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.entries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [FLEXUtility defaultFontOfSize:14.0];
    }
    
    cell.textLabel.text = [self titleForRowAtIndexPath:indexPath];
    
    return cell;
}


#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewControllerToPush = [self viewControllerToPushForRowAtIndexPath:indexPath];
    
    [self.navigationController pushViewController:viewControllerToPush animated:YES];
}

@end

