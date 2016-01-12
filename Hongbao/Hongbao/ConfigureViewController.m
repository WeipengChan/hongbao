//
//  ConfigureViewController.m
//  Hongbao
//
//  Created by Robin on 08/01/16.
//  Copyright © 2016年 Yate. All rights reserved.
//

#import "ConfigureViewController.h"

@interface ConfigureViewController ()

@end

@implementation ConfigureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    //重要配置
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"aliveTime"] )
    {
        self.aliveTimeSlide.value = [[[NSUserDefaults standardUserDefaults]objectForKey:@"aliveTime"]floatValue];
    }
    else
    {
        self.aliveTimeSlide.value = 0.2;//跟生理极限有关
        
    }
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"totalTime"] )
    {
        self.totalTimeSlide.value = [[[NSUserDefaults standardUserDefaults]objectForKey:@"totalTime"]floatValue];
    }
    else
    {
            self.totalTimeSlide.value = 20;  //关系到出现的红包数，总红包是不变的
        
    }
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"doubleHongbao"] )
    {
        self.doubleHongbaoSlide.value = [[[NSUserDefaults standardUserDefaults]objectForKey:@"doubleHongbao"]floatValue];
    }
    else
    {
         self.doubleHongbaoSlide.value= 0.5;
        
    }
    [self updateSlideValueForText];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)aliveTimeValueChanged:(UISlider *)sender
{
    [self updateSlideValueForText];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"paramValueChaned" object:self userInfo:[self param]];
    
}
                                                                                                           

-(NSDictionary*)param
{
    
    return @{  @"aliveTime": @(self.aliveTimeSlide.value),
               @"doubleHongbao": @(self.doubleHongbaoSlide.value),
               @"totalTime": @(self.totalTimeSlide.value)};
}

                                                                                                           
- (IBAction)doubleHongbaoOValueChanged:(UISlider *)sender {
    [self updateSlideValueForText];

    [[NSNotificationCenter defaultCenter]postNotificationName:@"paramValueChaned" object:self userInfo:[self param]];

}
- (IBAction)totalTimeValueChanged:(UISlider *)sender {
    [self updateSlideValueForText];

    [[NSNotificationCenter defaultCenter]postNotificationName:@"paramValueChaned" object:self userInfo:[self param]];

}

-(void)updateSlideValueForText
{
    self.totalTimeLabel.text = [NSString stringWithFormat:@"总活动时间:%.2f秒", self.totalTimeSlide.value];
    self.doubleHongbaoLabel.text = [NSString stringWithFormat:@"刷新双红包概率:%0.2f%%", self.doubleHongbaoSlide.value * 100];

    self.aliveTimeLabel.text = [NSString stringWithFormat:@"红包存活时间:%.2f秒", self.aliveTimeSlide.value];

}

- (IBAction)reset:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setObject:@(20.0) forKey:@"totalTime"];
    [[NSUserDefaults standardUserDefaults]setObject:@(0.2) forKey:@"aliveTime"];
    [[NSUserDefaults standardUserDefaults]setObject:@(0.5) forKey:@"doubleHongbao"];

}
- (IBAction)save:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setObject:@(self.totalTimeSlide.value) forKey:@"totalTime"];
    [[NSUserDefaults standardUserDefaults]setObject:@(self.aliveTimeSlide.value) forKey:@"aliveTime"];
    [[NSUserDefaults standardUserDefaults]setObject:@(self.doubleHongbaoSlide.value) forKey:@"doubleHongbao"];
    [self dismissViewControllerAnimated:YES completion:^{
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"a233333" object:self userInfo:nil];
    }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
