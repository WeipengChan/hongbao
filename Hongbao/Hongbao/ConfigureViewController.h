//
//  ConfigureViewController.h
//  Hongbao
//
//  Created by Robin on 08/01/16.
//  Copyright © 2016年 Yate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigureViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISlider *aliveTimeSlide;
@property (strong, nonatomic) IBOutlet UILabel *aliveTimeLabel;


@property (strong, nonatomic) IBOutlet UISlider *doubleHongbaoSlide;
@property (strong, nonatomic) IBOutlet UILabel *doubleHongbaoLabel;



@property (strong, nonatomic) IBOutlet UISlider *totalTimeSlide;
@property (strong, nonatomic) IBOutlet UILabel *totalTimeLabel;






@end
