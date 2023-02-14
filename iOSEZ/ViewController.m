//
//  ViewController.m
//  iOSEZ
//
//  Created by ezrealzhang on 2023/2/2.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) CAShapeLayer *tempLayer;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(200, 200, 200, 200)];
    [self.button addTarget:self action:@selector(temp) forControlEvents:UIControlEventTouchUpInside];
    self.button.backgroundColor = UIColor.yellowColor;
    
//    self.tempLayer = [CAShapeLayer layer];
//    self.tempLayer.backgroundColor = UIColor.redColor.CGColor;
//    self.tempLayer.frame = CGRectMake(0, 300, 100, 100);
//    self.tempLayer.strokeEnd = 1;
    [self teset];
    
    [self.button.layer addSublayer:self.tempLayer];
    
    [self.view addSubview:self.button];
}

- (void)teset {
    UIBezierPath *bezierPath=[UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(self.button.frame.size.width/4, self.button.frame.size.height/2)];
    [bezierPath addLineToPoint:CGPointMake(self.button.frame.size.width/2, self.button.frame.size.height/4*3)];
    [bezierPath addLineToPoint:CGPointMake(self.button.frame.size.width/4*3, self.button.frame.size.height/3)];


    CAShapeLayer *shape=[CAShapeLayer layer];


      shape.lineWidth=17;
      shape.fillColor=[UIColor clearColor].CGColor;
      shape.strokeColor=[UIColor colorWithRed:0.76f green:0.89f blue:0.89f alpha:1.00f].CGColor;
      shape.lineCap = kCALineCapRound;
      shape.lineJoin = kCALineJoinRound;

      shape.path=bezierPath.CGPath;
      
    self.tempLayer = shape;
    self.tempLayer.strokeEnd = 0;
}
- (void)temp {
//    [CATransaction setDisableActions:YES];
    // @ezrealzhang 明天来看看
    /**
     问题
        1. 如果不 sleep，直接在主线程跑这个 for 循环，就不会更新，只会等到最后一刻才更新
            reason：因为主线程 runloop 一直在做这个 for 循环，没法去对 隐式动画 进行 commit transaction
        2. 抖动问题（本来是个递增的过程，但是中途穿插了 减 的过程），肯定跟屏幕刷新有关，已经模拟出来了（显示动画 也有这个问题）
            // 1. 是否是因为 render server 中，draw calls 是 cpu 来执行的，render 是 gpu 执行的。cpu 并发执行，导致 gpu 渲染顺序不一致？
            // 1. 这里模拟的，在 120 Hz 下没发生卡顿，在 60 Hz 下发生了，这是什么原因？ iphone 13 pro max 的 cpu 性能比 iphone 12 的高？那为什么秒剪上面还是出现了？
        3. 最后 大概 1/3 的阶段，动画变快了，一下就完成了（隐式动画、显式动画都有这种情况）
            感觉就像 只执行了最后的那个 strokeEnd = 1 的隐式动画
            reason：上一个动画被取消，执行新来的动画（最后一个），0.25s，所以很快就完成了
     
     4. 有三种方法让下面的动画不卡顿
        1. 减少隐式动画执行频率
        2. 减少隐式动画执行时间
        3. 禁掉 隐式动画（不执行动画）
     */
    
    /**
     0.023
     0.003
     */
    [CATransaction begin];
    self.tempLayer.strokeEnd = 0;
    [CATransaction commit];
    // i > 1 才会出现抖动，如果是 1 就没有，很奇怪. strokeEnd 字段有问题
    NSThread *thread1 = [[NSThread alloc] initWithBlock:^{
        for (CGFloat i = 0; i <= 10; i += 0.001076) {
            // 0.016
            // 0.008
            [NSThread sleepForTimeInterval:0.001];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                [CATransaction setDisableActions:YES];
//                [CATransaction setAnimationDuration:0.01];
//                [CATransaction begin];
//                self.tempLayer.strokeEnd = i;
//                [CATransaction commit];
                
                [self.tempLayer removeAllAnimations];
                CABasicAnimation *animation = [[CABasicAnimation alloc] init];
                animation.fromValue = @(0);
                animation.toValue = @(i);
                animation.fillMode = kCAFillModeRemoved;
                [animation setRemovedOnCompletion:YES];
                [self.tempLayer addAnimation:animation forKey:@"strokeEnd"];
                
                NSLog(@"ezez i :%f, s :%f", i, [CATransaction animationDuration]);
            }];
        }
    }];
    [thread1 start];

    
    
    // 旭哥说，如果一个动画还没执行完，下一个动画就来了，这个时候前一个动画会被 cancel 掉，此时显示会根据一个 CABasicAnimation 的参数 CAMediaTimingFillMode，来决定 mode 层到底是到 presentation 层的位置，还是说到动画设置的最终位置
    // CABasicAnimation 有个参数 CAMediaTimingFillMode 与 removedOnCompletion 配合使用
    
    
    
    
    
    
    // 其他情况，便于理解
//    for (float i = 0; i < 1; i += 0.00107) {
//        self.tempLayer.strokeEnd = i;
//    }
    
//    for (float i = 0; i < 1; i += 0.00107) {
//        [CATransaction begin];
//        self.tempLayer.strokeEnd = i;
//        [CATransaction commit];
//    }
    
//
//    [UIView animateWithDuration:10 animations:^{
//        self.tempLayer.strokeEnd = 0.5;
//    } completion:nil];
//
//    [UIView animateWithDuration:10 animations:^{
//        self.tempLayer.strokeEnd = 1;
//    } completion:nil];
}


@end


