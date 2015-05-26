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
    lastKeyword = @"";
    firstTime = YES;
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
    if (firstTime) {
        return 0;
    }
    if (_suggestions == nil) {
        return 1;
    }
    return _suggestions.count + 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.textLabel.text = [NSString stringWithFormat:@"搜索：“%@”",lastKeyword];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        return cell;
    }else{
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.textLabel.text = [_suggestions objectAtIndex:indexPath.row - 1];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        return cell;
    }
}

- (NSString *)urlEncode:(NSString*)unencodeString
{
    NSString * encodedString = (NSString*) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)unencodeString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));
    return encodedString;
}

- (void)checkSuggestions:(NSString *)keyword 
{
    firstTime = NO;
    
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
    [self reloadData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Loaded");
    @try {
        NSString * preProcessStr = [[NSString alloc] initWithData:_recievePool encoding:NSUTF8StringEncoding];
        //NSLog(@"%@",preProcessStr);
        NSRange rangeA = [preProcessStr rangeOfString:@"\",["];
        NSRange rangeB = [preProcessStr rangeOfString:@"]"];
        preProcessStr = [preProcessStr substringWithRange:NSMakeRange(rangeA.location + 2, rangeB.location - rangeA.location - 1)];
        //NSLog(@"%@",preProcessStr);
        NSData * preparedData = [preProcessStr dataUsingEncoding:NSUTF8StringEncoding];
        _suggestions = [NSJSONSerialization JSONObjectWithData:preparedData
                                                       options:NSJSONReadingMutableLeaves
                                                         error:nil];
        [self reloadData];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    @finally {
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.hook cancelKeyboard];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * requestString;
    if (indexPath.row != 0) {
        requestString = [_suggestions objectAtIndex:indexPath.row - 1];
    }else{
        if (_suggestions.count > 0&&[lastKeyword isEqualToString:[_suggestions objectAtIndex:0]]) {
            requestString = lastKeyword;
        }else{
            requestString = [NSString stringWithFormat:@"Special:搜索/%@",lastKeyword];
        }
    }
    [self.hook newWebViewRequestFormSuggestions:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

@end
