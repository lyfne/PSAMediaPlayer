//
//  PSAMusicCreateListViewController.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-10-13.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MusicCreateDelegate

- (void)ListReloadData;

@end

@interface PSAMusicCreateListViewController : UIViewController<UITextFieldDelegate>{
    BOOL backToUpside;
}

@property (weak, nonatomic) id<MusicCreateDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *createAlertView;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITextField *listNameTextField;

+ (PSAMusicCreateListViewController *)createMusicCreateListViewController;

- (IBAction)okAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

@end
