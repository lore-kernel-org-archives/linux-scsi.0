From: Gerold Jury <gml@inode.at>
Subject: Re: extra bytes written to SATA DVD drive on kernel 2.6.23 till 2.6.24.2
Date: Fri, 7 Mar 2008 20:09:22 +0100
Message-ID: <200803072009.22551.gml@inode.at>
References: <200802252005.22663.gml@inode.at> <200803011329.11315.gml@inode.at> <47D0FF67.8050503@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47D0FF67.8050503@gmail.com>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Sergey Vlasov <vsu@altlinux.ru>, Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Here it goes

And the sequence is broken at address 000e1010.


00000000  2a 00 00 00 00 00 00 00  40 00 00 00 00 00 00 00  |*.......@.......|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000020  00 00 01 00 02 00 03 00  04 00 05 00 06 00 07 00  |................|
00000030  08 00 09 00 0a 00 0b 00  0c 00 0d 00 0e 00 0f 00  |................|
00000040  10 00 11 00 12 00 13 00  14 00 15 00 16 00 17 00  |................|
00000050  18 00 19 00 1a 00 1b 00  1c 00 1d 00 1e 00 1f 00  |................|
--- skip
0001ffc0  d0 ff d1 ff d2 ff d3 ff  d4 ff d5 ff d6 ff d7 ff  |................|
0001ffd0  d8 ff d9 ff da ff db ff  dc ff dd ff de ff df ff  |................|
0001ffe0  e0 ff e1 ff e2 ff e3 ff  e4 ff e5 ff e6 ff e7 ff  |................|
0001fff0  e8 ff e9 ff ea ff eb ff  ec ff ed ff ee ff ef ff  |................|
00020000  2a 00 00 00 00 40 00 00  40 00 00 00 00 40 00 00  |*....@..@....@..|
00020010  08 ff 09 ff 0a ff 0b ff  08 ff 09 ff 0a ff 0b ff  |................|
00020020  00 00 01 00 02 00 03 00  04 00 05 00 06 00 07 00  |................|
00020030  08 00 09 00 0a 00 0b 00  0c 00 0d 00 0e 00 0f 00  |................|
00020040  10 00 11 00 12 00 13 00  14 00 15 00 16 00 17 00  |................|
00020050  18 00 19 00 1a 00 1b 00  1c 00 1d 00 1e 00 1f 00  |................|
00020060  20 00 21 00 22 00 23 00  24 00 25 00 26 00 27 00  | .!.".#.$.%.&.'.|
--- skip
0003ffc0  d0 ff d1 ff d2 ff d3 ff  d4 ff d5 ff d6 ff d7 ff  |................|
0003ffd0  d8 ff d9 ff da ff db ff  dc ff dd ff de ff df ff  |................|
0003ffe0  e0 ff e1 ff e2 ff e3 ff  e4 ff e5 ff e6 ff e7 ff  |................|
0003fff0  e8 ff e9 ff ea ff eb ff  ec ff ed ff ee ff ef ff  |................|
00040000  2a 00 00 00 00 80 00 00  40 00 00 00 00 80 00 00  |*.......@.......|
00040010  08 ff 09 ff 0a ff 0b ff  08 ff 09 ff 0a ff 0b ff  |................|
00040020  00 00 01 00 02 00 03 00  04 00 05 00 06 00 07 00  |................|
00040030  08 00 09 00 0a 00 0b 00  0c 00 0d 00 0e 00 0f 00  |................|
00040040  10 00 11 00 12 00 13 00  14 00 15 00 16 00 17 00  |................|
00040050  18 00 19 00 1a 00 1b 00  1c 00 1d 00 1e 00 1f 00  |................|
00040060  20 00 21 00 22 00 23 00  24 00 25 00 26 00 27 00  | .!.".#.$.%.&.'.|
--- skip
0005ffb0  c8 ff c9 ff ca ff cb ff  cc ff cd ff ce ff cf ff  |................|
0005ffc0  d0 ff d1 ff d2 ff d3 ff  d4 ff d5 ff d6 ff d7 ff  |................|
0005ffd0  d8 ff d9 ff da ff db ff  dc ff dd ff de ff df ff  |................|
0005ffe0  e0 ff e1 ff e2 ff e3 ff  e4 ff e5 ff e6 ff e7 ff  |................|
0005fff0  e8 ff e9 ff ea ff eb ff  ec ff ed ff ee ff ef ff  |................|
00060000  2a 00 00 00 00 c0 00 00  40 00 00 00 00 c0 00 00  |*.......@.......|
00060010  08 ff 09 ff 0a ff 0b ff  08 ff 09 ff 0a ff 0b ff  |................|
00060020  00 00 01 00 02 00 03 00  04 00 05 00 06 00 07 00  |................|
00060030  08 00 09 00 0a 00 0b 00  0c 00 0d 00 0e 00 0f 00  |................|
00060040  10 00 11 00 12 00 13 00  14 00 15 00 16 00 17 00  |................|
00060050  18 00 19 00 1a 00 1b 00  1c 00 1d 00 1e 00 1f 00  |................|
00060060  20 00 21 00 22 00 23 00  24 00 25 00 26 00 27 00  | .!.".#.$.%.&.'.|
--- skip
0007ffc0  d0 ff d1 ff d2 ff d3 ff  d4 ff d5 ff d6 ff d7 ff  |................|
0007ffd0  d8 ff d9 ff da ff db ff  dc ff dd ff de ff df ff  |................|
0007ffe0  e0 ff e1 ff e2 ff e3 ff  e4 ff e5 ff e6 ff e7 ff  |................|
0007fff0  e8 ff e9 ff ea ff eb ff  ec ff ed ff ee ff ef ff  |................|
00080000  2a 00 00 00 01 00 00 00  40 00 00 00 01 00 00 00  |*.......@.......|
00080010  08 ff 09 ff 0a ff 0b ff  08 ff 09 ff 0a ff 0b ff  |................|
00080020  00 00 01 00 02 00 03 00  04 00 05 00 06 00 07 00  |................|
00080030  08 00 09 00 0a 00 0b 00  0c 00 0d 00 0e 00 0f 00  |................|
00080040  10 00 11 00 12 00 13 00  14 00 15 00 16 00 17 00  |................|
00080050  18 00 19 00 1a 00 1b 00  1c 00 1d 00 1e 00 1f 00  |................|
00080060  20 00 21 00 22 00 23 00  24 00 25 00 26 00 27 00  | .!.".#.$.%.&.'.|
--- skip
0009ffd0  d8 ff d9 ff da ff db ff  dc ff dd ff de ff df ff  |................|
0009ffe0  e0 ff e1 ff e2 ff e3 ff  e4 ff e5 ff e6 ff e7 ff  |................|
0009fff0  e8 ff e9 ff ea ff eb ff  ec ff ed ff ee ff ef ff  |................|
000a0000  2a 00 00 00 01 40 00 00  40 00 00 00 01 40 00 00  |*....@..@....@..|
000a0010  08 ff 09 ff 0a ff 0b ff  08 ff 09 ff 0a ff 0b ff  |................|
000a0020  00 00 01 00 02 00 03 00  04 00 05 00 06 00 07 00  |................|
000a0030  08 00 09 00 0a 00 0b 00  0c 00 0d 00 0e 00 0f 00  |................|
000a0040  10 00 11 00 12 00 13 00  14 00 15 00 16 00 17 00  |................|
000a0050  18 00 19 00 1a 00 1b 00  1c 00 1d 00 1e 00 1f 00  |................|
000a0060  20 00 21 00 22 00 23 00  24 00 25 00 26 00 27 00  | .!.".#.$.%.&.'.|
--- skip
000bffc0  d0 ff d1 ff d2 ff d3 ff  d4 ff d5 ff d6 ff d7 ff  |................|
000bffd0  d8 ff d9 ff da ff db ff  dc ff dd ff de ff df ff  |................|
000bffe0  e0 ff e1 ff e2 ff e3 ff  e4 ff e5 ff e6 ff e7 ff  |................|
000bfff0  e8 ff e9 ff ea ff eb ff  ec ff ed ff ee ff ef ff  |................|
000c0000  2a 00 00 00 01 80 00 00  40 00 00 00 01 80 00 00  |*.......@.......|
000c0010  08 ff 09 ff 0a ff 0b ff  08 ff 09 ff 0a ff 0b ff  |................|
000c0020  00 00 01 00 02 00 03 00  04 00 05 00 06 00 07 00  |................|
000c0030  08 00 09 00 0a 00 0b 00  0c 00 0d 00 0e 00 0f 00  |................|
000c0040  10 00 11 00 12 00 13 00  14 00 15 00 16 00 17 00  |................|
000c0050  18 00 19 00 1a 00 1b 00  1c 00 1d 00 1e 00 1f 00  |................|
000c0060  20 00 21 00 22 00 23 00  24 00 25 00 26 00 27 00  | .!.".#.$.%.&.'.|
--- skip
000dffc0  d0 ff d1 ff d2 ff d3 ff  d4 ff d5 ff d6 ff d7 ff  |................|
000dffd0  d8 ff d9 ff da ff db ff  dc ff dd ff de ff df ff  |................|
000dffe0  e0 ff e1 ff e2 ff e3 ff  e4 ff e5 ff e6 ff e7 ff  |................|
000dfff0  e8 ff e9 ff ea ff eb ff  ec ff ed ff ee ff ef ff  |................|
000e0000  2a 00 00 00 01 c0 00 00  02 00 00 00 01 c0 00 00  |*...............|
000e0010  08 ff 09 ff 0a ff 0b ff  08 ff 09 ff 0a ff 0b ff  |................|
000e0020  00 00 01 00 02 00 03 00  04 00 05 00 06 00 07 00  |................|
000e0030  08 00 09 00 0a 00 0b 00  0c 00 0d 00 0e 00 0f 00  |................|
000e0040  10 00 11 00 12 00 13 00  14 00 15 00 16 00 17 00  |................|
000e0050  18 00 19 00 1a 00 1b 00  1c 00 1d 00 1e 00 1f 00  |................|
000e0060  20 00 21 00 22 00 23 00  24 00 25 00 26 00 27 00  | .!.".#.$.%.&.'.|
--- skip to the not so funny part
000e0fc0  d0 07 d1 07 d2 07 d3 07  d4 07 d5 07 d6 07 d7 07  |................|
000e0fd0  d8 07 d9 07 da 07 db 07  dc 07 dd 07 de 07 df 07  |................|
000e0fe0  e0 07 e1 07 e2 07 e3 07  e4 07 e5 07 e6 07 e7 07  |................|
000e0ff0  e8 07 e9 07 ea 07 eb 07  ec 07 ed 07 ee 07 ef 07  |................|
000e1000  f0 07 f1 07 f2 07 f3 07  f4 07 f5 07 f6 07 f7 07  |................|
000e1010  f8 07 f9 07 fa 07 fb 07  2a 00 00 00 01 c2 00 00  |........*.......|
000e1020  3e 00 00 00 01 c2 00 00  08 07 09 07 0a 07 0b 07  |>...............|
000e1030  08 07 09 07 0a 07 0b 07  00 08 01 08 02 08 03 08  |................|
000e1040  04 08 05 08 06 08 07 08  08 08 09 08 0a 08 0b 08  |................|
000e1050  0c 08 0d 08 0e 08 0f 08  10 08 11 08 12 08 13 08  |................|
000e1060  14 08 15 08 16 08 17 08  18 08 19 08 1a 08 1b 08  |................|
000e1070  1c 08 1d 08 1e 08 1f 08  20 08 21 08 22 08 23 08  |........ .!.".#.|
000e1080  24 08 25 08 26 08 27 08  28 08 29 08 2a 08 2b 08  |$.%.&.'.(.).*.+.|
--- skip
000fffa0  b4 ff b5 ff b6 ff b7 ff  b8 ff b9 ff ba ff bb ff  |................|
000fffb0  bc ff bd ff be ff bf ff  c0 ff c1 ff c2 ff c3 ff  |................|
000fffc0  c4 ff c5 ff c6 ff c7 ff  c8 ff c9 ff ca ff cb ff  |................|
000fffd0  cc ff cd ff ce ff cf ff  d0 ff d1 ff d2 ff d3 ff  |................|
000fffe0  d4 ff d5 ff d6 ff d7 ff  d8 ff d9 ff da ff db ff  |................|
000ffff0  dc ff dd ff de ff df ff  e0 ff e1 ff e2 ff e3 ff  |................|
00100000

Regards
Gerold

On Friday 07 March 2008 09:40:07 Tejun Heo wrote:
>Hello,
>
>Gerold Jury wrote:
>> Yes it happens with the DVD+RW (testet with dd now) and with DVD+R
>>
>> Thank you for the byte interpretation.
>> Now I have a hint where to start with the debugging.
>
>I've tried to reproduce the problem here but failed.  Can you please try
>the test with the file generated with the attached program?  "genseqfile
>524288 > testfile" will give you 1 meg testfile and it will give us
>better idea how the data is getting corrupted.
>
>Thanks.


