//
//  AppDelegate.m
//  irctest
//
//  Created by clizby on 3/4/14.
//  Copyright (c) 2014 clizby. All rights reserved.
//

#define TAG_WELCOME 10
#define TAG_NICK 11
#define TAG_USER 12

#import "AppDelegate.h"
#import "GCDAsyncSocket.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    
    NSString *host = @"irc.freenode.net";
    uint16_t port = 6667;
    
   
    
    NSError *error = nil;
    if (![asyncSocket connectToHost:host onPort:port error:&error])
    {
       NSLog(@"Error connecting: %@", error);
    }

    [asyncSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:TAG_WELCOME];

    
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
     NSLog(@"Cool, I'm connected! That was easy.");
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
	NSLog(@"socketDidSecure:%p", sock);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{

    if (tag == TAG_WELCOME){
        NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"socket:%p TAG_WELCOME:%ld %@", sock, tag, myString);
        [asyncSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:TAG_NICK];
        
    }
    else if( tag == TAG_NICK){
        NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"socket:%p TAG_NICK:%ld %@", sock, tag, myString);
        [asyncSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:TAG_NICK];
        if ([myString rangeOfString:@"No Ident response"].location != NSNotFound) {
            NSString * nick = @"NICK clizby\r\n";
            NSData* data = [nick dataUsingEncoding:NSUTF8StringEncoding];
            data = [data subdataWithRange:NSMakeRange(0, [data length] - 1)];
            [asyncSocket writeData:data withTimeout:-1 tag:TAG_NICK];
            
            NSString *user = @"USER  paulyt 8 *  : Paul Muttsson\r\n";
            data = [user dataUsingEncoding:NSUTF8StringEncoding];
            data = [data subdataWithRange:NSMakeRange(0, [data length] - 1)];
            [asyncSocket writeData:data withTimeout:-1 tag:TAG_USER];
            
            NSString *room = @"join #37tech\r\n";
            data = [room dataUsingEncoding:NSUTF8StringEncoding];
            data = [data subdataWithRange:NSMakeRange(0, [data length] - 1)];
            [asyncSocket writeData:data withTimeout:-1 tag:TAG_USER];

            NSLog(@"Writing stuff ");
            [asyncSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:TAG_USER];
        }
    }
    else if (tag == TAG_USER) {
        NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"socket:%p TAG_USER:%ld %@", sock, tag, myString);
        [asyncSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:TAG_USER];

    }
    else {
        NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"socket:%p OTHER:%ld %@", sock, tag, myString);
        [asyncSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
       
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	NSLog(@"socket:didWriteDataWithTag:");
}
@end
