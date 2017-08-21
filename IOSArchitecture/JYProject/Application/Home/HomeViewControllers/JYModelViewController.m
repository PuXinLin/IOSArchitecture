//
//  JYModelViewController.m
//  JYProject
//
//  Created by dayou on 2017/8/1.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JYModelViewController.h"

static NSString * const url = @"http://120.25.226.186:32812/resources/videos/minion_02.mp4";

@interface JYModelViewController ()<NSURLSessionDataDelegate>
/* 返回按钮 */
@property (nonatomic ,strong)UIButton *backButton;
/* task */
@property (nonatomic ,strong)NSURLSessionDataTask *task;
/* task */
@property (nonatomic ,strong)NSURLSessionDataTask *fisrtTwoTask;
/* session */
@property (nonatomic ,strong)NSURLSession *session;
/* write */
@property (nonatomic ,strong)NSOutputStream *outputStream;
/* timer */
@property (nonatomic ,strong)NSTimer *timer;
/* time */
@property (nonatomic ,assign)NSInteger time;

@end

@implementation JYModelViewController

#pragma mark ---------- Life Cycle ----------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resizeCustomView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self.session invalidateAndCancel];
}
-(void)dealloc{
    JY_Log(@"释放了");
}

#pragma mark ---------- Private Methods ----------

#pragma mark 数据请求
-(void)loadRequestData{
    
    /* 开始计时器 */
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.001 repeats:YES block:^(NSTimer * _Nonnull timer) {
        _time++;
    }];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    /* 重新连接下载 */
    NSString *fileName = [self getFilePtchWithFileName:@"/minion_02.mp4"];
    NSInteger range = [self getFileSizeWithPath:fileName];
    NSString *rangeString = [NSString stringWithFormat:@"bytes=%zd-",range];
    [request setValue:rangeString forHTTPHeaderField:@"Range"];
    
    _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    _task = [_session dataTaskWithRequest:request];
    _fisrtTwoTask = [_session dataTaskWithRequest:request];
    [_task resume];
    [_fisrtTwoTask resume];
}

#pragma mark 页面初始化
-(void)resizeCustomView{
    self.view.backgroundColor = [UIColor whiteColor];
    /* 点击按钮 */
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(100);
        make.top.equalTo(self.view.mas_top).offset(100);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
}
#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------
#pragma mark NSURLSessionDataDelegate
#pragma mark 接收到服务器响应的时候调用
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    NSInteger size = response.expectedContentLength;
    JY_Log(@"%zd", size);

    NSString *fileName = [self getFilePtchWithFileName:@"/minion_02.mp4"];
    /* 输出流 追加数据在文件末尾 没有文件默认创建 */
    _outputStream =[[NSOutputStream alloc]initToFileAtPath:fileName append:YES];

    [_outputStream open];
    completionHandler(NSURLSessionResponseAllow);
}
#pragma mark 接收到服务器返回数据时调用，会调用多次
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [_outputStream write:data.bytes maxLength:data.length];
    JY_Log(@"%ld",dataTask.taskIdentifier);
    //NSLog(@"didReceiveData 接受到服务器返回数据");
}

#pragma mark 当请求完成之后调用，如果请求失败error有值
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    [_outputStream close];
    JY_Log(@"用时: %zd 毫秒", _time);
    JY_Log(@"didCompleteWithError 请求完成");
    JY_Log(@"%@", [self getFilePtchWithFileName:@"/minion_02.mp4"]);
}

#pragma mark 获取路径
-(NSString*)getFilePtchWithFileName:(NSString*)fileName
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [docPath stringByAppendingString:fileName];
}

#pragma mark 获取文件大小
-(NSInteger)getFileSizeWithPath:(NSString*)path
{
    NSFileManager * fileManger = [NSFileManager defaultManager];
    NSDictionary *dic = [fileManger attributesOfItemAtPath:path error:nil];
    return [dic[@"NSFileSize"] integerValue];
}
#pragma mark ---------- Lazy Load ----------

-(UIButton *)backButton{
    if (!_backButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@"按钮" forState:UIControlStateNormal];
        [self.view addSubview:button];
        _backButton = button;
        button.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            [self loadRequestData];
            return [RACSignal empty];
        }];
    }
    return _backButton;
}

@end
