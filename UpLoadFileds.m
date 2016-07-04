//
//  UpLoadFileds.m
//  上传多个文件
//
//  Created by Mac on 16/6/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "UpLoadFileds.h"
#define kBoundary @"--abc"
@implementation UpLoadFileds

//上传单个文件
+(void)uploadFiled:(NSString *)urlString filedName:(NSString *)filedName filePath:(NSString *)filePath{
    
    [self uploadFiled:urlString filedName:filedName filePath:filePath params:nil];
    
}

+(void)uploadFiled:(NSString *)urlString filedName:(NSString *)filedName filePath:(NSString *)filePath params:(NSDictionary *)params{
    
    [self uploadFileds:urlString filedName:filedName filePaths:@[filePath] params:params];
    
}

//上传多个文件
+(void)uploadFileds:(NSString *)urlString filedName:(NSString *)filedName filePaths:(NSArray *)filePaths params:(NSDictionary *)params{
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置post
    request.HTTPMethod = @"POST";
    //设置请求头 Content-Type:multipart/form-data; boundary=----WebKitFormBoundaryQA5pv9R6XT4df70B
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",kBoundary] forHTTPHeaderField:@"Content-Type"];
    
    //设置请求体
    request.HTTPBody = [self makeBody:filedName filedPath:filePaths params:params];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (connectionError) {
            NSLog(@"连接错误");
            return;
        }
        
        NSHTTPURLResponse *URLResponse = (NSHTTPURLResponse *)response;
        
        if (URLResponse.statusCode == 200 || URLResponse.statusCode == 304) {
            
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSLog(@"%@",json);
            
        }else{
            
            NSLog(@"服务器内部错误");
            
        }
        
    }];

    
}

//返回一个请求体
+(NSData *)makeBody:(NSString *)filedName filedPath:(NSArray *)filedPath params:(NSDictionary *)params{
    
    //返回请求体
    NSMutableData *mData = [NSMutableData data];
    //1.拼文件
    //        ------WebKitFormBoundaryQA5pv9R6XT4df70B
    //        Content-Disposition: form-data; name="userfile[]"; filename="01.jpg"
    //        Content-Type: image/jpeg
    
    //        二进制数据
    [filedPath enumerateObjectsUsingBlock:^(NSString *filePath, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSMutableString *mString = [NSMutableString string];
        
        if (idx == 0) {
            [mString appendFormat:@"--%@\r\n",kBoundary];
        }else{
            [mString appendFormat:@"\r\n%@\r\n",kBoundary];
        }
        [mString appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",filedName,[filePath lastPathComponent]];
        [mString appendString:@"Content-Type: application/octet-stream\r\n\r\n"];
        //把字符串转化为二进制数据
        [mData appendData:[mString dataUsingEncoding:NSUTF8StringEncoding]];
        
        //加载文件
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        
        [mData appendData:data];
        
    }];
    
    //拼字符串
    //    ------WebKitFormBoundaryLA7IgIB32Lz1nWqU
    //    Content-Disposition: form-data; name="username"
    //
    //    aaa
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        
        NSMutableString *mstr = [NSMutableString string];
        
        [mstr appendFormat:@"\r\n--%@\r\n",kBoundary];
        [mstr appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        [mstr appendFormat:@"%@",obj];
        [mData appendData:[mstr dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    //结束
    NSString *end = [NSString stringWithFormat:@"\r\n--%@--",kBoundary];
    [mData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    return mData.copy;
    
}


@end
