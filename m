From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: advansys driver vs 2.6 breakage
Date: Wed, 13 Aug 2003 19:22:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200308131922.20098.gene.heskett@verizon.net>
References: <20030810224402.5c7fa063.rddunlap@osdl.org> <200308120328.38835.gene.heskett@verizon.net> <20030813132526.465b646e.rddunlap@osdl.org>
Reply-To: gene.heskett@verizon.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out005pub.verizon.net ([206.46.170.143]:40357 "EHLO
	out005.verizon.net") by vger.kernel.org with ESMTP id S272008AbTHMXWV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Aug 2003 19:22:21 -0400
In-Reply-To: <20030813132526.465b646e.rddunlap@osdl.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: linux-scsi@vger.kernel.org, willy@debian.org

On Wednesday 13 August 2003 16:25, Randy.Dunlap wrote:
>On Tue, 12 Aug 2003 03:28:38 -0400 Gene Heskett 
<gene.heskett@verizon.net> wrote:
>| On Monday 11 August 2003 17:34, Randy.Dunlap wrote:
>| >On Mon, 11 Aug 2003 17:29:04 -0400 Gene Heskett
>|
>| <gene.heskett@verizon.net> wrote:
>| >| On Monday 11 August 2003 01:44, Randy.Dunlap wrote:
>| >| >Gene,
>| >| >
>| >| >This patch should make the advansys driver build on
>| >| > 2.6.0-test3 after you #define ADVANSYS_DEBUG so that run-time
>| >| > debug output can be generated.
>| >| >
>| >| >--
>| >|
>| >| Ok Randy, I have some logs, stripped down to about 1650 lines
>| >| from just under half a million.
>| >|
>| >| Should I send them privately?
>| >
>| >How many bytes?  If <= roughly 60 KB, I'd say just post them
>| > here.
>|
>| I've done some more trimming, taking it down to a single bootup as
>| a module, and its now 58k, so its attached.
>
>Gene,
>
>Both the 2.4 and 2.6 logs show lots of successful IOs and a few
>IO errors.  The IO errors look like this in both of them:
>
>Aug 11 13:48:28 coyote kernel: asc_isr_callback: QD_WITH_ERROR
>Aug 11 13:48:28 coyote kernel: asc_isr_callback: host_stat 0x11
>
>This is a timeout as I read the source file.
>Maybe I'm misreading the logs, but I don't see any other errors
>being reported.  What are the symptoms of the errors that you are
>seeing on 2.6.0-test?
>
The last boot I just did is to 2.6.0-test3-mm2, with the bogug bug 
patch, advansys builtin with debugging off. Using anticipatory 
scheduler just yet, and kmail just did a mail fetch which tore the 
machines responsiveness a new one.

The original problem was that it wouldn't even boot with test2, and I 
hadn't tried test1.  That was without the debugging and builtin like 
it is now, but before the patch that made the debugging stuff build.

I'd test it but I need to do 2 things, 1, take the missus out for 
dinner, and 2, swap all the tapes in the magazine, so it will be a 
couple of hours before thats all done.  I'll post again with the 
results.

The difference is that I, a couple of days ago, enabled the ESCD reset 
in the bios, and it moved all the USB stuff, which was on IRQ-11, to 
IRQ-9, leaving 11 free for the advansys and nvidia drivers.  Suddenly 
everything seeemed to fall into place.  That log I sent was after the 
ESCD reset, but I have about 4 megabytes in messages put there by a 
hung process over about 1h:15m before that ESCD reset.  I think I 
sent one seconds worth of that at the top of the last file.

What version  of the scheduler is in the test3-mm2 kit?

>--
>~Randy				For Linux-2.6, see:
>http://www.kernel.org/pub/linux/kernel/people/davej/misc/post-hallow
>een-2.5.txt

-- 
Cheers, Gene
AMD K6-III@500mhz 320M
Athlon1600XP@1400mhz  512M
99.27% setiathome rank, not too shabby for a WV hillbilly
Yahoo.com attornies please note, additions to this message
by Gene Heskett are:
Copyright 2003 by Maurice Eugene Heskett, all rights reserved.

