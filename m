From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: advansys driver vs 2.6 breakage
Date: Wed, 13 Aug 2003 16:30:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030813163001.5c56451e.rddunlap@osdl.org>
References: <20030810224402.5c7fa063.rddunlap@osdl.org>
	<200308120328.38835.gene.heskett@verizon.net>
	<20030813132526.465b646e.rddunlap@osdl.org>
	<200308131922.20098.gene.heskett@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:44973 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S272002AbTHMXdL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Aug 2003 19:33:11 -0400
In-Reply-To: <200308131922.20098.gene.heskett@verizon.net>
List-Id: linux-scsi@vger.kernel.org
To: gene.heskett@verizon.net
Cc: linux-scsi@vger.kernel.org, willy@debian.org

On Wed, 13 Aug 2003 19:22:19 -0400 Gene Heskett <gene.heskett@verizon.net> wrote:

| On Wednesday 13 August 2003 16:25, Randy.Dunlap wrote:
| >
| >Gene,
| >
| >Both the 2.4 and 2.6 logs show lots of successful IOs and a few
| >IO errors.  The IO errors look like this in both of them:
| >
| >Aug 11 13:48:28 coyote kernel: asc_isr_callback: QD_WITH_ERROR
| >Aug 11 13:48:28 coyote kernel: asc_isr_callback: host_stat 0x11
| >
| >This is a timeout as I read the source file.
| >Maybe I'm misreading the logs, but I don't see any other errors
| >being reported.  What are the symptoms of the errors that you are
| >seeing on 2.6.0-test?
| >
| The last boot I just did is to 2.6.0-test3-mm2, with the bogug bug 
| patch, advansys builtin with debugging off. Using anticipatory 
| scheduler just yet, and kmail just did a mail fetch which tore the 
| machines responsiveness a new one.
| 
| The original problem was that it wouldn't even boot with test2, and I 
| hadn't tried test1.  That was without the debugging and builtin like 
| it is now, but before the patch that made the debugging stuff build.
| 
| I'd test it but I need to do 2 things, 1, take the missus out for 
| dinner, and 2, swap all the tapes in the magazine, so it will be a 
| couple of hours before thats all done.  I'll post again with the 
| results.
| 
| The difference is that I, a couple of days ago, enabled the ESCD reset 
| in the bios, and it moved all the USB stuff, which was on IRQ-11, to 
| IRQ-9, leaving 11 free for the advansys and nvidia drivers.  Suddenly 
| everything seeemed to fall into place.  That log I sent was after the 
| ESCD reset, but I have about 4 megabytes in messages put there by a 
| hung process over about 1h:15m before that ESCD reset.  I think I 
| sent one seconds worth of that at the top of the last file.

I see.

| What version  of the scheduler is in the test3-mm2 kit?

At config time you can select Anticipatory, Deadline, or "No-op" (basic,
simple, minimal).

--
~Randy
