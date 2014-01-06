//
//  CSViewController.m
//  Coffee Shop MVC
//
//  Created by John Clem on 1/6/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import "CSViewController.h"
#import "CSDrink.h"

@interface CSViewController ()
{
    CSDrink *currentDrink;
}
@end

@implementation CSViewController

- (void)resetForm
{
    currentDrink = [CSDrink new];
    currentDrink.drinkSize = @"";
    currentDrink.drinkName = @"";
    [_shotCountLabel setText:@"0 Shots"];
    [_drinkSummaryTextView setText:@""];
    
    for (UIControl *control in self.view.subviews) {
        if ([control isKindOfClass:[UISegmentedControl class]]) {
            [(UISegmentedControl *)control setSelectedSegmentIndex:-1];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self resetForm];
}

#pragma mark - IBActions

- (IBAction)orderButtonTapped:(id)sender
{
    NSLog(@"Ordering Drink: %@", currentDrink);
    [self performSelector:@selector(drinkOrderComplete) withObject:nil afterDelay:1.5];
}

- (IBAction)modifyShots:(id)sender
{
    UIStepper *stepper = (UIStepper *)sender;
    [currentDrink setNumberOfShots:stepper.value];
    [_shotCountLabel setText:[NSString stringWithFormat:@"%d Shot(s)", currentDrink.numberOfShots]];
    [_drinkSummaryTextView setText:[self currentDrinkDescription]];
}

- (IBAction)changeDrinkOptions:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    
    switch (segmentedControl.tag) {
        case 0: // Latte | Americano | Espresso
            [currentDrink setDrinkName:[segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex]];
            break;
        case 1: // Hot | Iced
            [currentDrink setIsIced:segmentedControl.selectedSegmentIndex];
            break;
        case 2: // Short | Tall | Grande
            [currentDrink setDrinkSize:[segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex]];
            break;
    }
    
    [_drinkSummaryTextView setText:[self currentDrinkDescription]];
}

- (NSString *)currentDrinkDescription
{
    NSString *icedOrHot = currentDrink.isIced ? @"Iced" : @"Hot";
    
    return [NSString stringWithFormat:@"%@ %@ %@ with %d Shot(s)", currentDrink.drinkSize, icedOrHot, currentDrink.drinkName, currentDrink.numberOfShots];
}

- (void)drinkOrderComplete
{
    NSLog(@"Ordered a %@", [self currentDrinkDescription]);
    [self resetForm];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
