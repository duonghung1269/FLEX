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
#import <SSZipArchive/SSZipArchive.h>

typedef NS_ENUM(NSUInteger, FLEX8BallPoolModRow) {
    FLEX8BallPoolRowGuideline,
    FLEX8BallPoolRowSendSelectedCue,
    FLEX8BallPoolRowSendShowGuideline,
    FLEXSPByPassSSLPinning,
    FLEXTapToHideKeyBoard,
    FLEXMediumPatchDocumentsFiles,
    FLEXMediumDisableCookie,
    FLEX8BallPoolRowCount,
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
            case FLEXSPByPassSSLPinning:
                titleFuture = ^{
                    return @"By pass SSL Pinning";
                };
                viewControllerFuture = ^{
                    return [[UIViewController alloc] init];
                };
                break;
            case FLEXTapToHideKeyBoard:
                titleFuture = ^{
                    return @"Hook tap view to hide keyboard";
                };
                viewControllerFuture = ^{
                    return [[UIViewController alloc] init];
                };
                break;
            case FLEXMediumPatchDocumentsFiles:
                titleFuture = ^{
                    return @"Medium by pass login";
                };
                viewControllerFuture = ^{
                    return [[UIViewController alloc] init];
                };
                break;
            case FLEXMediumDisableCookie:
                titleFuture = ^{
                    return @"Medium unlimited read";
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
        case FLEXSPByPassSSLPinning:
            [self injectSPByPassSSLPinning];
            break;
        case FLEXTapToHideKeyBoard:
//            [self injectTapViewHideKeyBoard];
            break;
        case FLEXMediumPatchDocumentsFiles:
            [self copyMediumFilesToDocumentsFolders];
            break;
        case FLEXMediumDisableCookie:
            [self disableMediumRequestCookie];
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

- (void) _moddedURLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    NSLog(@"8ball._moddedURLSession called to by pass ssl pinning");
    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);    
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

// TODO: this one currently not take effect
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

- (void)injectSPByPassSSLPinning {
    SEL originalSelector = NSSelectorFromString(@"URLSession:didReceiveChallenge:completionHandler:");
        SEL swizzledSelector = NSSelectorFromString(@"_moddedURLSession:didReceiveChallenge:completionHandler:");
    
    Class urlSessionDelegateClass = NSClassFromString(@"infinity.InfinityAuthenticationUrlSessionDelegate");
    Method originalMethod = class_getInstanceMethod(urlSessionDelegateClass, originalSelector);
        if (!originalMethod) {
            NSLog(@"8ball could not find URLSession:didReceiveChallenge:completionHandler: from InfinityAuthenticationUrlSessionDelegate class");
            return;
        }
        Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
        if (!swizzledMethod) {
            NSLog(@"8ball could not find _moddedURLSession:didReceiveChallenge:completionHandler: from FLEX8BallPoolModTableViewController class");
            return;
        }
    
        BOOL didAddMethod =
        class_addMethod(urlSessionDelegateClass,
                        swizzledSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
    
        if (didAddMethod) {
            NSLog(@"8ball did add method, replaced originalMethod with swizzedselector");
            class_replaceMethod(urlSessionDelegateClass,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            NSLog(@"8ball method existed, exchanged originalMethod with swizzedselector");
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    
//    typedef int (^ModdedAimForCue)(int);
//    ModdedAimForCue implementationBlock = ^int(int cueId) {
//        NSLog(@"8ball._moddedGetAimForCue called, original aim value = %ul", cueId);
//        return 75;
//    };
//
//    [FLEXUtility replaceImplementationOfKnownSelector:originalSelector onClass:userInfoClass withBlock:implementationBlock swizzledSelector:[FLEXUtility swizzledSelectorForSelector:originalSelector]];
//    }
    
}

- (void)injectTapViewHideKeyBoard {
    SEL viewDidLoadSelector = @selector(viewDidLoad:);
    SEL viewDidLoadHidKeyBoardSelector = @selector(injectTapViewHideKeyBoard_viewDidLoad:);
    Method originalMethod = class_getInstanceMethod(self, viewDidLoadSelector);
    Method extendedMethod = class_getInstanceMethod(self, viewDidLoadHidKeyBoardSelector);
    method_exchangeImplementations(originalMethod, extendedMethod);
}

- (void) injectTapViewHideKeyBoard_viewDidLoad:(BOOL)animated {
    [self injectTapViewHideKeyBoard_viewDidLoad:animated];
    NSLog(@"injectedTapViewHideKeyBoard viewDidLoad for %@", [self class]);
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)dismissKeyboard {
    [self.view endEditing:true];
}

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
//        assert(pathIvar);
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
            NSLog(@"hangtag could not find  _moddedSetHeader:withName: from FLEX8BallPoolModTableViewController class");
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
    
}

@end


