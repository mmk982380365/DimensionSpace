//
//  LoginViewController.m
//  Anime
//
//  Created by wkf on 15/10/26.
//  Copyright (c) 2015年 wkf. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<TencentSessionDelegate>
/**
 *  登录模块
 */
@property (strong,nonatomic) TencentOAuth *oAuth;

@property (strong,nonatomic) MessageLoginViewController *msgVc;

@property (strong,nonatomic) UIView *msgView;

@property (strong,nonatomic) UIView *normalView;

-(void)login:(void (^)(BOOL isSuccessful,BmobUser *user,NSError *error))resultBlock;

@end

@implementation LoginViewController

//-(void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.988 green:0.294 blue:0.216 alpha:1.000];
//    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
//    self.tabBarController.tabBar.hidden =NO;
//}

-(RACSignal *)QQDidNotLoginSignal{
    return [self rac_signalForSelector:@selector(tencentDidNotLogin:) fromProtocol:@protocol(TencentSessionDelegate)];
}

-(RACSignal *)QQDidNotNetworkSignal{
    return [self rac_signalForSelector:@selector(tencentDidNotNetWork) fromProtocol:@protocol(TencentSessionDelegate)];
}

-(RACSignal *)QQLoginSuccessSignal{
    return [self rac_signalForSelector:@selector(tencentDidLogin) fromProtocol:@protocol(TencentSessionDelegate)];
}

-(RACSignal *)QQGetUserInfo{
    return [self rac_signalForSelector:@selector(getUserInfoResponse:) fromProtocol:@protocol(TencentSessionDelegate)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.view.backgroundColor=[UIColor colorWithRed:1.000 green:0.984 blue:0.984 alpha:1.000];
    self.title=@"登录";
    
    [self creatView];
    [self RAC];
}
//创建子视图
- (void)creatView{
    self.msgVc=[[MessageLoginViewController alloc] init];
    [self addChildViewController:self.msgVc];
    self.msgView=[[UIView alloc] initWithFrame:self.view.bounds];
    self.msgView.backgroundColor=[UIColor colorWithRed:1.000 green:0.984 blue:0.984 alpha:1.000];
    [self.view addSubview:self.msgView];
    [self.msgView addSubview:self.msgVc.view];
//    [self.msgVc.serviceBtn addTarget:self action:@selector(normaldenglu) forControlEvents:UIControlEventTouchUpInside];
    
    self.normalView=[[UIView alloc] initWithFrame:self.view.bounds];
    self.normalView.backgroundColor=[UIColor colorWithRed:1.000 green:0.984 blue:0.984 alpha:1.000];
    [self.view addSubview:self.normalView];
    
    //注册按钮设置
    UIBarButtonItem *registeredItem=[[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(registered)];
    self.navigationItem.rightBarButtonItem=registeredItem;
    
    //用户名文本
    self.userNameTxt=[[UITextField alloc] initWithFrame:CGRectMake(WIDTH*0.053333333, HEIGHT*0.14992503, WIDTH*0.893333333, HEIGHT*0.059970015)];
    self.userNameTxt.layer.borderWidth=1.0f;
    self.userNameTxt.layer.borderColor=[[UIColor colorWithRed:0/255.0 green:0/255.0  blue:0/255.0  alpha:0.3] CGColor];
    self.userNameTxt.delegate=self;
    [self.userNameTxt.layer setCornerRadius:10];
    self.userNameTxt.returnKeyType=UIReturnKeyNext;
    self.userNameTxt.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.userNameTxt.placeholder=@"请输入用户名/手机号";
    [self.normalView addSubview:self.userNameTxt];
    
    //密码文本
    self.userPwdTextField=[[UITextField alloc] initWithFrame:CGRectMake(WIDTH*0.053333333, HEIGHT*0.2398801, WIDTH*0.893333333, HEIGHT*0.059970015)];
    self.userPwdTextField.layer.borderWidth=1.0f;
    self.userPwdTextField.layer.borderColor=[[UIColor colorWithRed:0/255.0 green:0/255.0  blue:0/255.0  alpha:0.3] CGColor];
    self.userPwdTextField.delegate=self;
    self.userPwdTextField.returnKeyType=UIReturnKeyNext;
    self.userPwdTextField.secureTextEntry=YES;
    self.userPwdTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.userPwdTextField.placeholder=@"请输入密码";
    [self.userPwdTextField.layer setCornerRadius:10];
    [self.normalView addSubview:self.userPwdTextField];
    
    //打钩按钮
    self.tickBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.tickBtn.frame=CGRectMake(WIDTH*0.053333333, HEIGHT*0.3298351, WIDTH*0.05333333, HEIGHT*0.029985);
    [self.tickBtn setImage:[UIImage imageNamed:@"dagou1"] forState:UIControlStateNormal];
    [self.tickBtn setImage:[UIImage imageNamed:@"dagou2"] forState:UIControlStateSelected];
    [self.tickBtn addTarget:self action:@selector(dagou) forControlEvents:UIControlEventTouchUpInside];
    [self.normalView addSubview:self.tickBtn];
    
    //记住密码标签
    self.rememberPasswordLbl=[[UILabel alloc] initWithFrame:CGRectMake(WIDTH*0.133333333, HEIGHT*0.3298351, WIDTH*0.32666666667, HEIGHT*0.029985)];
    self.rememberPasswordLbl.text=@"记住密码";
    [self.normalView addSubview:self.rememberPasswordLbl];
    
    //登陆按钮
    self.loginBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.loginBtn.frame=CGRectMake(WIDTH*0.053333333, HEIGHT*0.3898051, WIDTH*0.893333333, HEIGHT*0.05997001);
    
    [self.loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [self.loginBtn addTarget:self action:@selector(denglu) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn.layer setCornerRadius:10];
    [self.normalView addSubview:self.loginBtn];
    
    //设置短信密码登陆按钮下划线
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:@"短信密码登陆"];
    NSRange strRange1 = {0,[str1 length]};
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:strRange1];  //设置颜色
    [str1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange1];
    
    //短信密码登陆按钮
    self.messageBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.messageBtn.frame=CGRectMake(WIDTH*0.053333333, HEIGHT*0.47976012, WIDTH*0.4, HEIGHT*0.05997001);
    [self.messageBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.messageBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.messageBtn setAttributedTitle:str1 forState:UIControlStateNormal];
    [[self.messageBtn titleLabel] setFont:[UIFont systemFontOfSize:15]];
    [self.normalView addSubview:self.messageBtn];
    
    if ([TencentOAuth iphoneQQInstalled]) {
        //第三方字体标签
        UILabel *thirdLoginLbl=[[UILabel alloc] initWithFrame:CGRectMake(self.messageBtn.frame.origin.x, self.messageBtn.frame.size.height+self.messageBtn.frame.origin.y, 180, 20)];
        thirdLoginLbl.text=@"第三方登陆";
        [self.normalView addSubview:thirdLoginLbl];
        //初始化登陆模块
        self.oAuth=[[TencentOAuth alloc] initWithAppId:@"1104847098" andDelegate:self];
        //初始化按钮
        self.QQBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            self.QQBtn.frame=CGRectMake(self.messageBtn.frame.origin.x, self.messageBtn.frame.size.height+self.messageBtn.frame.origin.y+30, 60.5, 64);
        }else{
            self.QQBtn.frame=CGRectMake(self.messageBtn.frame.origin.x, self.messageBtn.frame.size.height+self.messageBtn.frame.origin.y+30, 30.25, 32);
        }
        
        [self.QQBtn setImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
//        [self.QQBtn addTarget:self action:@selector(loginWithQQ) forControlEvents:UIControlEventTouchUpInside];
        [self.normalView addSubview:self.QQBtn];
    }
    
    
    //设置忘记密码登陆按钮下划线
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"忘记密码"];
    NSRange strRange2 = {0,[str2 length]};
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:strRange2];  //设置颜色
    [str2 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange2];
    //忘记密码登陆按钮
    self.forgetPasswordBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.forgetPasswordBtn.frame=CGRectMake(WIDTH*0.5413333333, HEIGHT*0.47976012, WIDTH*0.4, HEIGHT*0.0599701);
    [self.forgetPasswordBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.forgetPasswordBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.forgetPasswordBtn setAttributedTitle:str2 forState:UIControlStateNormal];
    [[self.forgetPasswordBtn titleLabel] setFont:[UIFont systemFontOfSize:15]];
    [self.normalView addSubview:self.forgetPasswordBtn];
    
    //背景图片
    UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT*0.47976012+HEIGHT*0.0599701, 1.2*WIDTH, HEIGHT-HEIGHT*0.47976012-HEIGHT*0.059970)];
    image.image=[UIImage imageNamed:@"bgImage"];
    [self.normalView addSubview:image];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isRemember"]) {
        self.userNameTxt.text=[[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
        self.userPwdTextField.text=[[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
        self.tickBtn.selected=YES;
    }else{
        self.tickBtn.selected=NO;
    }
    //加载视图初始化
    self.hud=[[MBProgressHUD alloc] initWithView:self.view];
    self.hud.mode=MBProgressHUDModeCustomView;
    [self.normalView addSubview:self.hud];
    UIImageView *loadView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    //设置gif图片
    NSData *imgData=[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"]];
    loadView.image=[UIImage sd_animatedGIFWithData:imgData];
    self.hud.customView=loadView;
    self.hud.detailsLabelColor=[UIColor grayColor];
    self.hud.detailsLabelText=@"努力加载中";
    self.hud.backgroundColor=[UIColor clearColor];
    self.hud.color=[UIColor clearColor];
    
}

-(void)RAC{
    [[self.QQBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSArray *permissions=@[@"get_user_info",@"get_simple_userinfo",@"add_t"];
        self.hud.detailsLabelText=@"努力加载中";
        //显示加载视图
        [self.hud show:YES];
        [self.oAuth authorize:permissions inSafari:NO];
    }];
    
    [[self QQDidNotNetworkSignal] subscribeNext:^(id x) {
        self.hud.mode=MBProgressHUDModeText;
        self.hud.detailsLabelText=@"网络连接错误，请检查您的网络问题";
        //隐藏加载视图
        [self.hud hide:YES afterDelay:2];
    }];
    
    [[self QQDidNotLoginSignal] subscribeNext:^(id x) {
        self.hud.mode=MBProgressHUDModeText;
        self.hud.detailsLabelText=@"登陆失败，请重试";
        //隐藏加载视图
        [self.hud hide:YES afterDelay:2];
    }];
    
    RACSignal *qqLoginSuccessSignal = [self QQLoginSuccessSignal];
    
    [qqLoginSuccessSignal subscribeNext:^(id x) {
        NSDictionary *responseDictionary = @{@"access_token": self.oAuth.accessToken,@"uid":self.oAuth.openId,@"expirationDate":self.oAuth.expirationDate};
        [BmobUser loginInBackgroundWithAuthorDictionary:responseDictionary platform:BmobSNSPlatformQQ block:^(BmobUser *user, NSError *error) {
            [user setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"] forKey:@"deviceToken"];
            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    [self.oAuth getUserInfo];
                }
            }];
        }];
        NSLog(@"%@",x);
    }];
    
    RACSignal *getUserInfoSignal = [self QQGetUserInfo];
    
    [[getUserInfoSignal map:^id(RACTuple *tuple) {
        return tuple.first;
    }] subscribeNext:^(APIResponse *response) {
        NSDictionary *dic=response.jsonResponse;
        BmobUser *currentUser=[BmobUser getCurrentUser];
        [currentUser setObject:dic[@"nickname"] forKey:@"name"];
        [currentUser setObject:dic[@"figureurl_qq_2"] forKey:@"iconImg"];
        [currentUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                //隐藏加载视图
                [self.hud hide:YES];
                //进入首页
                [self.navigationController popViewControllerAnimated:YES];
                //                                  NSLog(@"登录成功,进入首页");
            }
        }];
    }];
    
    [[self.forgetPasswordBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        ForgetPasswordViewController *forget=[[ForgetPasswordViewController alloc] init];
        [self.navigationController pushViewController:forget animated:YES];
    }];
    
    [[self.messageBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.view bringSubviewToFront:self.msgView];
    }];
    
    [RACObserve(self.tickBtn, selected) subscribeNext:^(id x) {
        BOOL isRemember = [x boolValue];
        if (isRemember) {
            [[NSUserDefaults standardUserDefaults] setObject:self.userNameTxt.text forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:self.userPwdTextField.text forKey:@"password"];
        }else{
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
        }
        NSLog(@"%@",x);
    }];
    
    //    self.tickBtn
    
    @weakify(self);
    RACSignal *usernameRac = [self.userNameTxt.rac_textSignal map:^id(id value) {
        return @([value length] > 10 ? YES : NO);
    }];
    
    RACSignal *passwordRac = [self.userPwdTextField.rac_textSignal map:^id(id value) {
        return @(([value length] > 5 && [value length] < 21)? YES : NO);
    }];
    
    RACSignal *mergeSignal = [RACSignal combineLatest:@[usernameRac,passwordRac] reduce:^id(NSNumber *usernameValid,NSNumber *passwordValid){
        return @([usernameValid boolValue] && [passwordValid boolValue]);
    }];
    
    [mergeSignal subscribeNext:^(id x) {
        @strongify(self);
        BOOL success = [x boolValue];
        if (success) {
            self.loginBtn.backgroundColor=[UIColor blueColor];
            self.loginBtn.enabled = YES;
        }else{
            self.loginBtn.backgroundColor=[UIColor grayColor];
            self.loginBtn.enabled = NO;
        }
    }];
    [[self.msgVc.serviceBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.view bringSubviewToFront:self.normalView];
    }];
    [self loginAct];
}

-(void)loginAct{
    @weakify(self)
    [[[[[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(id x) {
        @strongify(self);
        self.hud.mode = MBProgressHUDModeCustomView;
        self.hud.detailsLabelText=@"努力加载中";
        [self.hud show:YES];
        self.loginBtn.enabled = NO;
    }] flattenMap:^RACStream *(id value) {
        @strongify(self);
        return [self signalForNormalLogin];
    }] deliverOnMainThread] subscribeNext:^(BmobUser *user) {
        @strongify(self);
        self.loginBtn.enabled = YES;
        if (user) {
            //保存推送所需的deviceToken
            [user setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"] forKey:@"deviceToken"];
            [user updateInBackground];
            //隐藏加载视图
            [self.hud hide:YES];
            //进入首页
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            //            self.loginBtn.backgroundColor=[UIColor blueColor];
            self.loginBtn.enabled = YES;
            NSLog(@"error");
        }
        
    } error:^(NSError *error) {
        @strongify(self);
        self.hud.mode = MBProgressHUDModeText;
        self.loginBtn.enabled = YES;
        self.hud.detailsLabelText = error.domain;
        [self.hud hide:YES afterDelay:2];
        NSLog(@"%@",error);
        [self loginAct];
    }];
}

-(void)login:(void (^)(BOOL, BmobUser *, NSError *))resultBlock{
    BmobQuery *query =[BmobUser query];
    [query whereKey:@"mobilePhoneNumber" equalTo:self.userNameTxt.text];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error)
     {
         if (array.count==0)
         {
             NSError *err = [NSError errorWithDomain:@"账号尚未注册" code:955 userInfo:nil];
             resultBlock(NO,nil,err);
         }
         else if(array.count>0)
         {
             [BmobUser loginInbackgroundWithAccount:self.userNameTxt.text andPassword:self.userPwdTextField.text block:^(BmobUser *user, NSError *error)
              {
                  if (user)
                  {
                      resultBlock(YES,user,nil);
                  }
                  else
                  {
                      NSError *err = [NSError errorWithDomain:@"手机号或密码错误" code:955 userInfo:nil];
                      resultBlock(YES,nil,err);                  }
              }];
         }
     }];
}

-(RACSignal *)signalForNormalLogin{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //查询手机号是否已存在
        @strongify(self);
        [self login:^(BOOL isSuccessful, BmobUser *user, NSError *error) {
            
            if (error) {
                [subscriber sendError:error];
            }else{
                [subscriber sendNext:user];
                [subscriber sendCompleted];
            }
        }];
        
        return nil;
    }];
}
/*
-(void)denglu{
    self.hud.detailsLabelText=@"努力加载中";
    //显示加载视图
    [self.hud show:YES];
    //判断手机号和密码不能为空
    if (self.userNameTxt.text.length==0||self.userPwdTextField.text.length==0)
    {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号或密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        //判断输入手机号是否为11位数字
        NSString *str =self.userNameTxt.text;
        NSString *regex =@"[0-9]{11}";
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        if (self.userNameTxt.text.length!=0&&![predicate evaluateWithObject:str])
        {
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入的手机号格式错误,请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            //查询手机号是否已存在
            BmobQuery *query =[BmobUser query];
            [query whereKey:@"mobilePhoneNumber" equalTo:self.userNameTxt.text];
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error)
             {
                 if (array.count==0)
                 {
                     UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入的账号尚未注册,请点击下方立即注册按钮" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                     [alert show];
                     
                 }
                 else if(array.count>0)
                 {
                     [BmobUser loginInbackgroundWithAccount:self.userNameTxt.text andPassword:self.userPwdTextField.text block:^(BmobUser *user, NSError *error)
                      {
                          if (user)
                          {
                              //按照记住密码选项记录密码
                              if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isRemember"]) {
                                  [[NSUserDefaults standardUserDefaults] setObject:self.userNameTxt.text forKey:@"username"];
                                  [[NSUserDefaults standardUserDefaults] setObject:self.userPwdTextField.text forKey:@"password"];
                              }else{
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
                              }
                              //保存推送所需的deviceToken
                              [user setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"] forKey:@"deviceToken"];
                              [user updateInBackground];
                              //隐藏加载视图
                              [self.hud hide:YES];
                              //进入首页
                              [self.navigationController popViewControllerAnimated:YES];
                          }
                          else
                          {
                              UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号或密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                              [alert show];
                          }
                      }];
                 }
             }];
        }
    }
}
*/

-(void)tencentDidNotLogin:(BOOL)cancelled{
    
}
//-(void)getUserInfoResponse:(APIResponse *)response{
//    NSDictionary *dic=response.jsonResponse;
//    BmobUser *currentUser=[BmobUser getCurrentUser];
//    [currentUser setObject:dic[@"nickname"] forKey:@"name"];
//    [currentUser setObject:dic[@"figureurl_qq_2"] forKey:@"iconImg"];
//    [currentUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//        if (isSuccessful) {
//            //隐藏加载视图
//            [self.hud hide:YES];
//            //进入首页
//            [self.navigationController popViewControllerAnimated:YES];
//            //                                  NSLog(@"登录成功,进入首页");
//        }
//    }];
//}
//打钩的方法
-(void)dagou{
    if (self.tickBtn.selected==NO) {
        self.tickBtn.selected=YES;
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"isRemember"];
    }else{
        self.tickBtn.selected=NO;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isRemember"];
    }
}
//-(void)loginWithQQ{
//    NSArray *permissions=@[@"get_user_info",@"get_simple_userinfo",@"add_t"];
//    self.hud.detailsLabelText=@"努力加载中";
//    //显示加载视图
//    [self.hud show:YES];
//    [self.oAuth authorize:permissions inSafari:NO];
//}
//跳转到首页页面方法

//-(void)normaldenglu{
//    
//}
//返回到个人中心页面
- (void)goBacks{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//跳转到到注册页面
- (void)registered{
    [self.navigationController pushViewController:[RegisteredViewController new] animated:YES];
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
