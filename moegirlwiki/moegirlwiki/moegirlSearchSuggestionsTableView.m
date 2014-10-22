//
//  moegirlSearchSuggestionsTableView.m
//  moegirlwiki
//
//  Created by master on 14-10-22.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import "moegirlSearchSuggestionsTableView.h"

@implementation moegirlSearchSuggestionsTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_suggestions == nil) {
        return 0;
    }
    return _suggestions.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
    cell.textLabel.text = [_suggestions objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    return cell;
}

- (NSString *)urlEncode:(NSString*)unencodeString
{
    NSString * encodedString = (NSString*) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)unencodeString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));
    return encodedString;
}

- (void)checkSuggestions:(NSString *)keyword 
{
    if (![keyword isEqualToString:lastKeyword]) {
        lastKeyword = keyword;
        [requestConnection cancel];
        requestConnection = nil;
        
        NSString * requestURL = [[NSString alloc] initWithFormat:@"%@/api.php?action=opensearch&format=json&search=%@&namespace=0",_targetURL,[self urlEncode:lastKeyword]];
        NSMutableURLRequest * TheRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestURL]
                                                                        cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                    timeoutInterval:20];
        requestConnection = [[NSURLConnection alloc]initWithRequest:TheRequest
                                                           delegate:self
                                                   startImmediately:YES];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _recievePool = [NSMutableData new];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_recievePool appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",error.localizedDescription);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString * preProcessStr = [[NSString alloc] initWithData:_recievePool encoding:NSUTF8StringEncoding];
    NSRange rangeA = [preProcessStr rangeOfString:@"\",["];
    preProcessStr = [preProcessStr substringWithRange:NSMakeRange(rangeA.location + 2, preProcessStr.length - rangeA.location - 3)];
    NSData * preparedData = [preProcessStr dataUsingEncoding:NSUTF8StringEncoding];
    _suggestions = [NSJSONSerialization JSONObjectWithData:preparedData
                                                   options:NSJSONReadingMutableLeaves
                                                     error:nil];
    if (_suggestions != nil) {
        [self reloadData];
    }
}


@end
