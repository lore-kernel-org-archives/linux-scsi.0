From: Douglas Gilbert <dougg@torque.net>
Subject: Re: sg_scan -i /dev/sg[0123] /dev/hd[abcd] /dev/scd[0123]
Date: Mon, 08 Dec 2003 18:11:21 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FD43229.7070708@torque.net>
References: <1070670440.3056.7.camel@patibmrh9>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:28939 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S264584AbTLHILo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Dec 2003 03:11:44 -0500
In-Reply-To: <1070670440.3056.7.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

Pat LaVarre wrote:
> Doug G:
> 
> In lk 2.6 I wish sg_scan accepted a list of args e.g.
> 
> $ lsmod | grep sg
> $
> $ sudo sg_scan -i /dev/sg[0123] /dev/hd[abcd] /dev/scd[0123]
> /dev/hdd: scsi0 channel=0 id=0 lun=0 [em]  type=5
>     Iomega    RRD               05.A [wide=0 sync=0 cmdq=0 sftre=0 pq=0x0]
> /dev/scd0: scsi0 channel=0 id=0 lun=0 [em]  type=5
>     Iomega    RRD               05.U [wide=0 sync=0 cmdq=0 sftre=0 pq=0x0]
> $
> $ lsmod | grep sg
> $ 
> 
> Tell me you will accept such a patch, and I might not be too lazy to write it.

Pat,
Have a look at the sg3_utils-1.06.tgz beta on www.torque.net/sg

Maybe sg_scan should renamed sam_scan (sadly apart from INQUIRYs
on st and osst devices).

> P.S. I presume already you are aware of the gcc -Wall warning:
> 
> $ cd sg3_utils-1.06/
> $ make
> gcc -g -O2 -Wall -W -D_REENTRANT -D_LARGEFILE64_SOURCE
> -D_FILE_OFFSET_BITS=64
> -c -o sg_dd.o sg_dd.c
> sg_dd.c: In function `siginfo_handler':
> sg_dd.c:138: warning: unused parameter `sig'
> ...

Yes, but adding the '-W' flagging has several beneficial
effects (to counterbalance this annoying warning which
C++ but not C addresses).


BTW The sginfo in that beta decodes mode pages for disks,
tapes, cd/dvds and enclosures (plus SPI-4, FCP and SAS on
the transport side).

Doug Gilbert


