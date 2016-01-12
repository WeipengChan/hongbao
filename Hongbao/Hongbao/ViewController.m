//
//  ViewController.m
//  Hongbao
//
//  Created by Robin on 05/01/16.
//  Copyright © 2016年 Yate. All rights reserved.
//

#import "ViewController.h"
#import "FXLabel.h"
#import "MusicManager.h"
#import "WCAlertView.h"
#import "ConfigureViewController.h"

#define WindowWidth [[UIScreen mainScreen] bounds].size.width
#define WindowHeight [[UIScreen mainScreen] bounds].size.height

const int imageWidth = 130 ,  imageHeight = 130;


@interface ViewController ()<MusicManagerDelegate>
{
    float half_hypotenuse ;
    CGPoint _lastOriginXY;
    NSTimeInterval _startedInterval;
}

@property(nonatomic,strong)NSMutableArray * sprites;
@property(nonatomic,assign)int gapShowingCount; // 间隔计算器 不断+1 +1 +1
@property(nonatomic,strong)NSTimer  * hongbaoDrawingtimer;

@property(nonatomic,assign)NSTimeInterval gapTime;
@property(nonatomic,assign) int gameLevel ;//用于调整间隙，相当于调整难度

@property(nonatomic,assign)int maxCount;
@property(nonatomic,assign)int tappedHongbaoCount;

@property(nonatomic,strong)FXLabel * fxLabel;

/** 红包存活时间 */
@property(nonatomic,assign)float alivedTime;

/** 两个红包出现的概率*/
@property(nonatomic,assign)float twoHongbaosO;

/** 活动总时间 */
@property(nonatomic,assign)float totalTime;


@property(nonatomic,assign)int totalHongbaos;

@end

typedef enum
{
   GameStatusStarted ,
   GameStatusPlaying ,
   GameStatusDone
}GameStatus;

float max(float a , float b)
{

    if (a > b)
    {
        return  a;
    }
    return  b;
}

@interface HongbaoButton : UIButton


@end

@implementation HongbaoButton

//-(void)di

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.60];
    
    [self initScene];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paramValueChaned: ) name:@"paramValueChaned" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(a233333) name:@"a233333" object:nil];
}

-(void)a233333
{
    [self initScene];
}

-(void)paramValueChaned:(NSNotification*)notification
{
    self.alivedTime = [notification.userInfo[@"aliveTime"] floatValue];
    self.totalHongbaos = [notification.userInfo[@"doubleHongbao"] floatValue];
    self.totalTime = [notification.userInfo[@"totalTime"] floatValue];
}

-(FXLabel*)fxLabel
{
    if (_fxLabel == nil) {
        
        _fxLabel = [[FXLabel alloc]initWithFrame:CGRectMake(0, 0, 200, 60)];
        _fxLabel.shadowColor = [UIColor blackColor];
        _fxLabel.shadowOffset = CGSizeZero;
        _fxLabel.shadowBlur = 20.0f;
        _fxLabel.innerShadowColor = [UIColor yellowColor];
        _fxLabel.innerShadowOffset = CGSizeMake(1.0f, 2.0f);
        _fxLabel.gradientStartColor = [UIColor redColor];
        _fxLabel.gradientEndColor = [UIColor yellowColor];
        _fxLabel.gradientStartPoint = CGPointMake(0.0f, 0.5f);
        _fxLabel.gradientEndPoint = CGPointMake(1.0f, 0.5f);
        _fxLabel.oversampling = 2;
    }
    
    return _fxLabel;
}

//初始化开始界面
-(void)initScene
{
 
    //UIImageView * imageView = [UIImageView alloc]initWithFrame:CGRectMake(0, 0,  , )
    
    //重要配置
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"aliveTime"] )
    {
        self.alivedTime = [[[NSUserDefaults standardUserDefaults]objectForKey:@"aliveTime"]floatValue];
    }
    else
    {
        self.alivedTime = 0.2;//跟生理极限有关
        
    }
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"totalTime"] )
    {
        self.totalTime = [[[NSUserDefaults standardUserDefaults]objectForKey:@"totalTime"]floatValue];
    }
    else
    {
        self.totalTime = 20;  //关系到出现的红包数，总红包是不变的

    }
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"doubleHongbao"] )
    {
        self.twoHongbaosO = [[[NSUserDefaults standardUserDefaults]objectForKey:@"doubleHongbao"]floatValue];
    }
    else
    {
        self.twoHongbaosO = 0.5;
        
    }
    
    
    
    self.totalHongbaos = 0;
    
    self.tappedHongbaoCount = 0;
    //红包提示
    //demonstrate multi-part gradient

    [self.view addSubview:self.fxLabel];

    [self showPoints];
    
   // NSMutableAttributedString *
    
    
    half_hypotenuse = hypot(imageWidth, imageHeight) / 2.0;
    self.gameLevel = 0;
    self.maxCount = 3;
    self.sprites = [NSMutableArray array];
    self.gapTime = 0.1;
    self.gapShowingCount = 0;
    
    
    _lastOriginXY = CGPointZero;
    
    
    [self countToStart];
    
    [MusicManager defaultManager].delegate = self;
    
}


-(void)countToStart
{
    
    [[MusicManager defaultManager]playCountDownSound];
    
   [self singleCountImageWithName:@"big_num3" WithDuraution:1.0 withCompletion:^(BOOL finished)
    {
        [self singleCountImageWithName:@"big_num2" WithDuraution:1.0 withCompletion:^(BOOL finished) {
            
            [self singleCountImageWithName:@"big_num1" WithDuraution:1.0 withCompletion:^(BOOL finished) {
                
                [self singleCountImageWithName:@"go" WithDuraution:1.0 withCompletion:^(BOOL finished) {
                    
                    
                }];
            }];
            
        }];
   }];
  
}


-(void)musicManagerPlayCountDownDidFinish
{
    //开始播放背景音乐
    [[MusicManager defaultManager]playBackgroupSound];
    
    _startedInterval = [NSDate timeIntervalSinceReferenceDate];
    self.hongbaoDrawingtimer =  [NSTimer scheduledTimerWithTimeInterval:self.gapTime target:self selector:@selector(insert) userInfo:nil repeats:YES];
}


-(void)singleCountImageWithName:(NSString*)imgName WithDuraution:(NSTimeInterval)duration  withCompletion:(void (^ __nullable)(BOOL finished))completion
{
    UIImage * image = [UIImage imageNamed:imgName];
    
    CGPoint point = self.view.center;
    
    UIButton * button = nil;
    
    if ([imgName rangeOfString:@"big_num"].length> 0)
    {
      button =  [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 151, 153)];
    }
    else
    {
        button =  [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 293, 132)];

    }
    
    button.center = point;
    [button setImage:image forState:UIControlStateNormal];
    
    [self.view addSubview:button];
    
    button.transform = CGAffineTransformMakeScale(3.0, 3.0);
    
    [UIView animateWithDuration:duration animations:^{
        button.alpha = 0.0f;
        button.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [button removeFromSuperview];
        if (completion) {
            completion(finished);
        }
    }];
}

-(void)showPoints
{
    self.fxLabel.text = [NSString stringWithFormat:@"获得红包 * %d", self.tappedHongbaoCount];

}

/**  返回已经花掉的游戏时间 */
-(NSTimeInterval)gamePlayedTime
{

    return [NSDate timeIntervalSinceReferenceDate] - _startedInterval;
}

-(void)gameOver
{
    [[MusicManager defaultManager]stopBackgroupSound];
    [self.hongbaoDrawingtimer invalidate];
    self.hongbaoDrawingtimer = nil;

    NSString * message = [NSString stringWithFormat:@"一共生成了%d个红包，您获得了%d个红包",self.totalHongbaos,self.tappedHongbaoCount];
    [WCAlertView showAlertWithTitle:@"戳红包结束！" message:message customizationBlock:nil completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        
        if(buttonIndex == 1)
        {
            [self initScene];
        }
        
        if(buttonIndex == 0)
        {
            [self presentViewController:[ConfigureViewController new] animated:YES completion:nil];
            
            
        }
        
    } cancelButtonTitle:nil otherButtonTitles:@"调节参数", @"重试",nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)insert
{
    if ([self gamePlayedTime] > self.totalTime)
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
        self.gameLevel = arc4random() % 10 + 4;
        //self.gameLevel = arc4random() % 10 -4;
        
        if(self.sprites.count > self.maxCount)
        {
            return;
        }
        
        if (self.gameLevel <= (10-1+4) * self.twoHongbaosO ) {
            [self generateOnHongbao];
        }
        [self generateOnHongbao];
    }
}

//改进：增加出现两个红包的情况
-(void)generateOnHongbao
{
    NSString * imgName = [NSString stringWithFormat:@"luckytap_sprite%d",arc4random()%6+0];
    UIImage * image = [UIImage imageNamed:imgName];
    
    CGPoint point = [self potisionOriginalGenerate];
    
    UIButton * hongbaoButon = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
    hongbaoButon.center = point;
    [hongbaoButon setImage:image forState:UIControlStateNormal];
    [hongbaoButon addTarget:self action:@selector(hongbaoTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.totalHongbaos ++;
    [self.view addSubview:hongbaoButon];
    [self.sprites addObject:hongbaoButon];
    
    
    [NSTimer scheduledTimerWithTimeInterval:self.alivedTime target:self selector:@selector(hongbaoDisappeared:) userInfo:@{@"button":hongbaoButon} repeats:NO];
}

-(CGPoint)potisionOriginalGenerate
{
    float x = 0, y =0 ;
    while (true)
    {
        
       // if (_lastOriginXY.x == 0 && _lastOriginXY.y == 0 )
        {
            x= arc4random() % (int)( CGRectGetWidth(self.view.frame) - imageWidth) + imageWidth/2;
            y= (arc4random() % (int)(CGRectGetHeight(self.view.frame) - imageHeight)) + imageHeight/2;
        }
        /*
        else
        {
            
            int columm  = arc4random()%2 + 1;// 1 或 2;
            int row = arc4random()%3 ; //  1 2 3
            int xDelta = 0;
           // int yDelta = 0;
            
            NSLog(@"x1 left value : %f", max(WindowWidth/3 - imageWidth/2 , imageWidth/2));
            NSLog(@"x1 right value : %f", WindowWidth * 2/3 - imageWidth/2);

            NSLog(@"x2 left value : %f", WindowWidth/3 );
            NSLog(@"x2 right value : %f", WindowWidth- imageWidth/2);

            
            switch (xDelta)
            {
                case 1:
                    xDelta =  (arc4random() % 30)   - imageWidth/2 ;
                    break;
                    
                case 2:
                    
                    xDelta =  (arc4random() % 30)   ;

                    break;
                    
                default:
                    break;
            }
            
            x =  columm *  (WindowWidth/3) + xDelta ;
            
            NSLog(@"x value : %f", x);
            
            y =( arc4random( ) %  130) -  imageHeight/2 + row *  (WindowHeight/3) ;
            
            NSLog(@"y value : %f", y);

            
            if (x < imageWidth /2 && x > WindowWidth -imageWidth/2  ) {
                
                continue;
            }
            
            if (y < imageHeight /2 + imageHeight  &&  y > WindowWidth -imageHeight/2  ) {
                
                continue;
            }
        }
        */
        BOOL isGot = YES;
        for (UIButton * button in self.sprites)
        {
            NSLog(@"xy %f",hypotf(x-button.center.x,y- button.center.y));

            if (hypotf( x-button.center.x,y- button.center.y)* 2 < half_hypotenuse + 250) {
                isGot = NO;
                break;
            }
        }
        
        if (isGot) {
            _lastOriginXY = CGPointMake(x, y);
            break;
        }
    }
    
    return CGPointMake(x, y);

}


-(void)hongbaoTapped:(UIButton*)button
{
    [[MusicManager defaultManager]playTapGetSound];
    self.tappedHongbaoCount ++;
    [self showPoints];
    
    //这里是红包点击的逻辑
    [self hongbaoDisappearedWithDuraution:0 Button:button withCompletion:^(BOOL finished) {
        
        UIImage * image = [UIImage imageNamed:@"luckytap_plus"];
        
        CGPoint point = CGPointMake(button.center.x, button.center.y );

        UIButton * hongbaoButon = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 258, 81)];
        hongbaoButon.center = point;
        [hongbaoButon setImage:image forState:UIControlStateNormal];
        [self.view addSubview:hongbaoButon];
       [self.sprites addObject:hongbaoButon];
        
        [UIView animateWithDuration:0.1 delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            hongbaoButon.center = CGPointMake(point.x, point.y - 20);

        } completion:^(BOOL finished) {
            [self.sprites removeObject:hongbaoButon];
            [hongbaoButon removeFromSuperview];
        }];
    }];
}

-(void)hongbaoDisappearedWithDuraution:(NSTimeInterval)duration Button:(UIButton*)button withCompletion:(void (^ __nullable)(BOOL finished))completion
{

    [UIView animateWithDuration:duration animations:^{
        button.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [button removeFromSuperview];
        [self.sprites removeObject:button];
        
        if (completion) {
            completion(finished);
        }
    }];
}


-(void)hongbaoDisappeared:(NSTimer*)timer
{
    [[MusicManager defaultManager]playTapAirSound];

    UIButton * button =  timer.userInfo[@"button"];
    [self hongbaoDisappearedWithDuraution:0.1 Button:button withCompletion:nil];
}


@end
