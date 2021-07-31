//
//  CalculatorViewController.m
//  TipsterObjC
//
//  Created by Priya Pahal on 7/26/21.
//

#import "CalculatorViewController.h"
#import "SettingsViewController.h"

@interface CalculatorViewController () <SettingsDelegate>
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Start w/ keyboard
    [self.billField becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    //Instantiate the percentages
    self.percentages = [[NSMutableArray alloc] init];
    [self.percentages setArray:@[@(15),@(18),@(20)]];
}
- (IBAction)endEdit:(id)sender {
    [self.billField endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    //UI Dark Mode & Light Mode
    if([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleDark){
        //Set Dark Mode UI
        NSLog(@"Dark");
//        self.screenView.backgroundColor = [UIColor colorWithRed: 0.07 green: 0.00 blue: 0.20 alpha: 0.75];
//        UIColor *textColor = [UIColor colorWithRed: 0.85 green: 0.85 blue:1 alpha: 1.00];
//        UIColor *mainFeaturesColor = [UIColor colorWithRed: 0.9 green: 0.9 blue:1 alpha: 1.00];
    }else{
        //Set Light Mode UI
        //Text Colors
        UIColor *textColor = [UIColor colorWithRed: 0.80 green: 0.80 blue:1 alpha: 1.00];
        UIColor *mainFeaturesColor = [UIColor colorWithRed: 0.75 green: 0.75 blue:1 alpha: 1.00];
        UIColor *detailsColor = [UIColor colorWithRed: 0.80 green: 0.80 blue: 1.00 alpha: 0.85];
        UIColor *backgroundColor = [UIColor colorWithRed: 0.90 green: 0.90 blue: 1.00 alpha:1];
        UIColor *sliderDetailColor = [UIColor colorWithRed: 0.98 green: 0.98 blue: 1.00 alpha:1];
        //NavBar
        self.navigationController.navigationBar.barTintColor = detailsColor;
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-medium" size:21]}];
        self.navigationController.navigationItem.backBarButtonItem.tintColor = [UIColor blackColor];
        //View
        //self.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        self.view.backgroundColor = backgroundColor;
        //Labels
        self.billField.textColor = mainFeaturesColor;
        self.tipLabel.textColor = textColor;
        self.totalLabel.textColor = mainFeaturesColor;
        self.plusLabel.textColor = textColor;
        self.equalLabel.textColor = mainFeaturesColor;
        //Settings Button
        
        //Tip Controller
        self.tipControl.selectedSegmentTintColor = mainFeaturesColor;
        self.tipControl.backgroundColor = detailsColor;
        [self.tipControl setTitleTextAttributes:@{NSForegroundColorAttributeName:backgroundColor, NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-medium" size:20]} forState:UIControlStateNormal];
        [self.tipControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-medium" size:20]} forState:UIControlStateSelected];
        //Patrons portion
        self.patronsView.backgroundColor = detailsColor;
        self.numberOfPatronsSlider.thumbTintColor = [UIColor whiteColor];
        self.tableForLabel.textColor = [UIColor whiteColor];
        self.numberOfPatronsSlider.maximumTrackTintColor = mainFeaturesColor;
        self.numberOfPatronsSlider.minimumTrackTintColor = backgroundColor;
        self.numberOfPatronsSlider.maximumValueImage = [[UIImage systemImageNamed:@"person.3"] imageWithTintColor: backgroundColor];
        self.numberOfPatronsSlider.minimumValueImage = [[UIImage systemImageNamed:@"person"] imageWithTintColor: [UIColor whiteColor]];
        self.numberOfPatronsSlider.tintColor = sliderDetailColor;
        //ThumbTack Modifications
        self.numberOfPatronsSlider.continuous = NO;
        UIImage *highlightedThumb = [self image:[UIImage systemImageNamed:@"number.circle.fill"] scaledTo:CGSizeMake(40, 40)];
        [self.numberOfPatronsSlider setThumbImage:highlightedThumb forState:UIControlStateHighlighted];
        CGPoint point;
        if (self.numberOfPatronsSlider.value > 10){
            point= CGPointMake(4, 3);
        }else{
            point= CGPointMake(7, 3);
        }
        NSString *current = [NSString stringWithFormat:@"%.0f",self.numberOfPatronsSlider.value];
        UIImage *startThumb = [self image:[self drawCircle:current colored: detailsColor atPoint:point] scaledTo:CGSizeMake(40, 40)];
        [self.numberOfPatronsSlider setThumbImage:startThumb forState:UIControlStateNormal];
//        self.tipControl.backgroundColor = [UIColor colorWithRed: 0.80 green: 0.80 blue: 1.00 alpha: 1.00];
//        self.tipControl.tintColor = [UIColor colorWithRed: 0.07 green: 0.00 blue: 0.20 alpha: 0.5];
    }
    //Tip Segment Modifications
    [self.tipControl setTitle:[@"%" stringByAppendingString:[self.percentages[0] stringValue]] forSegmentAtIndex:0];
    [self.tipControl setTitle:[@"%" stringByAppendingString:[self.percentages[1] stringValue]]  forSegmentAtIndex:1];
    [self.tipControl setTitle:[@"%" stringByAppendingString:[self.percentages[2] stringValue]]  forSegmentAtIndex:2];
}

- (UIImage *)image:(UIImage *)image scaledTo:(CGSize)newSize{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)keyboardWillDisappear:(NSNotification *)notification{
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        self.scrollviewBottomConstraint.constant = 0;
       // self.tipTotalView.alpha = 1;
    }];
}

- (void)keyboardWillAppear:(NSNotification *) notification{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameEnd = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameEndRect = [keyboardFrameEnd CGRectValue];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        self.scrollviewBottomConstraint.constant = keyboardFrameEndRect.size.height;
       // self.tipTotalView.alpha = 0;
    }];
}

- (IBAction)onEdit:(id)sender {
    [self modifyCalculatorValues];
}
- (IBAction)changePercentageForTip:(id)sender {
    [self modifyCalculatorValues];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"settingsSegue"]){
        SettingsViewController *vc = [segue destinationViewController];
        vc.percentages = [self.percentages copy];
        vc.delegate = self;
    }
}

- (IBAction)changeNumberOfPatrons:(id)sender {
    UIColor *detailsColor;
    if([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleDark){
        //Set Dark Mode UI
        NSLog(@"Dark");
    }else{
        //Set Light Mode UI
        //Text Colors
        detailsColor = [UIColor colorWithRed: 0.80 green: 0.80 blue: 1.00 alpha: 0.85];
    }
    CGPoint point;
    if (self.numberOfPatronsSlider.value > 10){
        point= CGPointMake(4, 3);
    }else{
        point= CGPointMake(7, 3);
    }
    NSString *current = [NSString stringWithFormat:@"%.0f",self.numberOfPatronsSlider.value];
                        // [NSNumber numberWithFloat:self.numberOfPatronsSlider.value] stringValue];
    UIImage *currentThumb = [self image:[self drawCircle:current colored:detailsColor atPoint:point]scaledTo:CGSizeMake(40, 40)];
    [self.numberOfPatronsSlider setThumbImage:nil forState:UIControlStateNormal];
    [self.numberOfPatronsSlider setThumbImage:currentThumb forState:UIControlStateNormal];
    [self modifyCalculatorValues];
}


//Draw number inside a circle
- (UIImage*) drawCircle:(NSString*) text colored: (UIColor*)color atPoint:(CGPoint)point
{
    //Gets the circle background
    UIImage *image = [[UIImage systemImageNamed:@"circle.fill"] imageWithTintColor:[UIColor blackColor]];
    //Creates the new image
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
    UIGraphicsEndImageContext();

    return newImage;
}

-(void)updatePercentages:(NSArray *)percentages{
    [self.percentages setArray:percentages];
}

-(void)modifyCalculatorValues{
    double tipPercentage = [self.percentages[self.tipControl.selectedSegmentIndex] doubleValue];
    tipPercentage = tipPercentage/100;
    double bill = [self.billField.text doubleValue];
    double tip = bill * tipPercentage;
    double total = tip+bill;
    double numberOfPatrons = round(self.numberOfPatronsSlider.value);
    total = total/numberOfPatrons;
    self.tipLabel.text= [NSString stringWithFormat:@"$%.2f",tip];
    self.totalLabel.text=[NSString stringWithFormat:@"$%.2f",total];
}

@end
