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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tip1Field.placeholder = [self.percentages[0] stringValue];
    self.tip2Field.placeholder = [self.percentages[1] stringValue];
    self.tip3Field.placeholder = [self.percentages[2] stringValue];
}
- (IBAction)clickedTip:(id)sender {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    NSNumber *tip1 = [formatter numberFromString:self.tip1Field.text];
    NSNumber *tip2 = [formatter numberFromString:self.tip2Field.text];
    NSNumber *tip3 = [formatter numberFromString:self.tip3Field.text];
    [self.delegate updatePercentages:@[tip1,tip2,tip3]];
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//}


@end
