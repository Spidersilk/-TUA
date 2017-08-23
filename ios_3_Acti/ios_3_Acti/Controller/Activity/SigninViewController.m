//
//  SigninViewController.m
//  ios_3_Acti
//
//  Created by admin on 2017/8/19.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "SigninViewController.h"

@interface SigninViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
- (IBAction)signAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong, nonatomic) UIActivityIndicatorView *avi;


@end

@implementation SigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    // Do any additional setup after loading the view.
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
    //为导航条左上角创建一个按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = left;
}
//用model的方式返回上一页
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];//用push返回上一页
}

- (IBAction)signAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if(_userTextField.text.length == 0){
        [Utilities popUpAlertViewWithMsg:@"请输入您的手机号" andTitle:nil onView:self];
        return;
    }
    if(_pwdTextField.text.length == 0){
        [Utilities popUpAlertViewWithMsg:@"请输入您的密码" andTitle:nil onView:self];
        return;
    }
    if(_pwdTextField.text.length < 6 || _pwdTextField.text.length > 18){
        [Utilities popUpAlertViewWithMsg:@"您的密码必须在6~18之间" andTitle:nil onView:self];
        return;
    }
    //判断某个字符串中是否每个字符都是数字(invertedSet:反向设置，Digits：数字)
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet]invertedSet];
    if(_userTextField.text.length < 11 || [_userTextField.text rangeOfCharacterFromSet:notDigits].location != NSNotFound){
        [Utilities popUpAlertViewWithMsg:@"请输入有效的手机号码" andTitle:nil onView:self];
        return;
    }
    //无输入异常的情况下，开始正式执行登录接口
    [self request];
    [self signRequest];
}
#pragma mark - 网络请求
//登录注册相关
- (void)request{
    NSString *str = [Utilities uniqueVendor];
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *prarmeter = @{@"deviceType" : @7001, @"deviceId" : str};
    //开始请求
    [RequestAPI requestURL:@"/login/getKey" withParameters:prarmeter andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //成功以后要做的事情
        //NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            
        }else{
            [_avi stopAnimating];
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
            [_avi stopAnimating];
            //失败以后要做的事情
            [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}
//登录网络请求
- (void)signRequest{
    NSString *str = [Utilities uniqueVendor];
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *prarmeter = @{@"userName" : _userTextField.text, @"password" : _pwdTextField.text, @"deviceType" : @7001, @"deviceId" : str};
    //开始请求
    [RequestAPI requestURL:@"/login" withParameters:prarmeter andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject) {
        [_avi stopAnimating];
    //成功以后要做的事情
    NSLog(@"responseObject = %@",responseObject);
    if ([responseObject[@"resultFlag"] integerValue] == 8001) {
        
    }else{
        
    }
} failure:^(NSInteger statusCode, NSError *error) {
    //失败以后要做的事情
    //NSLog(@"statusCode = %ld",(long)statusCode);
    
    [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
}];
}
#pragma mark - 收起键盘
//按键盘上的Return键收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//按键盘以外的任意部位收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
