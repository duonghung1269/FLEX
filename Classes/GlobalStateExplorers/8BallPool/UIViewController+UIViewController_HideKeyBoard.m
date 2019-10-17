//
//  UIViewController+UIViewController_HideKeyBoard.m
//  FLEX
//
//  Created by Dang Duong Hung on 14/9/19.
//  Copyright © 2019 Flipboard. All rights reserved.
//

#import "UIViewController+UIViewController_HideKeyBoard.h"
#import <objc/runtime.h>

@implementation UIViewController (UIViewController_HideKeyBoard)

+ (void)load {
    static dispatch_once_t once_token;
    dispatch_once(&once_token,  ^{
        SEL viewDidLoadSelector = @selector(viewDidLoad:);
        SEL viewDidLoadHidKeyBoardSelector = @selector(injectTapViewHideKeyBoard_viewDidLoad:);
        Method originalMethod = class_getInstanceMethod(self, viewDidLoadSelector);
        Method extendedMethod = class_getInstanceMethod(self, viewDidLoadHidKeyBoardSelector);
        method_exchangeImplementations(originalMethod, extendedMethod);
    });
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

@end
