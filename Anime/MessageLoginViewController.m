//
//  MessageLoginViewController.m
//  Anime
//
//  Created by wkf on 15/10/26.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "MessageLoginViewController.h"

@interface MessageLoginViewController ()

-(void)login:(void (^)(BOOL isSuccessful,BmobUser *user,NSError *error))block;

@end

@implementation MessageLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"登录";
//    self.view.backgroundColor=[UIColor colorWithRed:1.000 green:0.984 blue:0.984 alpha:1.000];
    [self creatView];
    // Do any additional setup after loading the view.
}
//创建子视图
- (void)creatView{
    
    //返回按钮设置
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithTitle:@"<back" style:UIBarButtonItemStyleDone target:self action:@selector(goBacks)];
    self.navigationItem.leftBarButtonItem=backItem;
    
    //注册按钮设置
    UIBarButtonItem *registeredItem=[[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(registered)];
    self.navigationItem.rightBarButtonItem=registeredItem;
    
    //手机号文本
    self.phoneNumberTxt=[[UITextField alloc] initWithFrame:CGRectMake(WIDTH*0.053333333, HEIGHT*0.14992503, WIDTH*0.893333333, HEIGHT*0.059970015)];
    self.phoneNumberTxt.layer.borderWidth=1.0f;
    self.phoneNumberTxt.layer.borderColor=[[UIColor colorWithRed:0/255.0 green:0/255.0  blue:0/255.0  alpha:0.3] CGColor];
    self.phoneNumberTxt.delegate=self;
    [self.phoneNumberTxt.layer setCornerRadius:10];
    self.phoneNumberTxt.keyboardType=UIKeyboardTypeNumberPad;
    self.phoneNumberTxt.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.phoneNumberTxt.placeholder=@"请输入手机号";
    [self.view addSubview:self.phoneNumberTxt];
    
    //验证码文本
    self.smsCodeTextField=[[UITextField alloc] initWithFrame:CGRectMake(WIDTH*0.053333333, HEIGHT*0.2398801, WIDTH*0.53333333, HEIGHT*0.02998501*2)];
    self.smsCodeTextField.keyboardType=UIKeyboardTypeNumberPad;
    self.smsCodeTextField.layer.borderWidth=1.0f;
    self.smsCodeTextField.layer.borderColor=[[UIColor colorWithRed:0/255.0 green:0/255.0  blue:0/255.0  alpha:0.3] CGColor];
    self.smsCodeTextField.delegate=self;
    self.smsCodeTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.smsCodeTextField.placeholder=@"请输入验证码";
    [self.smsCodeTextField.layer setCornerRadius:10];
    [self.view addSubview:self.smsCodeTextField];
    
    //发送验证码按钮
    self.sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.sendBtn.frame=CGRectMake(WIDTH*0.64, HEIGHT*0.2398801, WIDTH*0.3066666667, HEIGHT*0.02998501*2);
    [self.sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//    self.sendBtn.backgroundColor=[UIColor blueColor];
    [self.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendBtn.layer setCornerRadius:10];
    [self.sendBtn.layer setMasksToBounds:YES];
//    [self.sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sendBtn];
    
    //登陆按钮
    self.loginBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.loginBtn.frame=CGRectMake(WIDTH*0.053333333, HEIGHT*0.35980090, WIDTH*0.893333333, HEIGHT*0.02998501*2);
    [self.loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginBtn.layer setCornerRadius:10];
    [self.view addSubview:self.loginBtn];
    
    //设置服务密码登陆按钮下划线
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:@"服务密码登陆"];
    NSRange strRange1 = {0,[str1 length]};
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:strRange1];  //设置颜色
    [str1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange1];
    //服务密码登陆按钮
    self.serviceBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.serviceBtn.frame=CGRectMake(WIDTH*0.053333333, HEIGHT*0.44977511, WIDTH*0.4, HEIGHT*0.0599701);
    [self.serviceBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.serviceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.serviceBtn setAttributedTitle:str1 forState:UIControlStateNormal];
    [[self.serviceBtn titleLabel] setFont:[UIFont systemFontOfSize:15]];
//    [self.serviceBtn addTarget:self action:@selector(servicedenglu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.serviceBtn];
    
    //设置忘记密码登陆按钮下划线
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"忘记密码"];
    NSRange strRange2 = {0,[str2 length]};
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:strRange2];  //设置颜色
    [str2 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange2];
    //忘记密码登陆按钮
    self.forgetPasswordBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.forgetPasswordBtn.frame=CGRectMake(WIDTH*0.5413333333, HEIGHT*0.44977511, WIDTH*0.4, HEIGHT*0.0599701);
    [self.forgetPasswordBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.forgetPasswordBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.forgetPasswordBtn setAttributedTitle:str2 forState:UIControlStateNormal];
    [[self.forgetPasswordBtn titleLabel] setFont:[UIFont systemFontOfSize:15]];
    [self.forgetPasswordBtn addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forgetPasswordBtn];
    
    //背景图片
    UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT*0.44977511+HEIGHT*0.0599701, 1.2*WIDTH, HEIGHT-HEIGHT*0.44977511-HEIGHT*0.0599701)];
    image.image=[UIImage imageNamed:@"bgImage"];
    [self.view addSubview:image];
    
    RACSignal *phoneNumberSignal = [self.phoneNumberTxt.rac_textSignal map:^id(id value) {
        return @([value length] == 11 ? YES : NO);
    }];
    
    [phoneNumberSignal subscribeNext:^(id x) {
        if ([x boolValue]) {
            self.sendBtn.backgroundColor=[UIColor blueColor];
            self.sendBtn.enabled = YES;
        }else{
            self.sendBtn.backgroundColor=[UIColor grayColor];
            self.sendBtn.enabled = NO;
        }
    }];
    
    RACSignal *smsSignal = [self.smsCodeTextField.rac_textSignal map:^id(id value) {
        return @([value length] == 6 ? YES : NO);
    }];
    
    RACSignal *loginValidSignal = [RACSignal combineLatest:@[phoneNumberSignal,smsSignal] reduce:^id(NSNumber *phoneValid,NSNumber *smsValid){
        return @([phoneValid boolValue] && [smsValid boolValue]);
    }];
    
    [loginValidSignal subscribeNext:^(id x) {
        if ([x boolValue]) {
            self.loginBtn.backgroundColor=[UIColor blueColor];
            self.loginBtn.enabled = YES;
        }else{
            self.loginBtn.backgroundColor=[UIColor grayColor];
            self.loginBtn.enabled = NO;
        }
    }];
    
    [[self.sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //请求验证码
//        [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.phoneNumberTxt.text andTemplate:nil resultBlock:^(int number, NSError *error) {
//            if(error){
//                
//            } else {
//                
//            }
//        }];
        self.timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(daojishi) userInfo:nil repeats:YES];
        
        [self.sendBtn setTitle:@"已发送 60s" forState:UIControlStateNormal];
        [self.sendBtn setEnabled:NO];
        [self.sendBtn setBackgroundColor:[UIColor grayColor]];
        [self.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.sendBtn setAlpha:0.7];
        self.time =60;
    }];
    
}

-(void)clickLogin{
    @weakify(self)
    [[[[[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(id x) {
        
    }] flattenMap:^RACStream *(id value) {
        return [self loginSignal];
    }] deliverOnMainThread] subscribeNext:^(BmobUser *user) {
        [self.navigationController popViewControllerAnimated:YES];
    } error:^(NSError *error) {
        @strongify(self);
        
        NSLog(@"%@",error);
        [self clickLogin];
    }];
}

//验证码倒计时
-(void)daojishi
{
    self.time--;
    NSString *str =[NSString stringWithFormat:@"已发送 %ds",self.time];
    [self.sendBtn setTitle:str forState:UIControlStateNormal];
    if (self.time==0) {
        [self.sendBtn setAlpha:1.0];
        [self.sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.sendBtn setBackgroundColor:[UIColor blueColor]];
        [self.sendBtn setEnabled:YES];
        //时间控件停止
        [self.timer invalidate];
    }
}
-(RACSignal *)loginSignal{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self login:^(BOOL isSuccessful, BmobUser *user, NSError *error) {
            if (isSuccessful) {
                [subscriber sendNext:user];
                [subscriber sendCompleted];
            }else{
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}
-(void)login:(void (^)(BOOL, BmobUser *, NSError *))block{
    //查询手机号是否已存在
    BmobQuery *query =[BmobUser query];
    [query whereKey:@"mobilePhoneNumber" equalTo:self.phoneNumberTxt.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error)
     {
         if (array.count==0)
         {
             NSError *err = [NSError errorWithDomain:@"您输入的账号尚未注册,请点击上方注册按钮" code:998 userInfo:nil];
             block(NO,nil,err);
             
         }
         else if(array.count>0)
         {
             [BmobUser loginInbackgroundWithMobilePhoneNumber:self.phoneNumberTxt.text andSMSCode:self.smsCodeTextField.text block:^(BmobUser *user, NSError *error)
              {
                  if (user)
                  {
                      block(YES,user,nil);
                      /*
                      //进入首页
                      [self.navigationController popViewControllerAnimated:YES];
                       */
                  }
                  else
                  {
                      NSError *err =[NSError errorWithDomain:@"验证码输入错误" code:999 userInfo:nil];
                      block(NO,nil,err);
                  }
              }];
         }
     }];
}

//跳转到服务密码登陆页面的方法
-(void)servicedenglu{
    LoginViewController *login=[[LoginViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
}
//返回到个人中心页面
- (void)goBacks{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//跳转到到注册页面
- (void)registered{
    [self.navigationController pushViewController:[RegisteredViewController new] animated:YES];
}
//跳转到到忘记密码页面
- (void)forgetPassword{
    ForgetPasswordViewController *forget=[[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:forget animated:YES];

}
//隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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

@end
