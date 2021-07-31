//
//  SettingsViewController.h
//  TipsterObjC
//
//  Created by Priya Pahal on 6/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SettingsDelegate
-(void)updatePercentages:(NSArray *)percentages;
@end

@interface SettingsViewController : UIViewController
@property (strong, nonatomic) NSMutableArray *percentages;
@property (nonatomic, weak) id<SettingsDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
