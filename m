From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: initio.c driver question?  Can read but not write; Initio
 Corporation INI-950 SCSI Adapter (rev 02)
Date: Mon, 25 Jul 2011 21:25:49 -0700
Message-ID: <20110725212549.4381566b.rdunlap@xenotime.net>
References: <87hb69ua0r.fsf@cadence.glidepath.invalid>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:55823 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750816Ab1GZEZw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2011 00:25:52 -0400
In-Reply-To: <87hb69ua0r.fsf@cadence.glidepath.invalid>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Marc D Ronell <mronell@alumni.upenn.edu>
Cc: linux-kernel@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>

[adding linux-scsi mailing list]

On Mon, 25 Jul 2011 21:05:08 -0400 Marc D Ronell wrote:

> 
> 
> I am having trouble writing to a scsi tape drive which is connected to
> a  startech PCISCSIUW card  that uses  the Initio  Corporation INI-950
> chipset.  Using  the 2.6.39.3  kernel, I can  read from the  scsi tape
> drive successfully, but  when I attempt to write,  the write fails.  I
> am attempting  to write  as root to  avoid permission  problems.  This
> failure seems to be potentially  a driver problem.  The tape drive and
> tapes have been  tested earlier with a different box  and were used to
> generate the tapes which were successfully read.
> 
> The failures are as follows:
> 
> root@myhost:~#  tar cvf /dev/st0 ~myaccount/
> tar: Removing leading `/' from member names
> /home/myaccount/
> /home/myaccount/.netpanzer/
> /home/myaccount/.netpanzer/log.txt
> /home/myaccount/.netpanzer/config/
> /home/myaccount/.netpanzer/config/netpanzer.xml
> /home/myaccount/.newsrc.eld
> /home/myaccount/2.4.24.config
> /home/myaccount/.Xauthority
> /home/myaccount/.xsession-errors
> tar: /dev/st0: Cannot write: Input/output error
> tar: Error is not recoverable: exiting now
> 
> The errors written to the /var/log/syslog are:
> 
> Jul 24 14:10:50 myhost kernel: [18806.011317] st0: Block limits 1 - 16777215 bytes.
> Jul 24 14:11:32 myhost kernel: [18848.303903] st0: Sense Key : Illegal Request [current] 
> Jul 24 14:11:32 myhost kernel: [18848.303909] st0: Add. Sense: Invalid command operation code
> Jul 24 14:11:32 myhost kernel: [18848.303914] st0: Error on write filemark.
> Jul 24 14:12:29 myhost kernel: [18905.561873] st0: Sense Key : Illegal Request [current] 
> Jul 24 14:12:29 myhost kernel: [18905.561878] st0: Add. Sense: Invalid command operation code
> Jul 24 14:12:51 myhost kernel: [18926.897446] st0: Sense Key : 0xf [deferred] [descriptor]
> Jul 24 14:12:51 myhost kernel: [18926.897452] Descriptor sense data with sense descriptors (in hex):
> Jul 24 14:12:51 myhost kernel: [18926.897455]         ff ff fe ef c9 24 a5 2d d3 29 6e 09 d0 56 00 00 
> Jul 24 14:12:51 myhost kernel: [18926.897463]         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> Jul 24 14:12:51 myhost kernel: [18926.897471]         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> Jul 24 14:12:51 myhost kernel: [18926.897479]         00 00 00 00 00 
> Jul 24 14:12:51 myhost kernel: [18926.897482] st0: <<vendor>> ASC=0xfe ASCQ=0xefASC=0xfe <<vendor>> ASCQ=0xef
> 
> Not sure if anyone is supporting the driver.  Thanks in advance for
> any help or suggestions.
> 
> Marc

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
