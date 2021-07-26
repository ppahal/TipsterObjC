//
//  ViewController.m
//  TipsterObjC
//
//  Created by Priya Pahal on 5/20/21.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewBottomConstraint;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillDisappear:(NSNotification *)notification{
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        self.scrollviewBottomConstraint.constant = 0;
        self.tipTotalView.alpha = 1;
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
        self.tipTotalView.alpha = 0;
    }];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
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
