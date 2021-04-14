//
//  ViewController.m
//  CommentDemo
//
//  Created by menghua liu on 2018/5/7.
//  Copyright © 2018年 hih-d-11371. All rights reserved.
//

#import "ViewController.h"
#import "STCommentEditView.h"


static NSString *identifire = @"identifier";
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<NFCommentEditViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    //创建数据源数组
    NSMutableArray *_dataArry;
}
@property (nonatomic, strong) STCommentEditView *editView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArry = [[NSMutableArray alloc]initWithObjects:@"第1",@"伍佰", nil];
    [self creatTableView];
    
    UIButton * testButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 80)];
    testButton.layer.borderColor = [[UIColor redColor] CGColor];
    testButton.layer.borderWidth = 2.f;
    [testButton setTitle:@"手机用户" forState:UIControlStateNormal];
    [testButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: testButton];
    

    
    self.editView = [[STCommentEditView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.editView.delegate = self;
    [self.view addSubview:self.editView];
    self.editView.hidden = YES;
}
- (void)buttonClick:(UIButton *)button {
    [self.editView updatePlaceholder:@"回复手机用户："];
    self.editView.hidden = NO;
    [self.editView show];

}
-(void)creatTableView{
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 280, self.view.frame.size.width, self.view.frame.size.height-280) style:UITableViewStylePlain];
    
    _tableView.dataSource =self;
    
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}
#pragma mark - UITableViewDataSource协议

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;//_dataArry.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArry.count; //[_dataArry[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identifire];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifire];
    }
    cell.textLabel.text=_dataArry[indexPath.row];
    return cell;
}
#pragma mark - NFCommentEditViewDelegate
- (void)commentEditView:(STCommentEditView *)commentEditView didRequsetStatus:(BOOL)success {
    if (success) {// NSLog(@"发送成功！");
        NSLog(@"输入的值:%@",  self.editView.content);
        
        [_dataArry insertObject: self.editView.content atIndex:_dataArry.count - 1];
        [_tableView reloadData];
        
        
        NSLog(@"数组行数:%lu",(unsigned long)_dataArry.count);
    } else {
        NSLog(@"发送失败");
    }
}


@end
