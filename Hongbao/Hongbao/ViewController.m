//
//  ViewController.m
//  Hongbao
//
//  Created by Robin on 05/01/16.
//  Copyright © 2016年 Yate. All rights reserved.
//

#import "ViewController.h"
#import "FXLabel.h"

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
@property(nonatomic,assign)int tappedHongbaoCount;

@property(nonatomic,assign)FXLabel * fxLabel;
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
 
    //UIImageView * imageView = [UIImageView alloc]initWithFrame:CGRectMake(0, 0,  , )
    

    
    self.tappedHongbaoCount = 0;
    //红包提示
    //demonstrate multi-part gradient
    FXLabel * fxLabel = [[FXLabel alloc]initWithFrame:CGRectMake(0, 0, 200, 60)];
    fxLabel.shadowColor = [UIColor blackColor];
    fxLabel.shadowOffset = CGSizeZero;
    fxLabel.shadowBlur = 20.0f;
    fxLabel.innerShadowColor = [UIColor yellowColor];
    fxLabel.innerShadowOffset = CGSizeMake(1.0f, 2.0f);
    fxLabel.gradientStartColor = [UIColor redColor];
    fxLabel.gradientEndColor = [UIColor yellowColor];
    fxLabel.gradientStartPoint = CGPointMake(0.0f, 0.5f);
    fxLabel.gradientEndPoint = CGPointMake(1.0f, 0.5f);
    fxLabel.oversampling = 2;

    self.fxLabel = fxLabel;
    
    [self showPoints];
    [self.view addSubview:fxLabel];
    
   // NSMutableAttributedString *
    
    
    half_hypotenuse = hypot(imageWidth, imageHeight) / 2.0;
    self.gameLevel = 10;
    self.maxCount = 3;
    self.sprites = [NSMutableArray array];
    self.gapTime = 0.1;
    [NSTimer scheduledTimerWithTimeInterval:self.gapTime target:self selector:@selector(insert) userInfo:nil repeats:YES];
}

-(void)showPoints
{
    self.fxLabel.text = [NSString stringWithFormat:@"获得红包 * %d", self.tappedHongbaoCount];

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
        self.gameLevel = arc4random() % 10 + 4;
        //self.gameLevel = arc4random() % 10 -4;
        
        if(self.sprites.count > self.maxCount)
        {
            return;
        }
        
        if (self.gameLevel >= 10 * 0.6 + 4) {
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
    [hongbaoButon addTarget:self action:@selector(hongbaoTapped:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:hongbaoButon];
    [self.sprites addObject:hongbaoButon];
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(hongbaoDisappeared:) userInfo:@{@"button":hongbaoButon} repeats:NO];
}

-(CGPoint)potisionOriginalGenerate
{
    float x = 0, y =0 ;
    while (true)
    {
        
         x= arc4random() % (int)( CGRectGetWidth(self.view.frame) - imageWidth) + imageWidth/2;
         y= (arc4random() % (int)(CGRectGetHeight(self.view.frame) - imageHeight)) + imageHeight/2;
        
        BOOL isGot = YES;
        for (UIButton * button in self.sprites)
        {
            NSLog(@"xy %f",hypotf(x-button.center.x,y- button.center.y));

            if (hypotf( x-button.center.x,y- button.center.y)* 2 < half_hypotenuse + 50) {
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
       // [self.sprites addObject:hongbaoButon];
        
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            hongbaoButon.center = CGPointMake(point.x, point.y - 20);
            hongbaoButon.alpha = 0 ;

        } completion:^(BOOL finished) {
            
            [hongbaoButon removeFromSuperview];
        }];
    }];
}

-(void)hongbaoDisappearedWithDuraution:(NSTimeInterval)duration Button:(UIButton*)button withCompletion:(void (^ __nullable)(BOOL finished))completion
{
    [self.sprites removeAllObjects];

    [UIView animateWithDuration:duration animations:^{
        button.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [button removeFromSuperview];
        //[self.sprites removeObject:button];
        if (completion) {
            completion(finished);
        }
    }];
}


-(void)hongbaoDisappeared:(NSTimer*)timer
{
    UIButton * button =  timer.userInfo[@"button"];
    [self hongbaoDisappearedWithDuraution:0.3 Button:button withCompletion:nil];

}


@end
