//
//  TYTableViewVc.m
//  TYSnapshotScroll
//
//  Created by apple on 16/12/26.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import "TYTableViewVc.h"
#import "TYSnapshot.h"


@interface TYTableViewVc ()
<
    UITableViewDataSource,
    UITableViewDelegate
>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *button;
@end

@implementation TYTableViewVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self tableViewInit];
    [self buttonInit];
}

-(void )tableViewInit{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    
    self.tableView.delegate = (id)self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView reloadData];
}

- (void )buttonInit
{
    if (!self.button) {
        CGFloat buttonW = 150;
        CGFloat buttonH = 50;
        CGFloat buttonX = (TYSnapshotMainScreenBounds.size.width - buttonW)/2;
        CGFloat buttonY = TYSnapshotMainScreenBounds.size.height - 2*buttonH;
        CGRect buttonFrame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        
        self.button = [[UIButton alloc] initWithFrame:buttonFrame];
        [self.view addSubview:self.button];
        [self.view bringSubviewToFront:self.button];
        self.button.layer.masksToBounds = YES;
        self.button.layer.cornerRadius = buttonW*0.05;
        self.button.backgroundColor = [UIColor redColor];
        
        
        self.button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.button setTitle:@"保存tableview为图片" forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(snapshotBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

- (void)snapshotBtn:(UIButton *)sender
{
    
    [TYSnapshot screenSnapshot:self.tableView finishBlock:^(UIImage *snapShotImage) {
        //保存相册
        UIImageWriteToSavedPhotosAlbum(snapShotImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
        [self.button setTitle:@"保存到相册,请稍后" forState:UIControlStateNormal];
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [self.button setTitle:@"保存tableview为图片" forState:UIControlStateNormal];
    
    //打印
    if (error == nil) {
        NSLog(@"-------保存成功---------");
    }else{
        NSLog(@"-------保存失败---------");
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"TYTableViewVcCell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"index = %@",@(indexPath.row)];
    
    return cell;
}
@end
