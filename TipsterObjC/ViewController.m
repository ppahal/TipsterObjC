//
//  ViewController.m
//  TipsterObjC
//
//  Created by Priya Pahal on 5/20/21.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *billField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;
@property (weak, nonatomic) IBOutlet UIView *tipTotalView;
@property (weak, nonatomic) IBOutlet UIView *screenView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Start w/ keyboard
    [self.billField becomeFirstResponder];
    //CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    //[self.screenView setFrame:CGRectMake(self.screenView.frame.origin.x,screenHeight - self.screenView.frame.size.height - self.billField.frame.size.height, self.screenView.frame.size.width, self.screenView.frame.size.height)];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)onEditingBegan:(id)sender {
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.tipControl.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        [self.screenView setFrame:CGRectMake(self.screenView.frame.origin.x,screenHeight - self.screenView.frame.size.height - self.billField.frame.size.height, self.screenView.frame.size.width, self.screenView.frame.size.height)];
    }];
    NSLog(@"EDIT");
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}
- (IBAction)onEditingEnd:(id)sender {
    //CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.tipControl.alpha = 1;
    CGRect newFrame = self.screenView.frame;
    newFrame.origin.y =  self.screenView.frame.size.height;
    [UIView animateWithDuration:0.2 animations:^{
        self.screenView.frame = newFrame;
    }];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}


- (IBAction)onEdit:(id)sender {
    NSArray *percentages = @[@(0.15),@(0.18),@(0.20)];
    double tipPercentage = [percentages[self.tipControl.selectedSegmentIndex] doubleValue];
    double bill = [self.billField.text doubleValue];
    double tip = bill * tipPercentage;
    double total = tip+bill;
    self.tipLabel.text= [NSString stringWithFormat:@"$%.2f",tip];
    self.totalLabel.text=[NSString stringWithFormat:@"$%.2f",total];
}



@end
