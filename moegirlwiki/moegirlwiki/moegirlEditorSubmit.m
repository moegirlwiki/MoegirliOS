//
//  moegirlEditorSubmit.m
//  moegirlwiki
//
//  Created by Michael Chan on 14/12/22.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import "moegirlEditorSubmit.h"

@implementation moegirlEditorSubmit

- (NSString *)urlEncode:(NSString *)unencodedStr
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (CFStringRef)unencodedStr,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8 ));
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _recievePool = [NSMutableData new];
    _responsePool = [NSURLResponse new];
    _responsePool = response;
    
    [self.hook addStatus:@"正在接收数据"];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_recievePool appendData:data];
    [self.hook addStatus:@"."];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.hook addStatus:@"\n数据接收完毕！\n"];
    [self finishRequest];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.hook addStatus:[NSString stringWithFormat:@"连接错误:%@",[error localizedDescription]]];
}

-(void)cancelRequest
{
    [requestConnection cancel];
    [self setHook:nil];
}

-(void)submitRequest
{
    [self.hook addStatus:@"正在备份到本地.\n"];
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * wikitextDocumentPath = [[documentPath stringByAppendingPathComponent:@"data"]  stringByAppendingPathComponent:@"editorBackup"];
    [_wikiTextString writeToFile:wikitextDocumentPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [self.hook addStatus:@"备份成功！\n编辑的内容可以在[设置]->[恢复编辑数据]中找回\n"];
    [self.hook addStatus:@"正在连接萌娘百科服务器.\n这个过程可能需要数秒时间\n"];
    NSString *RequestURL = @"http://zh.moegirl.org/api.php";
    //POST的内容
    NSString *RequestContent = [NSString stringWithFormat:@"action=%@&format=%@&title=%@&text=%@&summary=%@&token=%@&basetimestamp=%@",
                                @"edit",
                                @"json",
                                [self urlEncode:_edit_title],
                                [self urlEncode:_wikiTextString],
                                [self urlEncode:@"//来自萌娘百科iOS客户端"],
                                [self urlEncode:_edit_token],
                                [self urlEncode:_edit_startTime]
                                ];
    NSMutableURLRequest * TheRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:RequestURL]
                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                               timeoutInterval:120];
    [TheRequest setHTTPMethod:@"POST"];
    [TheRequest setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [TheRequest setHTTPShouldHandleCookies:YES];
    [TheRequest setHTTPBody:[RequestContent dataUsingEncoding:NSUTF8StringEncoding]];
    requestConnection = [[NSURLConnection alloc]initWithRequest:TheRequest
                                                       delegate:self];
}

-(void)finishRequest
{
    NSLog(@"%@",_responsePool);
    NSLog(@"%@",[[NSString alloc]initWithData:_recievePool encoding:NSUTF8StringEncoding]);
    
    NSDictionary *theData = [[NSJSONSerialization JSONObjectWithData:_recievePool
                                                             options:NSJSONReadingMutableLeaves
                                                               error:nil]
                             objectForKey:@"error"];
    if (theData != nil) {
        [self.hook addStatus:@"发生错误！"];
        NSString * errorinfo = [theData objectForKey:@"info"];
        [self.hook addStatus:[NSString stringWithFormat:@"错误原因：%@\n",errorinfo]];
        if ([errorinfo isEqualToString:@"Edit conflict detected"]) {
            [self.hook addStatus:@"遗憾，编辑冲突发生了！\n这个错误常发生在更新频繁的条目，\n有人在你更新页面之前提交了更新。\n请[刷新]页面查看最新版，\n并在[设置]中获取你曾作出的修改。\n"];
        }
    }else{
        NSDictionary *theData = [[NSJSONSerialization JSONObjectWithData:_recievePool
                                                                     options:NSJSONReadingMutableLeaves
                                                                       error:nil]
                                     objectForKey:@"edit"];
        NSString *respondResult = [theData objectForKey:@"result"];
        NSString *respondTime = [theData objectForKey:@"newtimestamp"];
        if ([theData objectForKey:@"captcha"]!=nil) {
            [self.hook addStatus:@"非常抱歉，编辑功能目前仅支持[自动确认用户]。\n你编辑的内容已经备份，可以在设置中找回。\n"];
        }
        [self.hook addStatus:[NSString stringWithFormat:@"提交结果：%@\n",respondResult]];
        if (respondTime == nil){
            [self.hook addStatus:@"没有受理时间，可能是由于没有改动造成的。\n"];
        }else{
            [self.hook addStatus:[NSString stringWithFormat:@"受理时间戳：%@\n",respondTime]];
            if ([respondResult isEqualToString:@"Success"]) {
                [self.hook addStatus:@"更新成功！！！\n关闭本页后点击菜单中的[刷新]即可查看最新页面\n"];
            }
        }
    }
    
    [self.hook addStatus:@"---进程结束---"];
    [self setHook:nil];
}

@end
