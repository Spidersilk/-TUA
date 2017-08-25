//
//  DetailViewController.m
//  ios_3_Acti
//
//  Created by admin1 on 2017/8/1.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "DetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
@property (weak, nonatomic) IBOutlet UILabel *applyFeeLabel;
- (IBAction)applyAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
@property (weak, nonatomic) IBOutlet UILabel *applyStateLbl;
@property (weak, nonatomic) IBOutlet UILabel *attentdenceLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *issuerLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *applyDueLbl;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIView *applyStartView;
@property (weak, nonatomic) IBOutlet UIView *applyDueView;
@property (weak, nonatomic) IBOutlet UIView *applyIngView;
@property (weak, nonatomic) IBOutlet UIView *applyEndView;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self networkRequest];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//这个方法专门做导航条的控制
- (void)naviConfig{
    //设置导航条标题的文字
    self.navigationItem.title = _activity.name;
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
    
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
}
- (void)networkRequest{
    UIActivityIndicatorView *avi = [Utilities getCoverOnView:self.view];
    NSString *request =[NSString stringWithFormat:@"/event/%@",_activity.activityId];
    NSLog(@"%@",request);
    NSMutableDictionary *parmeters = [NSMutableDictionary new];
    if([Utilities loginCheck]){
        [parmeters setObject:[[StorageMgr singletonStorageMgr] objectForKey:@"MemberId"] forKey:@"memberId"];
    }
    [RequestAPI requestURL:request withParameters:parmeters andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        [avi stopAnimating];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary *result = responseObject[@"result"];
            _activity = [[ActivityModel alloc]initWhitDictionaryDictionary:result];
            [self uiLayout];
        }else{
            [avi stopAnimating];
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}
- (IBAction)applyAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if([Utilities loginCheck]){
        
    }else{
        //获取要跳转过去的那个页面
        UINavigationController *signNavi = [Utilities getStoryboardInstance:@"Member" byIdentity:@"SignNavi"];
        //执行跳转
        [self presentViewController:signNavi animated:YES completion:nil];
    }
}
- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //配置“电话”App的路径,并将要拨打的号码组合到路径中
    NSString *targetAppStr = [NSString stringWithFormat:@"%@", _activity.issurephone];
    
    NSURL *targetAppUrl = [NSURL URLWithString:targetAppStr];
    //从当前App跳转到其他指定的App中
    [[UIApplication sharedApplication] openURL:targetAppUrl];
    
}
- (void)uiLayout{
    [_activityImageView sd_setImageWithURL:[NSURL URLWithString:_activity.imgUrl] placeholderImage:[UIImage imageNamed:@"png2"]];
    _applyFeeLabel.text = [NSString stringWithFormat:@"%@元", _activity.applyFee];
    _attentdenceLbl.text = [NSString stringWithFormat:@"%@/%@", _activity.attendence, _activity.limitation];
    _typeLbl.text = _activity.atype;
    _issuerLbl.text = _activity.issure;
    _addressLbl.text = _activity.address;
    [_phoneBtn setTitle:[NSString stringWithFormat:@"联系活动发布者:%@", _activity.issurephone] forState:UIControlStateNormal];
    _contentLbl.text = _activity.content;
    NSString *dueTimeStr = [Utilities dateStrFromCstampTime:_activity.dueTime withDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *startTimeStr = [Utilities dateStrFromCstampTime:_activity.startTime withDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *endTimeStr = [Utilities dateStrFromCstampTime:_activity.endTime withDateFormat:@"yyyy-MM-dd HH:mm"];
    _timeLbl.text = [NSString stringWithFormat:@"%@ ~ %@", startTimeStr, endTimeStr];
    _applyDueLbl.text = [NSString stringWithFormat:@"报名截止时间(%@)",dueTimeStr];
    //获取什么时候调用这方法这个时间
    NSDate *now = [NSDate date];
    NSTimeInterval nowTime = [now timeIntervalSince1970InMilliSecond];
    _applyStartView.backgroundColor = [UIColor grayColor];
    if(nowTime >= _activity.dueTime){
        _applyDueView.backgroundColor = [UIColor grayColor];
        _applyBtn.enabled = NO;
        [_applyBtn setTitle:@"报名截止" forState:UIControlStateNormal];
        if(nowTime >= _activity.startTime){
            _applyIngView.backgroundColor = [UIColor grayColor];
            if(nowTime >= _activity.endTime){
                _applyEndView.backgroundColor = [UIColor grayColor];
            }
        }
    }
    if(_activity.attendence >= _activity.limitation){
        _applyBtn.enabled = NO;
        [_applyBtn setTitle:@"活动满员" forState:UIControlStateNormal];
    }
    switch (_activity.status) {
        case 0:
            _applyStateLbl.text = @"已取消";
            break;
        case 1:
            _applyStateLbl.text = @"代付款";
            [_applyBtn setTitle:@"去付款" forState:UIControlStateNormal];
            break;
        case 2:
            _applyStateLbl.text = @"已报名";
            [_applyBtn setTitle:@"已报名" forState:UIControlStateNormal];
            _applyBtn.enabled = NO;
            break;
        case 3:
            _applyStateLbl.text = @"退款中";
            [_applyBtn setTitle:@"退款中" forState:UIControlStateNormal];
            _applyBtn.enabled = NO;
            break;
        case 4:
            _applyStateLbl.text = @"已退款";
            break;
        
        default:{
            _applyStateLbl.text = @"待报名";
        }
            break;
    }
}
@end
