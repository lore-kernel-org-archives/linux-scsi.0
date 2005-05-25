From: Mogens Valentin <monz@danbbs.dk>
Subject: Re: [ANNOUNCE] sdparm 0.92
Date: Wed, 25 May 2005 04:42:50 +0200
Message-ID: <4293E62A.5080408@danbbs.dk>
References: <428DC633.5050403@torque.net> <4293BD80.1050503@danbbs.dk> <4293D798.4020606@torque.net>
Reply-To: monz@danbbs.dk
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pfepb.post.tele.dk ([195.41.46.236]:37735 "EHLO
	pfepb.post.tele.dk") by vger.kernel.org with ESMTP id S262247AbVEYCmK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 22:42:10 -0400
In-Reply-To: <4293D798.4020606@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com

Douglas Gilbert wrote:
> Mogens Valentin wrote:
> 
>> Douglas Gilbert wrote:
>>
>>> sdparm is a command line utility designed to get and set
>>> SCSI disk parameters (cf hdparm for ATA disks). ..snip..
>>
>> Nice! Just got it and tried on an external usb disk.
>> One feature I could use, probably others as well:
>> Could you add the ability to spin down/up a scsi disk?
>> I'd really like this for exteral (usb) disks.
> 
> Mogens,
> With sg_start (in the sg3_utils package) I have tried
> to spin up and down an ATA disk inside a USB enclosure
> without success. The same command on a USB connected
> CD/DVD combo drive did work.
> 
> Could you try sg_start on your USB external enclosure
> which I assume contains an ATA disk rather than a
> SCSI (SPI) disk and report if it works?

Sure. Got it, compiled, but got the error:
   .../usr/include/scsi/sg.h /usr/include/scsi/scsi.h
   /usr/include/stdint.h   sg_lib.h sg_cmds.h llseek.h
   gcc: cannot specify -o with -c or -S and multiple compilations
   make: *** [sgp_dd.o] Error 1

I could only find  -o  and  -c  in the makefiles around line 95.

Slack 9.1 / 2.6.10 from sources.

It's 4am, I'm off to bed, sorry :p

-- 
Kind regards,
Mogens Valentin

