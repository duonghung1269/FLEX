//
//  FLEXMediumModTableViewController.m
//  FLEX
//
//  Created by Dang Duong Hung on 18/10/19.
//  Copyright © 2019 Flipboard. All rights reserved.
//

#import "FLEXMediumModTableViewController.h"
#import "FLEXUtility.h"
#import "FLEXHeapEnumerator.h"
#import "FLEXManager+Private.h"
#import "FLEXGlobalsTableViewControllerEntry.h"
#import <objc/runtime.h>
#import <SSZipArchive/SSZipArchive.h>

typedef NS_ENUM(NSUInteger, FLEXMediumModRow) {
    FLEXMediumPatchDocumentsFiles,
    FLEXMediumDisableCookie,
    FLEXMediumRowCount,
};


@interface FLEXMediumModTableViewController ()
    @property (nonatomic, readonly, copy) NSArray<FLEXGlobalsTableViewControllerEntry *> *entries;
@end

static BOOL patchedMediumUnlimitedRead = false;

@implementation FLEXMediumModTableViewController

+ (NSArray<FLEXGlobalsTableViewControllerEntry *> *)defaultGlobalEntries
{
    NSMutableArray<FLEXGlobalsTableViewControllerEntry *> *defaultGlobalEntries = [NSMutableArray array];
    
    for (FLEXMediumModRow defaultRowIndex = 0; defaultRowIndex < FLEXMediumRowCount; defaultRowIndex++) {
        FLEXGlobalsTableViewControllerEntryNameFuture titleFuture = nil;
        FLEXGlobalsTableViewControllerViewControllerFuture viewControllerFuture = nil;
        
        switch (defaultRowIndex) {
            case FLEXMediumPatchDocumentsFiles:
                titleFuture = ^{
                    return @"ℳ By pass login";
                };
                viewControllerFuture = ^{
                    return [[UIViewController alloc] init];
                };
                break;
            case FLEXMediumDisableCookie:
                
                titleFuture = ^{
                    return @"ℳ 3 reads -> Unlimited read";
                };
                
                if (patchedMediumUnlimitedRead) {
                    titleFuture = ^{
                        return @"ℳ Unlimited read -> 3 reads";
                    };
                }
                
                viewControllerFuture = ^{
                    return [[UIViewController alloc] init];
                };
                break;
            case FLEXMediumRowCount:
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
        self.title = @"ℳ Medium";
        [self updateEntries];
    }
    return self;
}

- (void)updateEntries {
    _entries = [[[self class] defaultGlobalEntries] arrayByAddingObjectsFromArray:[FLEXManager sharedManager].userGlobalEntries];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        case FLEXMediumPatchDocumentsFiles:
            [self copyMediumFilesToDocumentsFolders];
            break;
        case FLEXMediumDisableCookie:
            [self disableMediumRequestCookie];
            break;
        case FLEXMediumRowCount:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self updateEntries];
    [tableView reloadData];
}

#pragma mark - Inject methods

// Remove Medium files/folders inside Documents folder
- (void) removeDocuments
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //    NSString *cacheDir = [docDir stringByAppendingPathComponent: @"cacheDir"];
    
    // check if cache dir exists
    
    // get all files in this directory
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *fileList = [fm contentsOfDirectoryAtPath: docDir error: nil];
    
    // remove
    for(NSInteger i = 0; i < [fileList count]; ++i)
    {
        NSString *fp =  [fileList objectAtIndex: i];
        NSString *remPath = [docDir stringByAppendingPathComponent: fp];
        [fm removeItemAtPath: remPath error: nil];
    }
}

- (void)copyMediumFilesToDocumentsFolders {
    [self removeDocuments];
    
    NSString *zipPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"medium_documents_content" ofType:@"zip"];
    NSString *destinationPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSLog(@"== FLEX bundle zip path: %@", zipPath);
    NSLog(@"== Destination zip path: %@", destinationPath);
    
    [SSZipArchive unzipFileAtPath:zipPath toDestination:destinationPath];
}

- (void)_moddedSetHeader:(NSString *) headerValue withName: (NSString *) name {
    NSLog(@"_moddedSetHeader headerValue = %@, headerName = %@", headerValue, name);
    
    // find NetRequest object and check if ivar path is ending with location, then we should not
    NSMutableArray *netRequestObjects = [FLEXHeapEnumerator instancesForClassName:@"NetRequest"];
    NSLog(@"NetRequest: Number of NetRequest instances: %lu", (unsigned long)[netRequestObjects count]);
    if ([netRequestObjects count] == 0) {
        [FLEXUtility showAlert:@"NetRequest" message:@"Could not find any instances of NetRequest"];
        return;
    }
    
    for (NSObject* netRequestObj in netRequestObjects)
    {
        Ivar pathIvar = class_getInstanceVariable([netRequestObj class], "_path");
        if (pathIvar == NULL) {
            NSLog(@"NetRequest: pathIvar is NULL!!! Do nothing");
            return;
        }
        NSString *requestPath = object_getIvar(netRequestObj, pathIvar);
        NSLog(@"NetRequest: _path ivar value = %@", requestPath);
        if (requestPath == NULL) {
            NSLog(@"NetRequest: requestPath is null, do nothing!!!!");
            return;
        }
        
        if ([@"Cookie" isEqualToString:name]) {
            if ([requestPath hasSuffix:@"location"]) {
                [self _moddedSetHeader:headerValue withName:name]; // call original method
            } else {
                NSLog(@"_moddedSetHeader headerName = Cookie => do nothing");
            }
        } else {
            [self _moddedSetHeader:headerValue withName:name]; // call original method
        }
        
        //        if ([@"Cookie" isEqualToString:name] && ![requestPath hasSuffix:@"location"]) {
        //            NSLog(@"_moddedSetHeader headerName = Cookie => do nothing");
        //            return;
        //        }
        //
        //        [self _moddedSetHeader:headerValue withName:name];
    }
    
    //    NSObject *netRequestObj = [netRequestObjects objectAtIndex:0];
    //
    //    Ivar pathIvar = class_getInstanceVariable([netRequestObj class], "_path");
    //    assert(pathIvar);
    //    NSString *requestPath = object_getIvar(netRequestObj, pathIvar);
    //    NSLog(@"NetRequest: _path ivar value = %@", requestPath);
    //    if (requestPath == NULL) {
    //        NSLog(@"NetRequest: requestPath is null, do nothing!!!!");
    //        return;
    //    }
    //
    //    if ([@"Cookie" isEqualToString:name] && ![requestPath hasSuffix:@"location"]) {
    //        NSLog(@"_moddedSetHeader headerName = Cookie => do nothing");
    //        return;
    //    }
    //
    //    [self _moddedSetHeader:headerValue withName:name];
}

- (void)disableMediumRequestCookie
{
    SEL originalSelector = NSSelectorFromString(@"setHeader:withName:");
    SEL swizzledSelector = NSSelectorFromString(@"_moddedSetHeader:withName:");
    
    Class netRequestClass = NSClassFromString(@"NetRequest");
    Method originalMethod = class_getInstanceMethod(netRequestClass, originalSelector);
    if (!originalMethod) {
        NSLog(@"hangtag could not find setHeader:withName: from NetRequest class");
        return;
    }
    Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
    if (!swizzledMethod) {
        NSLog(@"hangtag could not find  _moddedSetHeader:withName: from FLEX8MediumModTableViewController class");
        return;
    }
    
    BOOL didAddMethod =
    class_addMethod(netRequestClass,
                    swizzledSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    //        if (didAddMethod) {
    //            NSLog(@"hangtag did add method, replaced originalMethod with swizzedselector");
    //            class_replaceMethod(userInfoClass,
    //                                swizzledSelector,
    //                                method_getImplementation(originalMethod),
    //                                method_getTypeEncoding(originalMethod));
    //        } else {
    //            NSLog(@"hangtag method existed, exchanged originalMethod with swizzedselector");
    //            method_exchangeImplementations(originalMethod, swizzledMethod);
    //
    //            NSString *title = @"Patched Medium Successfully!";
    //            NSString *message = @"Now you can read unlimited Medium articles on iOS!";
    //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //            [alert show];
    //        }
    
    NSLog(@"hangtag did add method, replaced originalMethod with swizzedselector");
    class_replaceMethod(netRequestClass,
                        swizzledSelector,
                        method_getImplementation(originalMethod),
                        method_getTypeEncoding(originalMethod));
    
    NSLog(@"hangtag method existed, exchanged originalMethod with swizzedselector");
    method_exchangeImplementations(originalMethod, swizzledMethod);
    
    [FLEXUtility showAlert:@"Patched Medium Successfully!" message:@"Now you can read unlimited Medium articles on iOS!"];
    
    patchedMediumUnlimitedRead = !patchedMediumUnlimitedRead;
}

@end
