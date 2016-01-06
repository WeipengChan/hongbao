//
//  ViewController.m
//  Hongbao
//
//  Created by Robin on 05/01/16.
//  Copyright © 2016年 Yate. All rights reserved.
//

#import "ViewController.h"

const int imageWidth = 260 ,  imageHeight = 260;


@interface ViewController ()
{
    float half_hypotenuse ;
}

@property(nonatomic,strong)NSMutableArray * sprites;
@property(nonatomic,assign)int gapShowingCount; // 间隔计算器
@property(nonatomic,assign)NSTimeInterval gapTime;
@property(nonatomic,assign) int gameLevel ;//用于调整间隙，相当于调整难度

@property(nonatomic,assign)int maxCount;


@end

typedef enum
{
   GameStatusStarted ,
   GameStatusPlaying ,
   GameStatusDone
}GameStatus;


@interface HongbaoButton : UIButton


@end

@implementation HongbaoButton

//-(void)di

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initScene];
    
}

//初始化开始界面
-(void)initScene
{
    half_hypotenuse = hypot(imageWidth, imageHeight) / 2.0;
    self.gameLevel = 10;
    self.maxCount = 3;
    self.sprites = [NSMutableArray array];
    self.gapTime = 0.1;
    [NSTimer scheduledTimerWithTimeInterval:self.gapTime target:self selector:@selector(insert) userInfo:nil repeats:YES];
}

/**  返回已经花掉的游戏时间 */
-(NSTimeInterval)gamePlayedTime
{

    return 1;
}

-(void)gameOver
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)insert
{
    if ([self gamePlayedTime] > 60)
    {
        [self gameOver];
    }
    else
    if (self.gapShowingCount < self.gameLevel  )
    {
        self.gapShowingCount ++ ;
    }
    else
    {
        self.gapShowingCount = 0;
        self.gameLevel = arc4random() % 5 + 1;

        
        if(self.sprites.count > self.maxCount)
        {
            return;
        }
        
        NSString * imgName = [NSString stringWithFormat:@"luckytap_sprite%d",arc4random()%6+0];
        UIImage * image = [UIImage imageNamed:imgName];
        
        CGPoint point = [self originalGenerate];
        
        UIButton * hongbaoButon = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
        hongbaoButon.center = point;
        [hongbaoButon setImage:image forState:UIControlStateNormal];
        [hongbaoButon addTarget:self action:@selector(hongbaoTapped:) forControlEvents:UIControlEventTouchUpInside];
        [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(hongbaoDisappeared:) userInfo:@{@"button":hongbaoButon} repeats:NO];

        
        [self.view addSubview:hongbaoButon];
        [self.sprites addObject:hongbaoButon];
    }
    
}

-(CGPoint)originalGenerate
{
    float x = 0, y =0 ;
    while (true)
    {
        
         x= arc4random() % (int)( CGRectGetWidth(self.view.frame) - imageWidth) + imageWidth/2;
         y= (arc4random() % (int)(CGRectGetHeight(self.view.frame) - imageHeight)) + imageHeight/2;

    
//        if (self.sprites.count == 0) {
//            return CGPointMake(x, y);
//        }
        
        
        BOOL isGot = YES;
        for (UIButton * button in self.sprites)
        {
            NSLog(@"xy %f",hypotf(x-button.center.x,y- button.center.y));

            if (hypotf( x-button.center.x,y- button.center.y)* 2 < half_hypotenuse) {
                isGot = NO;
                break;
            }
        }
        
        if (isGot) {
            break;
        }
    }
    
    return CGPointMake(x, y);

}

-(void)hongbaoTapped:(UIButton*)button
{
    //这里是红包点击的逻辑
    [self hongbaoDisappearedWithButton:button];
}

-(void)hongbaoDisappearedWithButton:(UIButton*)button
{
    [UIView animateWithDuration: .2 animations:^{
        button.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [button removeFromSuperview];
        [self.sprites removeObject:button];
    }];
}


-(void)hongbaoDisappeared:(NSTimer*)timer
{
    UIButton * button =  timer.userInfo[@"button"];
    [self hongbaoDisappearedWithButton:button];

}


@end
