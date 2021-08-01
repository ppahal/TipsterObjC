//
//  CalculatorViewController.m
//  TipsterObjC
//
//  Created by Priya Pahal on 7/26/21.
//

#import "CalculatorViewController.h"
#import "SettingsViewController.h"

@interface CalculatorViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewBottomConstraint;
@property (weak, nonatomic) IBOutlet UITextField *billField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;
@property (weak, nonatomic) IBOutlet UIView *tipTotalView;
@property (weak, nonatomic) IBOutlet UIView *screenView;
@property (weak, nonatomic) IBOutlet UILabel *plusLabel;
@property (weak, nonatomic) IBOutlet UILabel *equalLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;
@property (weak, nonatomic) IBOutlet UILabel *tableForLabel;
@property (weak, nonatomic) IBOutlet UISlider *numberOfPatronsSlider;
@property (weak, nonatomic) IBOutlet UIView *patronsView;
@end

@implementation CalculatorViewController

//When the view loads
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set billField as first responder
    [self.billField becomeFirstResponder];
    
    //Set checks for when keyboard appears and disappears
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
}

//If outside billField touched, end editing.
- (IBAction)endEdit:(id)sender {
    [self.billField endEditing:YES];
}

//When the view is going to appear
-(void)viewWillAppear:(BOOL)animated{
    //Set User Defaults
    //Access UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //Set values for the percentages array
    self.percentages = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"percentages"]];
    //Set value for the patrons slider
    double value = [defaults doubleForKey:@"patrons"];
    [self.numberOfPatronsSlider setValue:value];
    //Set value for the billField
    double bill = [defaults doubleForKey:@"bill"];
    if (bill == 0){
        NSNumberFormatter * formatter = [[NSNumberFormatter alloc]init];
        NSLocale *locale = NSLocale.currentLocale;
        [formatter setLocale:locale];
        [formatter setCurrencySymbol: locale.currencySymbol];
        [formatter setCurrencyCode: locale.currencyCode];
        [formatter setDecimalSeparator: locale.decimalSeparator];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setCurrencyGroupingSeparator: locale.groupingSeparator];

        self.billField.placeholder = [formatter stringFromNumber:@(0.00)];
        self.tipLabel.text = [formatter stringFromNumber:@(0.00)];
        self.totalLabel.text = [formatter stringFromNumber:@(0.00)];
        self.billField.text = @"";
        
    }else{
        self.billField.text = [NSString stringWithFormat:@"%0.0f",bill];
        [self modifyCalculatorValues];
    }
    
    //Update UI
    //Default colors
    UIColor *textColor;
    UIColor *mainFeaturesColor;
    UIColor *detailsColor;
    UIColor *backgroundColor;
    UIColor *sliderDetailColor;
    //UI Dark Mode v. Light Mode
    if([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleDark){
        //Set Dark Mode UI color scheme
        
        textColor = [UIColor colorWithRed: 0.40 green: 0.12 blue:0.40 alpha: 1.00];
        mainFeaturesColor = [UIColor colorWithRed: 0.35 green: 0.25 blue:0.4 alpha: 1.00];
        detailsColor = [UIColor colorWithRed: 0.25 green: 0.12 blue:0.25 alpha: 1.00];
        backgroundColor = [UIColor colorWithRed:0.08 green:0.0 blue:0.15 alpha:1];
        sliderDetailColor = [UIColor colorWithRed: 0.25 green: 0.12 blue:0.25 alpha: 1.00];
    }else{
        //Set Light Mode UI color scheme
        textColor = [UIColor colorWithRed: 0.80 green: 0.80 blue:1 alpha: 1.00];
        mainFeaturesColor = [UIColor colorWithRed: 0.75 green: 0.75 blue:1 alpha: 1.00];
       detailsColor = [UIColor colorWithRed: 0.80 green: 0.80 blue: 1.00 alpha: 0.85];
        backgroundColor = [UIColor colorWithRed: 0.90 green: 0.90 blue: 1.00 alpha:1];
        sliderDetailColor = [UIColor colorWithRed: 0.98 green: 0.98 blue: 1.00 alpha:1];
    }
    
    //Set NavBar Colors
    self.navigationController.navigationBar.barTintColor = detailsColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-medium" size:21]}];
    self.navigationController.navigationItem.backBarButtonItem.tintColor = [UIColor blackColor];
    //Set background Color of the View
    self.view.backgroundColor = backgroundColor;
    //Set labels colors
    self.billField.textColor = mainFeaturesColor;
    self.tipLabel.textColor = textColor;
    self.totalLabel.textColor = mainFeaturesColor;
    self.plusLabel.textColor = textColor;
    self.equalLabel.textColor = mainFeaturesColor;
    
    //Text Label minimization
    self.tipLabel.adjustsFontSizeToFitWidth = YES;
    self.tipLabel.numberOfLines = 1;
    self.totalLabel.adjustsFontSizeToFitWidth = YES;
    self.totalLabel.numberOfLines = 1;
    [self.billField sizeToFit];
    
    //Segmented Tip Controller Aesthetics
    //Set tipcontroller colors
    self.tipControl.selectedSegmentTintColor = mainFeaturesColor;
    self.tipControl.backgroundColor = detailsColor;
    //Set tipcontroller's text fonts and colors
    [self.tipControl setTitleTextAttributes:@{NSForegroundColorAttributeName:backgroundColor, NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-medium" size:20]} forState:UIControlStateNormal];
    [self.tipControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-medium" size:20]} forState:UIControlStateSelected];
    
    //Patron Slider Aesthetics
    //Set Patrons Slider colors
    self.patronsView.backgroundColor = detailsColor;
    self.numberOfPatronsSlider.thumbTintColor = [UIColor whiteColor];
    self.tableForLabel.textColor = [UIColor whiteColor];
    self.numberOfPatronsSlider.maximumTrackTintColor = mainFeaturesColor;
    self.numberOfPatronsSlider.minimumTrackTintColor = backgroundColor;
    self.numberOfPatronsSlider.tintColor = sliderDetailColor;
    //Set Patrons Slider's max & min images
    self.numberOfPatronsSlider.maximumValueImage = [[UIImage systemImageNamed:@"person.3"] imageWithTintColor: backgroundColor];
    self.numberOfPatronsSlider.minimumValueImage = [[UIImage systemImageNamed:@"person"] imageWithTintColor: [UIColor whiteColor]];
    //Set Patrons Slider to update continuously
    self.numberOfPatronsSlider.continuous = YES;
    //Set up new thumbtack image
    //Set up location of text in thumbtack image
    CGPoint point;
    double patrons = round(self.numberOfPatronsSlider.value);
    //Single digit numbers require adjusted positioning
    if (patrons > 10){
        point= CGPointMake(4, 3);
    }else{
        point= CGPointMake(7, 3);
    }
    //Set up string for thumbtack image
    NSString *current = [NSString stringWithFormat:@"%0.0f",patrons];
    //Set up image from string
    UIImage *startThumb = [self image:[self drawCircle:current colored: detailsColor atPoint:point] scaledTo:CGSizeMake(40, 40)];
    //Set the image to be the same for both when the slider is clicked on and when it isn't
    [self.numberOfPatronsSlider setThumbImage:startThumb forState:UIControlStateNormal];
    [self.numberOfPatronsSlider setThumbImage:startThumb forState:UIControlStateHighlighted];
    
    //Set up segmented Tip Control based on current percentage values
    [self.tipControl setTitle:[@"%" stringByAppendingString:[self.percentages[0] stringValue]] forSegmentAtIndex:0];
    [self.tipControl setTitle:[@"%" stringByAppendingString:[self.percentages[1] stringValue]]  forSegmentAtIndex:1];
    [self.tipControl setTitle:[@"%" stringByAppendingString:[self.percentages[2] stringValue]]  forSegmentAtIndex:2];
}

//Resize Image Functions
- (UIImage *)image:(UIImage *)image scaledTo:(CGSize)newSize{
    //Start image creation w/ a new UIImage of size "newSize"
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    //Add image from parameter as big as desired "newSize"
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    //Get resized image from image creation
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //End image creation
    UIGraphicsEndImageContext();
    //Return resized image
    return newImage;
}

//Keyboard disappearing specific modifications
- (void)keyboardWillDisappear:(NSNotification *)notification{
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        //Adjust scrollview
        self.scrollviewBottomConstraint.constant = 0;
    }];
}

//Keyboard appearing specific modifications
- (void)keyboardWillAppear:(NSNotification *) notification{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameEnd = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameEndRect = [keyboardFrameEnd CGRectValue];
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        //Adjust scrollview
        self.scrollviewBottomConstraint.constant = keyboardFrameEndRect.size.height;
    }];
}

//Each time the bill field is modified
- (IBAction)onEdit:(id)sender {
    //Update UI w/ new calculations
    [self modifyCalculatorValues];
    
    //Update UserDefaults
    //Access UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //Modify bill value
    //Format text fields
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc]init];
    NSLocale *locale = NSLocale.currentLocale;
    [formatter setLocale:locale];
    [formatter setCurrencySymbol: locale.currencySymbol];
    [formatter setCurrencyCode: locale.currencyCode];
    [formatter setDecimalSeparator: locale.decimalSeparator];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencyGroupingSeparator: locale.groupingSeparator];
    double bill = [[formatter numberFromString:self.billField.text] doubleValue];
    if(bill == 0){
        bill = [self.billField.text doubleValue];
    }
    [defaults setDouble:bill forKey:@"bill"];
    //Save Changes
    [defaults synchronize];
}

//Each time a new tip on the segmented tip control is selected
- (IBAction)changePercentageForTip:(id)sender {
    //Update UI w/ new calculations
    [self modifyCalculatorValues];
}

//Each time, the slider is moved to a new spot
- (IBAction)changeNumberOfPatrons:(id)sender {
    //When Updating Thumbtack of Slider, choose correct UI design
    UIColor *detailsColor;
    if([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleDark){
        //Set Dark Mode UI
        detailsColor = [UIColor colorWithRed: 0.80 green: 0.80 blue: 1.00 alpha: 0.85];
    }else{
        //Set Light Mode UI
        detailsColor = [UIColor colorWithRed: 0.80 green: 0.80 blue: 1.00 alpha: 0.85];
    }
    
    //Select correct point based on new Patron value
    CGPoint point;
    double patrons = round(self.numberOfPatronsSlider.value);
    if (patrons > 10){
        point= CGPointMake(4, 3);
    }else{
        point= CGPointMake(7, 3);
    }
    
    //Update Thumbtack of Slider
    //Format the value of "current" string
    NSString *current = [NSString stringWithFormat:@"%.0f",patrons];
    //Create image for thumbtack from "current" string
    UIImage *currentThumb = [self image:[self drawCircle:current colored:detailsColor atPoint:point]scaledTo:CGSizeMake(40, 40)];
    //Set thumbtack to new image
    [self.numberOfPatronsSlider setThumbImage:currentThumb forState:UIControlStateNormal];
    [self.numberOfPatronsSlider setThumbImage:currentThumb forState:UIControlStateHighlighted];
    //Update UI w/ new calculations
    [self modifyCalculatorValues];
    
    //Update UserDefaults
    //Access UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //Change the bill field
    [defaults setDouble:[current doubleValue] forKey:@"patrons"];
    //Save Changes
    [defaults synchronize];
}


//Draw number inside a circle
- (UIImage*) drawCircle:(NSString*) text colored: (UIColor*)color atPoint:(CGPoint)point{
    //Gets the circle background
    UIImage *image = [[UIImage systemImageNamed:@"circle.fill"] imageWithTintColor:[UIColor blackColor]];
    //Starts image creation
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    //Inserts circle background into the new image
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    //Makes the rectangle for the text
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    //Set font
    UIFont *font = [UIFont boldSystemFontOfSize:10];
    //Set the attribute with the font and font color
    NSDictionary *att = @{ NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor whiteColor]};
    //Draw text into the rect
    [text drawInRect:rect withAttributes:att];
    //Create the new image from the above information
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //Ends Image Creation
    UIGraphicsEndImageContext();
    return newImage;
}

//Update UI w/ current calculations of Tip & Bill
-(void)modifyCalculatorValues{
    //Format text fields
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc]init];
    NSLocale *locale = NSLocale.currentLocale;
    [formatter setLocale:locale];
    [formatter setCurrencySymbol: locale.currencySymbol];
    [formatter setCurrencyCode: locale.currencyCode];
    [formatter setDecimalSeparator: locale.decimalSeparator];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencyGroupingSeparator: locale.groupingSeparator];
    
    //Get Current values for tip and total
    //Gets tip percentage
    double tipPercentage = [self.percentages[self.tipControl.selectedSegmentIndex] doubleValue];
    tipPercentage = tipPercentage/100;
    //Gets bill amount
    double bill = [[formatter numberFromString:self.billField.text] doubleValue];
    if(bill == 0){
        bill = [self.billField.text doubleValue];
    }
    //Gets tip amount
    double tip = bill * tipPercentage;
    //Determines total amount
    double total = tip+bill;
    //Divide the total by the current number of Patrons
    double numberOfPatrons = round(self.numberOfPatronsSlider.value);
    total = total/numberOfPatrons;
    
    //Set tip label
    self.tipLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:tip]];
    //Set text Label
    self.totalLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:total]];
}

#pragma mark - Navigation

//Prepare for Settings View Controller with current percentage values
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //Check segue identifier to make sure this is the right segue
    if([[segue identifier] isEqualToString:@"settingsSegue"]){
        //Get SettingsViewController
        SettingsViewController *vc = [segue destinationViewController];
        //Copy percentages to the SettingsViewController
        vc.percentages = [self.percentages copy];
    }
}

@end
