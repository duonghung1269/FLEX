//
//  FLEX8BallPoolModTableViewController.m
//  FLEX
//
//  Created by Dang Duong Hung on 15/1/19.
//  Copyright © 2019 Flipboard. All rights reserved.
//

#import "FLEX8BallPoolModTableViewController.h"
#import "FLEXUtility.h"
#import "FLEXManager+Private.h"
#import "FLEXGlobalsTableViewControllerEntry.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger, FLEX8BallPoolModRow) {
    FLEX8BallPoolRowGuideline,
    FLEX8BallPoolRowCount
};

@interface FLEX8BallPoolModTableViewController ()

@property (nonatomic, readonly, copy) NSArray<FLEXGlobalsTableViewControllerEntry *> *entries;

@end

@implementation FLEX8BallPoolModTableViewController

+ (NSArray<FLEXGlobalsTableViewControllerEntry *> *)defaultGlobalEntries
{
    NSMutableArray<FLEXGlobalsTableViewControllerEntry *> *defaultGlobalEntries = [NSMutableArray array];
    
    for (FLEX8BallPoolModRow defaultRowIndex = 0; defaultRowIndex < FLEX8BallPoolRowCount; defaultRowIndex++) {
        FLEXGlobalsTableViewControllerEntryNameFuture titleFuture = nil;
        FLEXGlobalsTableViewControllerViewControllerFuture viewControllerFuture = nil;
        
        switch (defaultRowIndex) {
            case FLEX8BallPoolRowGuideline:
                titleFuture = ^{
                    return @"🎱 Guideline Length";
                };
                viewControllerFuture = ^{
                    return [[UIViewController alloc] init];
                };
                break;
            case FLEX8BallPoolRowCount:
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
        self.title = @"🎱 8 Ball Pool";
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
    switch ([indexPath row]) {
        case FLEX8BallPoolRowGuideline:
            // Swizzling guideline length here
            NSLog(@"8ball guideline click");
            [self injectInfiniteGuideline];
            break;
        case FLEX8BallPoolRowCount:
            break;
    }
    
//    UIViewController *viewControllerToPush = [self viewControllerToPushForRowAtIndexPath:indexPath];
//
//    [self.navigationController pushViewController:viewControllerToPush animated:YES];
}

#pragma mark - Inject methods

- (void)injectInfiniteGuideline
{
    SEL originalSelector = NSSelectorFromString(@"getAimForCue:");
    SEL swizzledSelector = [FLEXUtility swizzledSelectorForSelector:originalSelector];
    
    Class userInfoClass = NSClassFromString(@"UserInfo");
    
    typedef int (^ModdedAimForCue)(int);
    ModdedAimForCue implementationBlock = ^int(int cueId) {
        NSLog(@"8ball._moddedGetAimForCue called, original aim value = %ul", cueId);
        return 200;
    };
    
    [FLEXUtility replaceImplementationOfKnownSelector:originalSelector onClass:userInfoClass withBlock:implementationBlock swizzledSelector:swizzledSelector];
}

@end


