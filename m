From: Harald Dunkel <harri@synopsys.COM>
Subject: Re: [linux-usb-devel] 2.6.0-test1: random errors for USB disk
Date: Thu, 17 Jul 2003 22:47:59 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F170B7F.9010000@Synopsys.COM>
References: <Pine.LNX.4.44L0.0307171520390.1251-100000@ida.rowland.org> <3F16FFD0.9070905@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from us01smtp2.synopsys.com ([198.182.44.80]:16530 "EHLO
	kiruna.synopsys.com") by vger.kernel.org with ESMTP id S270872AbTGQUdQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 16:33:16 -0400
In-Reply-To: <3F16FFD0.9070905@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, USB Storage List <usb-storage@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

David Brownell wrote:
> Alan Stern wrote:
> 
>> The information in your system logs is very clear.  Your USB drive 
>> worked just great until it received a big data transfer.
>>
>> Under 2.4, the largest WRITE transfer was 130048 bytes and it worked 
>> fine.  Under 2.6, the largest attempted WRITE transfer was 524288 
>> bytes and it
>> crashed the drive.  The two commands were otherwise identical.
> 
> 
> Just to clarify:  there's another difference, and that's that 2.4 does
> doing that smaller write one page at a time (write, wait, write, wait,...)
> while 2.6 does it all at once (write, write, write, write, ... wait).
> 
> That difference is how I've seen usb-storage top 30 MByte/sec on USB
> with 2.6 kernels, when 2.4 may not reach 10 MB/sec on the same hardware.
> 
I am using the disk in question to do backups of my $HOME. On 2.4.21
it was written with an amazing speed of about 20 MByte/sec, which I had
never expected. I could live with 10, if it is reliable.


Regards

Harri

