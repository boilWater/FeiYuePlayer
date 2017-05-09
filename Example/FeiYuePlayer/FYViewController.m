//
//  FYViewController.m
//  FeiYuePlayer
//
//  Created by boilwater on 04/12/2017.
//  Copyright (c) 2017 boilwater. All rights reserved.
//

#import "FYViewController.h"
#import "ArrayDataSource.h"
#import "LeftViewCell.h"
#import "LeftViewCell+ItemConfigureForCell.h"
#import "FYShowViewController.h"
#import "FYCameraViewController.h"
#import "FYEditorViewController.h"

@interface FYViewController ()<UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ArrayDataSource *dataSource;
@property (nonatomic, strong) NSArray *dataArray;

@end

static NSString * const identifer = @"LeftViewCell";

@implementation FYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self initalizerCustomParamter];
}

- (void)didReceiveMemoryWarning {
    
}

#pragma mark - privatedMethod(initalizerCustomParamter)

- (void)initalizerCustomParamter {
    self.title = @"FeiYuePlayer";
}

#pragma mark - getter & setter

- (UITableView *)tableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.delegate = self;
    
    TakenConfigureCellBlock configureCellBlock = ^(LeftViewCell *cell, id item){
        [cell ItemConfigureForCell:item];
    };
    
    _dataSource = [[ArrayDataSource alloc] initItems:self.dataArray cellIdentifer:identifer takenConfigureCellBlock:configureCellBlock];
    _tableView.dataSource = _dataSource;
    [_tableView registerNib:[LeftViewCell nib] forCellReuseIdentifier:identifer];
    
    return _tableView;
}

- (NSArray *)dataArray {
    _dataArray = [NSArray arrayWithObjects:@"FeiYuePlayer 实例",@"FYEditor 视频剪切", @"使用 GPUImage 添加滤镜",nil];
    return _dataArray;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController;
    switch (indexPath.row) {
        case 0:
        {
            viewController = [[FYShowViewController alloc] init];
            break;
        }
        case 1:
        {
            viewController = [[FYEditorViewController alloc] init];
            break;
        }
        case 2:
        {
            viewController = [[FYCameraViewController alloc] init];
            break;
        }

        default:
            break;
    }
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
