From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: advansys regions [Re: 2.4 vs 2.6 versions of include/linux/ioport.h]
Date: Thu, 7 Aug 2003 14:34:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200308071434.21571.gene.heskett@verizon.net>
References: <200308051041.08078.gene.heskett@verizon.net> <200308070533.10408.gene.heskett@verizon.net> <20030807104736.A4137@infradead.org>
Reply-To: gene.heskett@verizon.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop017pub.verizon.net ([206.46.170.210]:42959 "EHLO
	pop017.verizon.net") by vger.kernel.org with ESMTP id S270040AbTHGSeX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Aug 2003 14:34:23 -0400
In-Reply-To: <20030807104736.A4137@infradead.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Randy.Dunlap" <rddunlap@osdl.org>, linux-scsi@vger.kernel.org

On Thursday 07 August 2003 05:47, Christoph Hellwig wrote:
>On Thu, Aug 07, 2003 at 05:33:10AM -0400, Gene Heskett wrote:
>> But I'm getting tired of repeating myself here Christoph, the
>> driver as built in the 2.6.0-test2-mm2, whether built as a module,
>> or in the kernel, IS BROKEN!  It gets into a bus reset loop during
>> the init, doing 2 of them, AND LOCKS THE MACHINE UP TIGHT
>> REQUIRING A HARDWARE RESET TO RECOVER, which of course is by
>> rebooting back to a 2.4 kernel.
>
>So how do you think replacing check_region by it's opencoded version
>is going to help you?

I have no idea if request_region is the proper replacement call 
Christoph.  But in tests here, it did restore what appears to be 
normal operation.

Randy Dunlop says check_region is "racy".  And I'm no kernel coder 
unless I have complete hardware specs in front of me, which I do not.
Which is why I'm "pestering" this list for help and hopefully some 
nuggets of wisdom.
 
-- 
Cheers, Gene
AMD K6-III@500mhz 320M
Athlon1600XP@1400mhz  512M
99.27% setiathome rank, not too shabby for a WV hillbilly
Yahoo.com attornies please note, additions to this message
by Gene Heskett are:
Copyright 2003 by Maurice Eugene Heskett, all rights reserved.

