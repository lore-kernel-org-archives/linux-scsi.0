From: Chiaki <ishikawa@yk.rim.or.jp>
Subject: Re: IO Data USB HD - read/write with SGIO ioctl does not acces the
 drive, kernel 2.6.15.6
Date: Wed, 17 May 2006 01:26:42 +0900
Message-ID: <4469FD42.7060906@yk.rim.or.jp>
References: <4468E16F.4060709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 251.77.150.220.ap.yournet.ne.jp ([220.150.77.251]:60802 "EHLO
	standard.erephon") by vger.kernel.org with ESMTP id S1751666AbWEPQ1H
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 12:27:07 -0400
Received: from [127.0.0.1] (really [127.0.0.1]) by yk.rim.or.jp
	via smail with esmtp
	id <m1Fg2No-002GLmC@standard.erephon> (Debian Smail3.2.0.115)
	for <linux-scsi@vger.kernel.org>; Wed, 17 May 2006 01:26:52 +0900 (JST)
In-Reply-To: <4468E16F.4060709@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dario Oliva <anikami1@gmail.com>
Cc: linux-scsi@vger.kernel.org, doliva@arcoide.com


It is very possible that the USB<-> ATA(SCSI?) bridge
may not be clever/powerful enough to
understand the emulated SCSI protocol correctly.

I have a I-O HDH-U USB external disk drive
with USB<->ATA bridge inside. (Don't know whether
the manufacrer is the same as yours, but it looks to
be the same manufacturer.)

Obviously S.M.A.R.T. information could not be
passed across this bridge until last April this year.
I-O Device, the manufacturer, issued an upgrade
of the bridge firmware last month, and now at least a particular
S.M.A.R.T.-aware program under Windows XP
can read the S.M.A.R.T. information
from the ATA disk in the external enclosure. Go figure.


Dario Oliva wrote:
> I am trying to use the SG_IO ioctl from the scsi driver to read and 
> write raw
> data to this USB hard drive (IO Data USB HD). I have googled the device 
> name and
> only came up with 13 sites, none of which had any information for this 
> problem.
> This is a link to a reseller in California who sells the device I am using
> http://www.devicenet-usa.com/product_en.html#hdp
> 
> To verify that the data was not being written from the device or read 
> from the device,
> I used a protocol analyzer connected to the hard disk While sending the 
> read or write
> commands using SG_IO, there was no activity on the disk. I have also 
> used a program I wrote
> that reads individual sectors from a disk and displays the data in a 
> format similar to hexdump.
> The output from that program is also attached, in the file named data. 
> As you will see, I did a read
> several times from sector 0, receiving different slightly different 
> values every time.
> 
> I am attaching output from dmesg gathered while connecting and reading 
> from the device.
> 
> 
> Where should I go from here? Are there other debug messages I can enable 
> within the scsi generic drivers.
> 
> 
> Dario Oliva


-- 
int main(void){int j=2006;/*(c)2006 cishikawa. */
char t[] ="<CI> @abcdefghijklmnopqrstuvwxyz.,\n\"";
char *i ="d>qtCIuqivb,gCwe\np@.ietCIuqi\"tqkvv is>dnamz";
while(*i)((j+=(int)strchr(t,*i++)-(int)t),(j%=sizeof t-1),
(putchar(t[j])));return 0;}/* under GPL */
