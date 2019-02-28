//
//  FLEX8BallPoolModTableViewController.m
//  FLEX
//
//  Created by Dang Duong Hung on 15/1/19.
//  Copyright © 2019 Flipboard. All rights reserved.
//

#import "FLEX8BallPoolModTableViewController.h"
#import "FLEXUtility.h"
#import "FLEXHeapEnumerator.h"
#import "FLEXManager+Private.h"
#import "FLEXGlobalsTableViewControllerEntry.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger, FLEX8BallPoolModRow) {
    FLEX8BallPoolRowGuideline,
    FLEX8BallPoolRowSendSelectedCue,
    FLEX8BallPoolRowSendShowGuideline,    
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
            case FLEX8BallPoolRowSendSelectedCue:
                titleFuture = ^{
                    return @"🎱 Set Selected Cue - Archon";
                };
                viewControllerFuture = ^{
                    return [[UIViewController alloc] init];
                };
                break;
            case FLEX8BallPoolRowSendShowGuideline:
                titleFuture = ^{
                    return @"🎱 Show Guideline mode";
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
        case FLEX8BallPoolRowSendSelectedCue:
            [self injectSetSelectedCue];
            break;
        case FLEX8BallPoolRowSendShowGuideline:
            [self injectShowGuidelineMode];
            break;
        case FLEX8BallPoolRowCount:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    UIViewController *viewControllerToPush = [self viewControllerToPushForRowAtIndexPath:indexPath];
//
//    [self.navigationController pushViewController:viewControllerToPush animated:YES];
}

#pragma mark - Inject methods

- (int) _moddedGetAimForCue:(int)arg {
    NSLog(@"8ball._moddedGetAimForCue called, original cue value = %ul", arg);
    return 200;
}

- (void) _moddedSendSelectedCue:(int)arg {
    [self _moddedSendSelectedCue:200];
    NSLog(@"8ball._moddedSendSelectedCue called, original cue value = %ul", arg);
}

- (void)injectInfiniteGuideline
{
    SEL originalSelector = NSSelectorFromString(@"getAimForCue:");
//    SEL swizzledSelector = NSSelectorFromString(@"_moddedGetAimForCue:");
    
    Class userInfoClass = NSClassFromString(@"UserInfo");
//    Method originalMethod = class_getInstanceMethod(userInfoClass, originalSelector);
//    if (!originalMethod) {
//        NSLog(@"8ball could not find getAimForCue: from UserInfo class");
//        return;
//    }
//    Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
//    if (!swizzledMethod) {
//        NSLog(@"8ball could not find _moddedGetAimForCue: from FLEX8BallPoolModTableViewController class");
//        return;
//    }
//
//    BOOL didAddMethod =
//    class_addMethod(userInfoClass,
//                    swizzledSelector,
//                    method_getImplementation(swizzledMethod),
//                    method_getTypeEncoding(swizzledMethod));
//
//    if (didAddMethod) {
//        NSLog(@"8ball did add method, replaced originalMethod with swizzedselector");
//        class_replaceMethod(userInfoClass,
//                            swizzledSelector,
//                            method_getImplementation(originalMethod),
//                            method_getTypeEncoding(originalMethod));
//    } else {
//        NSLog(@"8ball method existed, exchanged originalMethod with swizzedselector");
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
//
    typedef int (^ModdedAimForCue)(int);
    ModdedAimForCue implementationBlock = ^int(int cueId) {
        NSLog(@"8ball._moddedGetAimForCue called, original aim value = %ul", cueId);
        return 75;
    };
    
    [FLEXUtility replaceImplementationOfKnownSelector:originalSelector onClass:userInfoClass withBlock:implementationBlock swizzledSelector:[FLEXUtility swizzledSelectorForSelector:originalSelector]];
}

- (void)injectSetSelectedCue {
    NSMutableArray *userInfoObjects = [FLEXHeapEnumerator instancesForClassName:@"UserInfo"];
    if ([userInfoObjects count] == 0) {
        [FLEXUtility showAlert:@"UserInfo" message:@"Could not find any instances of UserInfo"];
        return;
    }
    
    NSObject *userInfoObj = [userInfoObjects objectAtIndex:0];
    
    int archonCueId = 345;
    
    // invoke addOwnCue
    SEL addOwnedCueSelector = NSSelectorFromString(@"addOwnedCue:");
    if ([userInfoObj respondsToSelector:addOwnedCueSelector]) {
        // Cant use performSelector as int is not object type, so use NSInvocation instead
        NSMethodSignature *signature = [userInfoObj methodSignatureForSelector:addOwnedCueSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setSelector:addOwnedCueSelector];
        [invocation setArgument:&archonCueId atIndex:2]; // 0 and 1 are reserved
        [invocation invokeWithTarget:userInfoObj];
        
        [FLEXUtility showAlert:@"Success" message:@"Invoke addOwnedCue successfully!!"];
    }
    
    // invoke addOwnedCue shouldStoreLocally
    SEL addOwnedCueStoreLocallySelector = NSSelectorFromString(@"addOwnedCue:shouldStoreLocally:");
    if ([userInfoObj respondsToSelector:addOwnedCueStoreLocallySelector]) {
        NSMethodSignature *signature = [userInfoObj methodSignatureForSelector:addOwnedCueStoreLocallySelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setSelector:addOwnedCueStoreLocallySelector];
        BOOL storeLocally = YES;
        [invocation setArgument:&archonCueId atIndex:2]; // 0 and 1 are reserved
        [invocation setArgument:&storeLocally atIndex:3];
        [invocation invokeWithTarget:userInfoObj];
        [FLEXUtility showAlert:@"Success" message:@"Invoke addOwnedCue store locally successfully!!"];
    }
    
    NSMutableArray *networkHandlerObjects = [FLEXHeapEnumerator instancesForClassName:@"NetworkHandler"];
    if ([networkHandlerObjects count] == 0) {
        [FLEXUtility showAlert:@"NetworkHandler" message:@"Could not find any instances of NetworkHandler"];
        return;
    }
    
    NSObject *networkHandlerObj = [networkHandlerObjects objectAtIndex:0];
    
    // invoke addOwnCue
    SEL sendSelectedCueSelector = NSSelectorFromString(@"sendSelectedCue:");
    if ([networkHandlerObj respondsToSelector:sendSelectedCueSelector]) {
        NSMethodSignature *signature = [networkHandlerObj methodSignatureForSelector:sendSelectedCueSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setSelector:sendSelectedCueSelector];
        [invocation setArgument:&archonCueId atIndex:2]; // 0 and 1 are reserved
        [invocation invokeWithTarget:networkHandlerObj];
        
        [FLEXUtility showAlert:@"Success" message:@"Invoke sendSelectedCue successfully!!"];
    }

}

- (void) injectShowGuidelineMode {
    // GameManager
    NSMutableArray *gameManagerObjects = [FLEXHeapEnumerator instancesForClassName:@"GameManager"];
    if ([gameManagerObjects count] == 0) {
        [FLEXUtility showAlert:@"GameManager" message:@"Could not find any instances of GameManager"];
        return;
    }
    
    NSObject *gameManagerObj = [gameManagerObjects objectAtIndex:0];
    
    Ivar ivar = class_getInstanceVariable([gameManagerObj class], "mHideGuidelinesMode");
    assert(ivar);
    CFTypeRef gameManagerObjRef = CFBridgingRetain(gameManagerObj);
    BOOL *ivarPtr = (BOOL *)((uint8_t *)gameManagerObjRef + ivar_getOffset(ivar));
    *ivarPtr = FALSE;
    CFBridgingRelease(gameManagerObjRef);
    [FLEXUtility showAlert:@"Success" message:@"Patched GameManager.mHideGuidelinesMode to false successfully!"];
    
    // VisualCue
    NSMutableArray *visualCueObjects = [FLEXHeapEnumerator instancesForClassName:@"VisualCue"];
    if ([visualCueObjects count] == 0) {
        [FLEXUtility showAlert:@"VisualCue" message:@"Could not find any instances of VisualCue"];
        return;
    }
    
    NSObject *visualCueObj = [visualCueObjects objectAtIndex:0];
    
    Ivar ivarVisualCue = class_getInstanceVariable([visualCueObj class], "mHideGuidelinesMode");
    assert(ivarVisualCue);
    CFTypeRef visualCueObjRef = CFBridgingRetain(visualCueObj);
    BOOL *ivarPtrVisualCue = (BOOL *)((uint8_t *)visualCueObjRef + ivar_getOffset(ivarVisualCue));
    *ivarPtrVisualCue = FALSE;
//    CFBridgingRelease(visualCueObjRef);
    [FLEXUtility showAlert:@"Success" message:@"Patched VisualCue.mHideGuidelinesMode to false successfully!"];
    
    // set mDrawInputInDirectionOfBall = true
    Ivar ivarDrawInputInDirectionOfBall = class_getInstanceVariable([visualCueObj class], "mDrawInputInDirectionOfBall");
    assert(ivarDrawInputInDirectionOfBall);
    BOOL *ivarDrawInputInDirectionOfBallPtr = (BOOL *)((uint8_t *)visualCueObjRef + ivar_getOffset(ivarDrawInputInDirectionOfBall));
    *ivarDrawInputInDirectionOfBallPtr = TRUE;
    
    // set mDrawMultiplierRanges = true
    Ivar ivarDrawMultiplierRanges = class_getInstanceVariable([visualCueObj class], "mDrawMultiplierRanges");
    assert(ivarDrawMultiplierRanges);
    BOOL *ivarDrawMultiplierRangesPtr = (BOOL *)((uint8_t *)visualCueObjRef + ivar_getOffset(ivarDrawMultiplierRanges));
    *ivarDrawMultiplierRangesPtr = TRUE;
    
    // invoke draw
    SEL drawSelector = NSSelectorFromString(@"draw");
    if ([visualCueObj respondsToSelector:drawSelector]) {
        NSMethodSignature *signature = [visualCueObj methodSignatureForSelector:drawSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setSelector:drawSelector];
        [invocation invokeWithTarget:visualCueObj];
    }
    
    CFBridgingRelease(visualCueObjRef);
}

@end


