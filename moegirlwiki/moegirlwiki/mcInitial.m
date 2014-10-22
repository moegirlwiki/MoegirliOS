//
//  mcInitial.m
//  moegirlwiki
//
//  Created by master on 14-10-22.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import "mcInitial.h"

@implementation mcInitial

- (void)resetFiles
{
    
    NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
    
    
    /*
     ------初始化目录结构------
     /cache
     /cache/page
     /cache/image
     /data
     /data/mainpage
     /data/setting
     */
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:[[documentPath stringByAppendingPathComponent:@"cache"] stringByAppendingPathComponent:@"page"] withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createDirectoryAtPath:[[documentPath stringByAppendingPathComponent:@"cache"] stringByAppendingPathComponent:@"image"] withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createDirectoryAtPath:[[documentPath stringByAppendingPathComponent:@"data"] stringByAppendingPathComponent:@"mainpage"] withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createDirectoryAtPath:[[documentPath stringByAppendingPathComponent:@"data"] stringByAppendingPathComponent:@"setting"] withIntermediateDirectories:YES attributes:nil error:nil];
    
    
    
    /*初始化关键文件*/
    //1. 首页数据   /data/mainpage/mainpageCache
    NSString * mainpageDocumentPath = [[documentPath stringByAppendingPathComponent:@"data"] stringByAppendingPathComponent:@"mainpage"];
    NSString * tempFile = @"<div id=\"mainpage\"><div id=\"mainpage-a\"><div class=\"mainpage-newsbox\"><div class=\"mainpage-title\">你好~欢迎来到萌娘百科！</div><div class=\"mainpage-1stcontent\">请下拉刷新页面</div></div></div></div>";
    [tempFile writeToFile:[mainpageDocumentPath stringByAppendingPathComponent:@"mainpageCache"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
    //2.首页日期    /data/mainpage/mainpageDate
    tempFile = @"2014-10-20 12:00:00";
    [tempFile writeToFile:[mainpageDocumentPath stringByAppendingPathComponent:@"mainpageDate"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
    //3.默认页首    /data/setting/pageheader
    NSString * htmlDocumentPath = [[documentPath stringByAppendingPathComponent:@"data"] stringByAppendingPathComponent:@"setting"];
    tempFile = @"<!DOCTYPE html><html lang=\"zh\" dir=\"ltr\" class=\"client-nojs\"><head><meta charset=\"UTF-8\" /><link rel=\"stylesheet\" href=\"http://bits.moegirl.org/zh/load.php?debug=false&amp;lang=zh&amp;modules=ext.echo.badge%7Cext.gadget.Backtotop%2CForce_preview%2CSearchbox-popout%7Cext.rtlcite%7Cmediawiki.legacy.commonPrint%2Cshared%7Cmediawiki.skinning.interface%7Cmediawiki.ui.button%7Cskins.vector.styles&amp;only=styles&amp;skin=vector&amp;*\" /><link rel=\"stylesheet\" href=\"http://bits.moegirl.org/zh/load.php?debug=false&amp;lang=zh&amp;modules=site&amp;only=styles&amp;skin=vector&amp;*\" /></head><body class=\"mediawiki ltr sitedir-ltr ns-0 ns-subject page-LoveLive skin-vector action-view vector-animateLayout\">";
    [tempFile writeToFile:[htmlDocumentPath stringByAppendingPathComponent:@"pageheader"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    //4.默认页脚    /data/setting/pagefooter
    tempFile = @"<style> body{-webkit-text-size-adjust: none;padding:10px !important;overflow-x:hidden !important;} p{clear:both !important;} #mw-content-text{ max-width: 100%; overflow: hidden;} .wikitable, table.navbox{ display:block; overflow-y:scroll;} .nowraplinks.mw-collapsible{width:300% !important; font-size:10px !important;} .navbox-title span{font-size:10px !important;} .backToTop{display:none !important;} .mw-search-pager-bottom,fieldset.rcoptions{display:none;} .searchresult{font-size: 10px !important;line-height: 13px;width: 100% !important;} form{display:none;} iframe{width:292px !important; height:auto;} #mw-pages .mw-content-ltr td, #mw-subcategories .mw-content-ltr td{float: left;display: block;clear: both;width: 90% !important;} h2{clear:both;} #catlinks.catlinks{margin-bottom:30px;float:left;}</style> <script>$(document).ready(function(){$(\".heimu\").click(function(){$(this).css(\"background\",\"#ffffff\")});});</script><script>!function(){$(function(){function t(t){var e=$(t).attr(\"style\");if(e){var l=[];return e=e.split(\";\"),$.each(e,function(){this.length&&a.test(this)&&l.push(this)}),l.join(\";\")}}function e(l){l=$(l);var o={collapsible:!1,open:!0};if(l.is(\"table\")){o.collapsible=l.is(\".mw-collapsible\"),o.open=l.is(\".autocollapse\")||l.is(\".mw-uncollapsed\");var n=l.find(\">tbody>tr>.navbox-title\");if(n.length){var i=n.find(\">span:not(.mw-collapsible-toggle)\"),a=i.children();if(a.find(\"small\").length){var s=a.html().split(\"<br>\");o.title=s[0],o.nav=$(s[1]).find(\"small\").html()}else o.title=a.is(\"div\")&&\"text-align:center; line-height:10pt\"==a.attr(\"style\")?a.html():i.html()}var r=[];l.find(\">tbody>tr\").filter(function(){return!$(this).find(\">.navbox-title\").length&&\"2px\"!=$(this).css(\"height\")}).each(function(){r.push(e(this))}),o.subgroup=r}else if(l.is(\"tr\")){var n=l.find(\">.navbox-group\");if(n.length){var p=t(n);p&&(o.titleStyle=p);var c=n.children();o.title=c.is(\"div\")&&\"padding:0em 0.75em;\"==c.attr(\"style\")?c.html():n.html()}var n=l.find(\">.navbox-list\");if(n.length)if(n.find(\">.navbox-subgroup\").length){var d=e(n.find(\">.navbox-subgroup\"));o.subgroup=d.title?[d]:d.subgroup}else{var p=t(n);p&&(o.contentStyle=p),o.content=n.html()}var n=l.find(\">.navbox-abovebelow\");n.length&&(o.title=n.html())}return o}function l(t){t=$(t);var l={subgroup:e(t.find(\">tbody>tr>td>.mw-collapsible\"))};return l}function o(t,e){if(e.collapsible&&(t.addClass(s+\"collapsible\"),e.open&&t.addClass(s+\"open\")),e.title){var l=$('<div class=\"'+s+'title\" />');if(l.html(e.title),t.append(l),e.titleStyle&&l.attr(\"style\",e.titleStyle),e.collapsible&&l.append('<div class=\"'+s+'toggle\"><span class=\"'+s+'status-close\">[展开]</span><span class=\"'+s+'status-open\">[折叠]</span></div>'),e.nav){var n=$('<div class=\"'+s+'nav\" />');l.append(n),l.addClass(s+\"has-nav\"),n.html(e.nav)}}if(e.content||e.subgroup){var i=$('<div class=\"'+s+'content\" />');if(t.append(i),e.content)e.contentStyle&&i.attr(\"style\",e.contentStyle),i.html(e.content);else{var a=$('<div class=\"'+s+'subgroup\" />').appendTo(i);$.each(e.subgroup,function(){o(a,this)})}}}function n(t){var e=$('<div class=\"'+s+'wrapper\" />'),l=$('<div class=\"'+s+'subgroup\" />');return e.append(l),o(l,t.subgroup),e}function i(t){var t=t||\".navbox\";$(t).each(function(){var t=$(this),e=l(t),o=n(e);o.bind(\"click\",function(t){var e=$(t.target);e.parent().hasClass(s+\"toggle\")&&(e.closest(\".\"+s+\"collapsible\").toggleClass(s+\"open\"),t.stopPropagation())}),t.after(o).hide()})}var a=/^\\s*(background|color|font)/i,s=\"moegirl-flatten-navbox-\";i(),$(\"body\").append(\"<style>._wrapper{position:relative;margin-top:10px;line-height:1.7;border:1px solid #aaa;padding:3px;clear:both}._subgroup{border:0 solid #e6e6ff;border-left-width:3px}._title{font-weight:700;background:#e6e6ff;margin-bottom:2px;padding-left:1em}._nav{font-size:80%;word-spacing:.8em;border-top:1px solid #aaa}._content{padding-left:1em;margin-bottom:2px}._content:last-child{margin-bottom:0}._wrapper>._subgroup{border-color:#ccf;border-width:0 3px 3px}._wrapper>._subgroup>._title{background:#ccf}._wrapper>._subgroup>._content>._subgroup{border-color:#ddf}._wrapper>._subgroup>._content>._subgroup>._title{background:#ddf}._collapsible>._title{position:relative}._collapsible>._content{display:none}._open>._content{display:block}._collapsible>._title{padding-left:3em;margin-bottom:0;min-height:20px}._open>._title{margin-bottom:2px}._toggle{position:absolute;left:0;top:0;bottom:0;font-family:monospace;color:#ba0000;font-size:90%;width:3.5em}._toggle>span{position:absolute;left:0;right:0;top:50%;text-align:center;transform:translateY(-50%);-webkit-transform:translateY(-50%)}._collapsible>._title>._toggle>._status-open{display:none}._collapsible>._title>._toggle>._status-close,._open>._title>._toggle>._status-open{display:inline}._open>._title>._toggle>._status-close{display:none}</style>\".replace(/_/g,s))})}();</script></body></html>";
    [tempFile writeToFile:[htmlDocumentPath stringByAppendingPathComponent:@"pagefooter"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    /*赋值UserDefaults*/
    [defaultdata setObject:@"2.0" forKey:@"version"];
    [defaultdata synchronize];
    
}

@end
