//
//  MainViewController.m
//  youzanIOSDemo
//
//  Copyright (c) 2012-2015 © youzan.com. All rights reserved.
//

#import "MainViewController.h"
#import "JsBridgeModel.h"
#import "LoginDataModel.h"

static NSString *mainPageUrl = @"http://wap.koudaitong.com/v2/feature/sjcospr2";

@interface MainViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) NSString *ReqUrlStr;//如果有页面跳转的问题, 可以使用这个参数

@property (strong , nonatomic) IBOutlet UIWebView *webView;
@property (strong,nonatomic) UIView *backView;//返回的名称
@property (strong, nonatomic) UIBarButtonItem  *rightBarButtonItem;
@property (strong, nonatomic) UIButton *sysButton;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //默认打开的登陆方式
    [self initBackButton];
    
    _webView.delegate = self;
    
    [self initItem];
    
    self.ReqUrlStr = mainPageUrl;
    
    [self loadRequestFromString:self.ReqUrlStr];
}


/**
 *  初始化返回按钮
 */
- (void)initBackButton {
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 40, 44)];
    [self.view addSubview:_backView];
    
    UIButton *sysButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    //    [sysButton setTitle:@"返回" forState:UIControlStateNormal];
    [sysButton setImage:[UIImage imageNamed:@"icon_left_arrow"] forState:UIControlStateNormal];
    [sysButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [sysButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    sysButton.tag = 10001;
    
    [_backView addSubview:sysButton];
    
    _backView.hidden = YES;
    
}
/**
 *  初始化BarItem
 */
- (void)initItem{
    
    //leftItem
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:_backView];
    leftBar.style = UIBarButtonItemStylePlain;
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                  target:nil action:nil];
    spaceItem.width = -10;
    
    self.navigationItem.leftBarButtonItems = @[spaceItem,leftBar];
    
    _sysButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    //    [_sysButton setTitle:@"分享" forState:UIControlStateNormal];
    [_sysButton setImage:[UIImage imageNamed:@"icon_fengxiang"] forState:UIControlStateNormal];
    [_sysButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_sysButton addTarget:self action:@selector(sharePage) forControlEvents:UIControlEventTouchUpInside];
    _sysButton.tag = 10001;
    UIView *shareView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    [shareView addSubview:_sysButton];
    
    
    //rightItem
    _rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareView];
    _sysButton.hidden = YES;
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,_rightBarButtonItem];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRequestFromString:(NSString*)urlString {
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}


#pragma mark - Webview Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.navigationItem.title = @"载入中...";
    
    _sysButton.hidden = YES;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.navigationItem.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    [self.webView stringByEvaluatingJavaScriptFromString:[[JsBridgeModel sharedManage] JsBridgeWhenWebDidLoad]];//js文件初始化
    
    //返回按钮展示的判断
    if (self.webView.canGoBack && (![webView.request.URL.path isEqual:@"v2/showcase/feature"])) {
        _backView.hidden = NO;
    }else{
        _backView.hidden = YES;
    }
    
    if ([self.webView.request.URL.path isEqual:@"/v2/showcase/homepage"]) {
        _backView.hidden = YES;
    }
    
    NSArray *components = [self.webView.request.URL pathComponents];
    
    //对自定义页面的shareButton处理
    if (components.count <= 2) {
        _sysButton.hidden = NO;
    }
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    NSURL *url = [request URL];
    
    if(![[url absoluteString] hasPrefix:@"http"]){//非http
        
        NSString *jsBridageString = [[JsBridgeModel sharedManage] parseYOUZANScheme:url];
        
        if(jsBridageString) {
            
            if([jsBridageString isEqualToString:@"check_login"]) {//检测登陆 同步用户信息
                
                if (1) { //判断是否进行了登录
                    //已经登录
                    [self loginButtonClick:nil];
                }else{
                    //暂未登录
                    
                    /**
                     *登录处理
                     */
                    
                    //1.登录
                    //2.1.登录成功:   [self loginButtonClick:nil];
                    //2.2.登录登录失败: [self backButtonPressed:nil];
                    
                    return NO;
                    
                }
                
                
            } else if([jsBridageString isEqualToString:@"share_data"]) {//分享请求捕获
                
                NSDictionary * shareDic = [[JsBridgeModel sharedManage] ShareDataInfo:url];
                
                //分享
                
                
            } else if([jsBridageString isEqualToString:@"web_ready"]) { //页面资源加载完毕
                self.navigationItem.rightBarButtonItem.enabled = YES;
                
                //对有赞页面的shareButton处理
                NSArray *components = [self.webView.request.URL pathComponents];
                
                if (components.count > 2) {
                    if (([components[2] isEqualToString:@"orders"]) ||//屏蔽订单相关页面分享
                        ([components[2] isEqualToString:@"trades"]) ||//屏蔽交易相关页面分享
                        ([components[2] isEqualToString:@"trade"])  ||//屏蔽交易相关页面分享
                        ([components[2] isEqualToString:@"backs"])  ||//屏蔽金额相关页面分享
                        ([components[2] isEqualToString:@"usercenter"]) ) {//屏蔽用户中心相关页面分享
                        _sysButton.hidden = YES;
                    }else{
                        _sysButton.hidden = NO;
                    }
                    if ([components[1] isEqualToString:@"wxpay"]) { //屏蔽微信交易相关页面分享
                        _sysButton.hidden = YES;
                    }
                    if ([components[1] isEqualToString:@"pay"]) { //屏蔽银行卡支付相关页面分享
                        _sysButton.hidden = YES;
                    }
                    
                    if (components.count > 3) {
                        if ([components[2] isEqualToString:@"showcase"] && //屏蔽"我的记录"相关页面分享
                            [components[3] isEqualToString:@"usercenter"]) {
                            _sysButton.hidden = YES;
                        }
                    }
                    
                }
                
            }
        }
        return YES;
        
    } //非HTTP请求的处理
    
    return YES;
    
}


#pragma mark - Action

//登陆：采用有赞的Oauth2.0的登陆方式
- (IBAction)loginButtonClick:(id)sender {
    
    NSDictionary *userInfo  = @{@"gender":@"1",
                                @"user_id":@"1",
                                @"user_name":@"1",
                                @"telephone":@"11111111111",
                                @"nick_name":@"11",
                                @"avatar":@"http://test.jpg"};
    NSString *string = [[JsBridgeModel sharedManage]  webUserInfoLogin:userInfo];
    [self.webView stringByEvaluatingJavaScriptFromString:string];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"客户端数据同步到web" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (void)sharePage { //启动web分享回调
    NSString *urlHost = self.webView.request.URL.host;
    
    if ([urlHost isEqualToString:@"wap.koudaitong.com"]) {
        
        //对有赞链接的分享处理
        [self.webView stringByEvaluatingJavaScriptFromString:[[JsBridgeModel sharedManage] JsBridgeWhenShareBtnClick]];
    }else{
        
        //对非有赞链接的分享处理
        
    }

}


- (void) backButtonPressed:(UIButton *) sender {
    
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
}

@end
