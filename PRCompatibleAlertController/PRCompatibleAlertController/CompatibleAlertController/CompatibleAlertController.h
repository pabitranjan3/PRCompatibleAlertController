//
//  CompatibleAlertController.h
//  PRCompatibleAlertController
//
//  Created by Pabitr on 26/02/15.
//  Copyright (c) 2015 BlackCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CompatibleAlertActionStyle) {
    CompatibleAlertActionStyleDefault = 0,
    CompatibleAlertActionStyleCancel,
    CompatibleAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, CompatibleAlertControllerStyle) {
    CompatibleAlertControllerStyleActionSheet = 0,
    CompatibleAlertControllerStyleAlert
};

@class CompatibleAlertAction;
@class CompatibleAlertController;

typedef void (^CompatibleAlertActionHandler)(CompatibleAlertAction*);

@interface CompatibleAlertAction : NSObject

+ (instancetype)compatibleActionWithTitle:(NSString *)title
                                    style:(CompatibleAlertActionStyle)style
                                  handler:(void (^)(CompatibleAlertAction *action))handler;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) CompatibleAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;
@property (nonatomic, copy) CompatibleAlertActionHandler compatibleHandler;

@end


@interface CompatibleAlertController : NSObject<UIAlertViewDelegate,UIActionSheetDelegate>

+ (instancetype)compatibleAlertControllerWithTitle:(NSString *)title
                                           message:(NSString *)message
                                     preferedStyle:(CompatibleAlertControllerStyle)preferedStyle;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

- (void)addAction:(CompatibleAlertAction *)action;
@property (nonatomic, readonly) NSMutableArray *actions;

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;
@property (nonatomic, readonly) NSArray *textFields;

- (void)presentCompatibleAlertController:(UIViewController *)viewControllerToPresent
                                animated: (BOOL)flag
                              completion:(void (^)(void))completion;

@end
