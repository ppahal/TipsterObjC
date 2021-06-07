//
//  SettingsViewController.m
//  TipsterObjC
//
//  Created by Priya Pahal on 6/4/21.
//

#import "SettingsViewController.h"
#import "ViewController.h"

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
}

/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"tipsSegue"])
        {
            // Get reference to the destination view controller
            ViewController *vc = [segue destinationViewController];
           // [vc tip1: self.tip1];
           // [vc tip2: self.tip2];
            //[vc tip3: self.tip3];
        }
    }*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
