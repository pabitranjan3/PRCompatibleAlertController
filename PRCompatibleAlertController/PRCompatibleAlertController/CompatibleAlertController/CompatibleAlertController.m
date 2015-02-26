//
//  CompatibleAlertController.m
//  PRCompatibleAlertController
//
//  Created by Pabitr on 26/02/15.
//  Copyright (c) 2015 BlackCode. All rights reserved.
//

#import "CompatibleAlertController.h"

#pragma mark
#pragma mark --- CompatibleAlertAction ---

@interface CompatibleAlertAction ()

@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) CompatibleAlertActionStyle style;

@end

@implementation CompatibleAlertAction

+ (instancetype)compatibleActionWithTitle:(NSString *)title
                                    style:(CompatibleAlertActionStyle)style
                                  handler:(void (^)(CompatibleAlertAction *action))handler;
{
    CompatibleAlertAction *compatibleAction = [[CompatibleAlertAction alloc] initWithTitle:title
                                                                                     style:style
                                                                                   handler:^(CompatibleAlertAction *action) {
                                                                                   }];
    return compatibleAction;
}
- (instancetype)initWithTitle:(NSString *)title
                        style:(CompatibleAlertActionStyle)style
                      handler:(void (^)(CompatibleAlertAction *action))handler
{
    if (self == [super init]) {
        _title = title;
        _style = style;
        _compatibleHandler = handler;
    }
    return self;
}

@end

#pragma mark
#pragma mark --- @End --- CompatibleAlertAction ---

#pragma mark
#pragma mark --- CompatibleAlertController ---

@interface CompatibleAlertController ()
{
    UIAlertController *compatibleAlertController;
    UIAlertView *compatibleAlertView;
}
@property (nonatomic, readwrite) NSMutableArray *actions;
@property (nonatomic, readwrite) CompatibleAlertControllerStyle preferredStyle;
@end


@implementation CompatibleAlertController

+ (instancetype)compatibleAlertControllerWithTitle:(NSString *)title
                                           message:(NSString *)message
                                     preferedStyle:(CompatibleAlertControllerStyle)preferedStyle
{
    CompatibleAlertController *compatibleController = [[CompatibleAlertController alloc] initWithTitle:title
                                                                                               message:message
                                                                                        preferredStyle:preferedStyle];
    return compatibleController;
}
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
               preferredStyle:(CompatibleAlertControllerStyle)preferedStyle
{
    if (self == [super init]) {
        
        _title = title;
        _message = message;
        _actions = [[NSMutableArray alloc] init];
        _preferredStyle = preferedStyle;
        if ([UIAlertController class])
            compatibleAlertController = [UIAlertController alertControllerWithTitle:self.title
                                                                            message:self.message
                                                                     preferredStyle:UIAlertControllerStyleAlert];
        else
            compatibleAlertView = [[UIAlertView alloc] initWithTitle:self.title
                                                             message:self.message
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:nil];
    }
    return self;
}
- (void)presentCompatibleAlertController:(UIViewController *)viewControllerToPresent
                                animated: (BOOL)flag
                              completion:(void (^)(void))completion{
    switch (_preferredStyle) {
        case CompatibleAlertControllerStyleActionSheet :
        {
            [self createActionSheetController:viewControllerToPresent animated:flag completion:^{
                if (completion)completion();
            }];
        }
            break;
        case CompatibleAlertControllerStyleAlert:
        default:
            [self createAlertController:viewControllerToPresent animated:flag completion:^{
                if (completion)completion();
            }];
            break;
    }
}

- (void)addAction:(CompatibleAlertAction *)action{
    [self.actions addObject:action];
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler{
    if ([UIAlertController class])
        [compatibleAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            if(configurationHandler)configurationHandler(textField);
        }];
    else
        [compatibleAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
}

#pragma mark
#pragma mark --- Support methods ---

-(UIAlertAction*)createAlertAction:(CompatibleAlertAction*)compatibleAction{
    
    UIAlertActionStyle alertStyle;
    switch (compatibleAction.style) {
        case CompatibleAlertActionStyleDefault:
            alertStyle = UIAlertActionStyleDefault;
            break;
        case CompatibleAlertActionStyleCancel:
            alertStyle = UIAlertActionStyleCancel;
            break;
        case CompatibleAlertActionStyleDestructive:
            alertStyle = UIAlertActionStyleDestructive;
            break;
        default:
            break;
    }
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:compatibleAction.title
                                                          style:alertStyle
                                                        handler:^(UIAlertAction *defaultAction) {
                                                            if (compatibleAction.compatibleHandler)
                                                                compatibleAction.compatibleHandler(compatibleAction);
                                                        }];
    return alertAction;
}

#pragma mark
#pragma mark ---  UIAlertView ---

-(void)createAlertController:(UIViewController *)viewControllerToPresent
                    animated: (BOOL)flag
                  completion:(void (^)(void))completion{
    
    if ([UIAlertController class]) {
        for (CompatibleAlertAction *compatibleAction in self.actions)
            [compatibleAlertController addAction:[self createAlertAction:compatibleAction]];
        [viewControllerToPresent presentViewController:compatibleAlertController
                                              animated:flag
                                            completion:^{
                                                if (completion)completion();
                                            }];
    }
    else
    {
        for (CompatibleAlertAction *compatibleAction in self.actions)
            [compatibleAlertView addButtonWithTitle:compatibleAction.title];
        [compatibleAlertView show];
        if (completion)completion();
    }
}
#pragma mark
#pragma mark -- UIAlertView Delegate ---
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    CompatibleAlertAction *compatibleAction = [self.actions objectAtIndex:buttonIndex];
    if (compatibleAction.compatibleHandler)
        compatibleAction.compatibleHandler(compatibleAction);
}

#pragma mark
#pragma mark ---  UIActionSheet ---

-(void)createActionSheetController:(UIViewController *)viewControllerToPresent
                          animated: (BOOL)flag
                        completion:(void (^)(void))completion{
    
    if ([UIAlertController class]) {
        compatibleAlertController = [UIAlertController alertControllerWithTitle:self.title
                                                                        message:self.message
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
        for (CompatibleAlertAction *compatibleAction in self.actions)
            [compatibleAlertController addAction:[self createAlertAction:compatibleAction]];
        [viewControllerToPresent presentViewController:compatibleAlertController
                                              animated:flag
                                            completion:^{
                                                if (completion)completion();
                                            }];
    }else{
        __block NSString *cancel = nil;
        __block NSString *destructive = nil;
        __block NSMutableArray *otherButtons = [[NSMutableArray alloc] init];
        [self.actions enumerateObjectsUsingBlock:^(CompatibleAlertAction *compatibleAction, NSUInteger idx, BOOL *stop) {
            switch (compatibleAction.style) {
                case CompatibleAlertActionStyleDefault:
                    [otherButtons addObject:compatibleAction.title];
                    break;
                case CompatibleAlertActionStyleCancel:
                    cancel = compatibleAction.title;
                    break;
                case CompatibleAlertActionStyleDestructive:
                    destructive = compatibleAction.title;
                default:
                    break;
            }
        }];
        UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:self.title
                                                              delegate:self
                                                     cancelButtonTitle:cancel
                                                destructiveButtonTitle:destructive
                                                     otherButtonTitles:nil];
        for (NSString *otherButton in otherButtons)
            [actionSheet addButtonWithTitle:otherButton];
        [actionSheet showInView:viewControllerToPresent.view];
        if (completion)completion();
    }
}

#pragma mark
#pragma mark -- UIActionSheet Delegate ---
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *string = [actionSheet buttonTitleAtIndex:buttonIndex];
    for (CompatibleAlertAction *compatibleAction in self.actions) {
        if ([string isEqualToString:compatibleAction.title])
        {
            if (compatibleAction.compatibleHandler)
                compatibleAction.compatibleHandler(compatibleAction);
            break;
        }
    }
}
@end

#pragma mark
#pragma mark --- @End --- CompatibleAlertController ---

