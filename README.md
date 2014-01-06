#iOS Design Patterns by Tutorials Part 1 - MVC

In this series, I'll be taking a look at some of the common design patterns in Cocoa, specifically as they apply to iOS development.

##What are design patterns?

Design patterns aren't hard and fast rules (like proper syntax) but rather, they serve as guiding principles for better software development.  Model-View-Controller, for example, is the practice of organizing your blocks of code into logical containers, based on their functionality and relationship to one another.

Design patterns are a difficult topic to teach, because without a fairly comprehensive understanding of how to write code, design patterns are akin to a coffee house teaching a new barista how to do foam art in a latte before teaching them how to grind the beans and brew the coffee.

To that end, the goal of this series of posts is to give a concrete example in which we'll explore the design pattern at hand within a real-world application and see why it makes our code cleaner, easier to read, more reusable, etc.  We'll also look at some of the anti-patterns and common pitfalls that crop up in lazily written or poorly planned code.

##Model View Controller

Model View Controller (MVC) is quite common in object-oriented programming.  It's the default starting point for frameworks like Ruby on Rails, Cocoa and dozens of Javascript frameworks (checkout <http://todomvc.com> for a comprehensive list).

There are various schools of thought about what goes where in MVC (e.g. fat-model / skinny-controller), but the building blocks for MVC are that the Model contains the code describung how the data is structured, the View displays the data to the user and accepts user-interaction (touches, clicks, etc.) and the Controller serves as the communication hub between them.  

A common visualization of MVC in Cocoa looks something like this:

![Model View Controller Graphic](https://dl.dropboxusercontent.com/u/2027148/img/mvc_diagram.gif)

You can see from the diagram, that we have three categories available for our code.  This is not to say that we'll have 1 model, 1 view and 1 controller; in practice, an iOS app will have dozens of each, so to continue the coffee house analogy a bit more, the model would be the Ingredients & Equipment (beans, burr grinder, milk, espresso machine, syrups, etc.), the Controller would be the barista and the recipes, and the coffee cup would be the View. 

It's an imperfect analogy, but it might look something like this:
![MVC Coffee Shop Graphic](https://dl.dropboxusercontent.com/u/2027148/img/coffee-shop-MVC.png)

The most common question I get from students when teaching through MVC in Cocoa is "give me a concrete example" and that's the tough part, since without actually showing the code, all of the analogies will live in the abstract, so lets start writing some code so you can see MVC in action.

##Example

Fire up Xcode and create a new project using the Single-View Application starter project. Xcode will start you out with a few files.  In Objective-C, a Class is a set of two files (a .h or 'header' file and a .m or 'implementation' file). 

![Single View App Template](https://dl.dropboxusercontent.com/u/2027148/img/single-app-template.png) 

The CSAppDelegate.h & CSAppDelegate.m serves as the Application Delegate for your app.  If you take a look at the CSAppDelegate.m file, you'll see that all it contains no code at all, but is just a handful of empty method placeholders to override later on.  We'll cover Delegation in a future design pattern post, but for now just leave this file along, we won't be modifying it.

Next up we have a CSViewController class. Notice that the name of this class has the words "View" and "Controller" in it, so which one is it, the View or the Controller?  This hints at a fairly Cocoa-specific aspect of MVC, where you'll typically have many controllers, including ModelControllers and ViewControllers.  The ViewController is the cornerstone of an iOS application, and it sits firmly in the "Controller" column of MVC, but as the name suggests, it's a controller specifically aimed at controlling a View (or set of views).

We also have a Main.storyboard file in the project (this, practically speaking, is the View).  As of iOS 5, the Storyboard file has become the default interface builder file for an iOS application, and it contains some or all of the views for your application, with alot of convenient features, like the ability to zoom out and visualize the flow of your app from View to View.

Xcode created the View and the Controller for us, but where's the Model?  Because Models are usually very simple in terms of the code inside them, and they vary greatly from App to App, Xcode doesn't auto generate a starting point for us for a Model (unless you choose something like the Master/Detail template), but this is actually a good thing, because most of the time, we'd end up deleting 99% of whatever Apple auto-generated for a Model.

##Model
So, let's create our Model class.  In Xcode choose `File -> New -> File...` and choose the Objective-C Class option

![New Objective-C Class](https://dl.dropboxusercontent.com/u/2027148/img/new-obj-c-class.png)

This Model will be for various coffee drinks available to order in our new coffee shop app, so call the class CSDrink and be sure to subclass NSObject
![Subclass NSObject](https://dl.dropboxusercontent.com/u/2027148/img/subclass-of-nsobject.png)

We'll cover inheritance later on in this series, but a brief summary is that Classes inherit from a SuperClass.  The base SuperClass in Objective-C is NSObject, and typically all of our Model classes will inherit from NSObject (unless we're using the NSManagedObject with Core Data).  The power of inheritance is that you can create Classes that inherit from other objects in Apple's frameworks but also from your own objects, so in our Coffee Shop app, we can create this root CSDrink class which would have the default properties of a drink (Fluid Ounces, Number of Shots, Hot/Cold, etc.), then later on we might create a CSLatte class that inherits from CSDrink, and now we only have to write the code for the additional properties (Number of Shots, Syrup Flavor, etc.).

Let's give CSDrink those three properties I mentioned.  Open up CSDrink.h and add the following three lines in-between the @interface and @end symbols.

```
#import <Foundation/Foundation.h>

@interface CSDrink : NSObject

@property (nonatomic) NSInteger numberOfShots;
@property (nonatomic) BOOL isIced;
@property (nonatomic) NSString *drinkName;
@property (nonatomic) NSString *drinkSize;

@end
``` 

Surprisingly, that's it for a basic Model class.  Now let's move over to the View. 

##View

Open up the Main.storyboard file and we'll make a basic user interface.

Drag on 3 UISegmentedControls with the following options

1. Latte | Americano | Espresso
2. Hot | Iced
3. Short | Tall | Grande

Next add a UIStepper and a UILabel next to it with the placeholder text "3 Shots"

Finally, add a UITextView which we'll use to display the order confirmation, and a UIButton with the title text set to "Order"

You can drag them on however you want, for my demo I changed the subclass of my CSViewController from UIViewController to UITableViewController and put the controls into static UITableViewCells, but you can also just drag and place them onto the default UIView.

![CSCoffee Ordering Screen](https://dl.dropboxusercontent.com/u/2027148/img/CSCoffee-ordering-screen.png)

We're nearly done with the View, all we need to complete it is to add IBOutlets and IBActions to our UI elements.

Open up your CSViewController.h and add the following properties and IBActions inside the @interface block

```
@property (nonatomic, weak) IBOutlet UILabel *shotCountLabel;
@property (nonatomic, weak) IBOutlet UITextView *drinkSummaryTextView;

- (IBAction)orderButtonTapped:(id)sender;
- (IBAction)modifyShots:(id)sender;
- (IBAction)changeDrinkOptions:(id)sender;
```

Now head back to your Storyboard, and make the following connections: 

1. IBOutlets to your UILabel and UITextView.
2. orderButtonTapped: connects to Touch Up Inside on your Order button
![IBOutlets](https://dl.dropboxusercontent.com/u/2027148/img/iboutlet.png)
3. modifyShots: connects to the Value Changed action of your UIStepper
4. changeDrinkOptions: connects to all 3 of your UISegmentedControls on the Value Changed action
![Value Changed](https://dl.dropboxusercontent.com/u/2027148/img/value-changed.png)
5. make sure to set the Tag property for your UISegmentedControls (0, 1 and 2 are fine choices)
![IBOutlet Tags](https://dl.dropboxusercontent.com/u/2027148/img/IB-tags.png)

##Controller

The last piece of our MVC triumvirate is the Controller, which is where the meat of the 'Business Logic' is going to live for this app.  As the app grows, I'd probably refactor the non-GUI related bits (such as validation of a drink order, etc.) into a model-controller, but for now, the single ViewController will work.

We're going to need to implement the three methods declared in our header
```
- (IBAction)orderButtonTapped:(id)sender;
- (IBAction)modifyShots:(id)sender;
- (IBAction)changeDrinkOptions:(id)sender;
```

as well as a method to reset the form that we'll call in ViewDidAppear and again after each order is placed successfully.

First, we'll need an instance variable to store the current drink order while we're working on it, so modify the top of your CSViewController.m to look something like this
```
#import "CSViewController.h"
#import "CSDrink.h"

@interface CSViewController ()
{
    CSDrink *currentDrink;
}
@end
```

Let's start with the reset form method, so add this block of code to your CSViewController, right after the line `@implementation CSViewController`

```
- (void)resetForm
{
    currentDrink = [CSDrink new];
    
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
```

Next, we'll need to write the code to implement the 3 IBActions in our .h file.  These are all fairly self-explanatory, and just modify our currentDrink object accordingly

```
- (IBAction)orderButtonTapped:(id)sender
{
    NSLog(@"Ordering Drink: %@", currentDrink);
    [self performSelector:@selector(drinkOrderComplete) withObject:nil afterDelay:1.5];
}

- (void)drinkOrderComplete
{
    NSLog(@"Ordered a %@", [self currentDrinkDescription]);
}

- (NSString *)currentDrinkDescription
{
    NSString *icedOrHot = currentDrink.isIced ? @"Iced" : @"Hot";
    
    return [NSString stringWithFormat:@"%@ %@ %@ with %d Shots", currentDrink.drinkSize, icedOrHot, currentDrink.drinkName, currentDrink.numberOfShots];
}

- (IBAction)modifyShots:(id)sender
{
    UIStepper *stepper = (UIStepper *)sender;
    [currentDrink setNumberOfShots:stepper.value];
    [_shotCountLabel setText:[NSString stringWithFormat:@"%d Shots", currentDrink.numberOfShots]];
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

```

This tutorial is available in source code form on my Github page here: ![GitHub Link To Example Project](https://github.com/johnnyclem/Coffee-Shop-MVC)