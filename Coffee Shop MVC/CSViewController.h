//
//  CSViewController.h
//  Coffee Shop MVC
//
//  Created by John Clem on 1/6/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSViewController : UITableViewController

@property (nonatomic, weak) IBOutlet UILabel *shotCountLabel;
@property (nonatomic, weak) IBOutlet UITextView *drinkSummaryTextView;

- (IBAction)orderButtonTapped:(id)sender;
- (IBAction)modifyShots:(id)sender;
- (IBAction)changeDrinkOptions:(id)sender;

@end
