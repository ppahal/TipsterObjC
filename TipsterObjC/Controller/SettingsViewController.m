//
//  SettingsViewController.m
//  TipsterObjC
//
//  Created by Priya Pahal on 6/4/21.
//

#import "SettingsViewController.h"
#import "CalculatorViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *tipButton;
@property (weak, nonatomic) IBOutlet UITextField *tip1Field;
@property (weak, nonatomic) IBOutlet UITextField *tip2Field;
@property (weak, nonatomic) IBOutlet UITextField *tip3Field;
@end

@implementation SettingsViewController

//When the view loads
- (void)viewDidLoad {
    [super viewDidLoad];

    //Set the tip fields to show the percentage values
    self.tip1Field.placeholder = [self.percentages[0] stringValue];
    self.tip2Field.placeholder = [self.percentages[1] stringValue];
    self.tip3Field.placeholder = [self.percentages[2] stringValue];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tipButton.backgroundColor = [UIColor colorWithRed:0.4 green:0.2 blue:0.4 alpha:1];
}

//When "Change Tips" is selected
- (IBAction)clickedTip:(id)sender {
    //Check and assign tip values accordingly
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    NSNumber *tip1, *tip2, *tip3;
    if(![self.tip1Field.text isEqualToString:@""]){
        tip1 = [formatter numberFromString:self.tip1Field.text];
    }else{
        tip1 = [formatter numberFromString:self.tip1Field.placeholder];
    }
    if(![self.tip2Field.text isEqualToString:@""]){
        tip2 = [formatter numberFromString:self.tip2Field.text];
    }else{
        tip2 = [formatter numberFromString:self.tip2Field.placeholder];
    }
    if(![self.tip3Field.text isEqualToString:@""]){
        tip3 = [formatter numberFromString:self.tip3Field.text];
    }else{
        tip3 = [formatter numberFromString:self.tip3Field.placeholder];
    }
    
    //Update UserDefaults
    //Access UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //Change User Defaults
    [defaults setObject:@[tip1,tip2,tip3] forKey:@"percentages"];
    //Save changes
    [defaults synchronize];
    //Update Calculator View Controller Percentage Values
    [self.delegate updatePercentages:@[tip1,tip2,tip3]];
    //Pop off current View Controller
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
