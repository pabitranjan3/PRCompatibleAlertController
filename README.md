# PRCompatibleAlertController
Compatible(&lt;= iOS8)  UIAlertController written in Objective C 


iOS 8 included the new UIAlertController which is upgrading the UIAlertView; 
however, if your app is still supporting lower version of iOS 8, like most of us are, then you still need to use UIAlertViews.


 CompatibleAlertController is supporting  iOS 8 & lower version and it emulates the UIAlertController.

# How to Use
Code samples are provided in the demo project. You'll find this easy, if you're familiar with the UIAlertController.

# Intialize the CompatibleAlertController:
         compatibleAlertController = [CompatibleAlertController compatibleAlertControllerWithTitle:@"TITLE"
                                                                                      message:@"Message" 
                                                                            preferedStyle:CompatibleAlertControllerStyleAlert];

# Add actions/buttons to the compatibleAlertController : 
        CompatibleAlertAction *defalutAction = [CompatibleAlertAction compatibleActionWithTitle:@"DEFAULT"
                                                                                        style:CompatibleAlertActionStyleDefault
                                                                                        handler:^(CompatibleAlertAction*action){
                                                                                            NSLog(@"DEFAULT ....");
                                                                                        }];
        [compatibleAlertController addAction:defalutAction];

 If you want to use another type of button, you can simply use by changing the param for style of CompatibleAlertActionStyle.

# Present the compatibleAlertController:
       [compatibleAlertController presentCompatibleAlertController:self
                                                       animated:YES
                                                     completion:^{
                                                         //DO SOMETHING...
                                                     }];

# To Do
 1.  You need to retain the "CompatibleAlertController" in iOS 7, otherwise when selecting a button from the "UIAlertView" you'll get an exception.
 2.  Tests!
 3.  Probably a lot more! PR's are welcome.

# License
"PRCompatibleAlertController" is licensed under the MIT License. See LICENSE for details.
