//
//  ViewController.m
//  CNScrollView-Demo
//
//  Created by mac on 15-3-19.
//  Copyright (c) 2015年 Baby_V5. All rights reserved.
//

#import "ViewController.h"
#import "CNScrollView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 

    NSArray*arr = @[@"10",@"11",@"12",@"13",@"14",@"15"]; //图片名数组
    
    CNScrollView*scroll = [[CNScrollView alloc]initWithFrame:kScreenBounds];
    
    scroll.itemsCount = 10;
    
    scroll.dataList = arr;
    
    scroll.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:scroll];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"=======View======");
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

    NSLog(@"move");
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
