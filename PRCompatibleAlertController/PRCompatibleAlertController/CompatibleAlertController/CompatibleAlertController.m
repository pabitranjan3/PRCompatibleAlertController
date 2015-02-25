//
//  CompatibleAlertController.m
//  PRCompatibleAlertController
//
//  Created by Pabitr on 26/02/15.
//  Copyright (c) 2015 BlackCode. All rights reserved.
//

#import "CompatibleAlertController.h"

@interface CompatibleAlertController ()
{
    UIAlertController *alertController;
    UIAlertView *compatibleAlertView;
}
@end


@implementation CompatibleAlertAction

- (instancetype)initWithTitle:(NSString *)title style:(CompatibleAlertActionStyle)style handler:(void (^)(CompatibleAlertAction *action))handler
{
    if (self == [super init]) {
        
        _title = title;
        _style = style;
        _compatibleHandler = handler;
        
    }
    return self;
}

@end

@implementation CompatibleAlertController

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(CompatibleAlertControllerStyle)preferredStyle
{
    if (self == [super init]) {
        
        _title = title;
        _message = message;
        _preferredStyle = preferredStyle;
        _actions = [[NSMutableArray alloc] init];
        if ([UIAlertController class]) {
            alertController = [UIAlertController alertControllerWithTitle:self.title message:self.message preferredStyle:UIAlertControllerStyleAlert];
        }
        else
        {
            compatibleAlertView = [[UIAlertView alloc] initWithTitle:self.title
                                                             message:self.message
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:nil];
        }
        
    }
    return self;
}


- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler
{
    if ([UIAlertController class])
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            if(configurationHandler)configurationHandler(textField);
        }];
    else
        [compatibleAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
}

- (void)presentCompatibleAlertController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^)(void))completion
{
    switch (self.preferredStyle) {
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

- (void)addAction:(CompatibleAlertAction *)action
{
    [self.actions addObject:action];
}


#pragma mark ---  UIActionSheet ---

-(void)createActionSheetController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^)(void))completion
{
    if ([UIAlertController class]) {
        
        alertController = [UIAlertController alertControllerWithTitle:self.title message:self.message preferredStyle:UIAlertControllerStyleActionSheet];
        for (CompatibleAlertAction *compatibleAction in self.actions) {
            
            switch (compatibleAction.style) {
                case CompatibleAlertActionStyleDefault:
                {
                    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:compatibleAction.title style:UIAlertActionStyleDefault handler:^(UIAlertAction *defaultAction) {
                        if (compatibleAction.compatibleHandler)
                            compatibleAction.compatibleHandler(compatibleAction);
                    }];
                    [alertController addAction:defaultAction];
                }
                    break;
                    
                case CompatibleAlertActionStyleCancel:
                {
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:compatibleAction.title style:UIAlertActionStyleCancel handler:^(UIAlertAction *cancelAction) {
                        if (compatibleAction.compatibleHandler)
                            compatibleAction.compatibleHandler(compatibleAction);
                    }];
                    [alertController addAction:cancelAction];
                }
                    break;
                case CompatibleAlertActionStyleDestructive:
                {
                    UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:compatibleAction.title style:UIAlertActionStyleDestructive handler:^(UIAlertAction *destructiveAction) {
                        if (compatibleAction.compatibleHandler)
                            compatibleAction.compatibleHandler(compatibleAction);
                    }];
                    [alertController addAction:destructiveAction];
                }
                default:
                    break;
            }
        }
        [viewControllerToPresent presentViewController:alertController animated:flag completion:^{
            if (completion)completion();
        }];
        
    }
    else
    {
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
        UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:self.title delegate:self cancelButtonTitle:cancel destructiveButtonTitle:destructive otherButtonTitles:nil];
        for (NSString *otherButton in otherButtons)
            [actionSheet addButtonWithTitle:otherButton];
        [actionSheet showInView:viewControllerToPresent.view];
        if (completion)completion();
        
    }
    
}

#pragma mark ---  UIAlertView ---

-(void)createAlertController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^)(void))completion
{
    if ([UIAlertController class]) {
        
        
        
        for (CompatibleAlertAction *compatibleAction in self.actions) {
            
            switch (compatibleAction.style) {
                case CompatibleAlertActionStyleDefault:
                {
                    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:compatibleAction.title style:UIAlertActionStyleDefault handler:^(UIAlertAction *defaultAction) {
                        if (compatibleAction.compatibleHandler)
                            compatibleAction.compatibleHandler(compatibleAction);
                    }];
                    [alertController addAction:defaultAction];
                }
                    break;
                    
                case CompatibleAlertActionStyleCancel:
                {
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:compatibleAction.title style:UIAlertActionStyleCancel handler:^(UIAlertAction *cancelAction) {
                        if (compatibleAction.compatibleHandler)
                            compatibleAction.compatibleHandler(compatibleAction);
                    }];
                    [alertController addAction:cancelAction];
                }
                    break;
                case CompatibleAlertActionStyleDestructive:
                {
                    UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:compatibleAction.title style:UIAlertActionStyleDestructive handler:^(UIAlertAction *destructiveAction) {
                        if (compatibleAction.compatibleHandler)
                            compatibleAction.compatibleHandler(compatibleAction);
                    }];
                    [alertController addAction:destructiveAction];
                }
                default:
                    break;
            }
        }
        [viewControllerToPresent presentViewController:alertController animated:flag completion:^{
            if (completion)completion();
        }];
        
    }
    else
    {
        
        
        for (CompatibleAlertAction *compatibleAction in self.actions) {
            [compatibleAlertView addButtonWithTitle:compatibleAction.title];
        }
        
        [compatibleAlertView show];
        if (completion)completion();
    }
}

#pragma mark -- UIAlertView Delegate ---


// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    CompatibleAlertAction *compatibleAction = [self.actions objectAtIndex:buttonIndex];
    if (compatibleAction.compatibleHandler)
        compatibleAction.compatibleHandler(compatibleAction);
}

#pragma mark -- UIActionSheet Delegate ---
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    NSString *string = [actionSheet buttonTitleAtIndex:buttonIndex];
    for (CompatibleAlertAction *compatibleAction in self.actions) {
        if ([string isEqualToString:compatibleAction.title])
        {
            if (compatibleAction.compatibleHandler) compatibleAction.compatibleHandler(compatibleAction);
            break;
        }
    }
    
    
}
@end

