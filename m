From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: advansys regions [Re: 2.4 vs 2.6 versions of include/linux/ioport.h]
Date: Thu, 7 Aug 2003 05:33:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200308070533.10408.gene.heskett@verizon.net>
References: <200308051041.08078.gene.heskett@verizon.net> <20030806104041.4a09f4f0.rddunlap@osdl.org> <20030807083626.B766@infradead.org>
Reply-To: gene.heskett@verizon.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out002pub.verizon.net ([206.46.170.141]:52931 "EHLO
	out002.verizon.net") by vger.kernel.org with ESMTP id S275240AbTHGJdM
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Aug 2003 05:33:12 -0400
In-Reply-To: <20030807083626.B766@infradead.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Randy.Dunlap" <rddunlap@osdl.org>
Cc: linux-scsi@vger.kernel.org

On Thursday 07 August 2003 03:36, Christoph Hellwig wrote:
>On Wed, Aug 06, 2003 at 10:40:41AM -0700, Randy.Dunlap wrote:
>> I'm not terribly interested in spending much time on this driver,
>> so the simplest thing to do IMO is to emulate check_region() with
>> pairs of request_region() and release_region() calls.  Yes, this
>> is still racy, just like check_region() was.  Is that a problem
>> in your machine environment?
>>
>> Below is a patch that uses request_region/release_region pairs
>> instead of check_region().  Does it work for you?
>
>What the heck?  Just continue using check_region if you don't want
>to spend the time fixing it.  At least we get a warning in that
>case.

But I'm getting tired of repeating myself here Christoph, the driver 
as built in the 2.6.0-test2-mm2, whether built as a module, or in the 
kernel, IS BROKEN!  It gets into a bus reset loop during the init, 
doing 2 of them, AND LOCKS THE MACHINE UP TIGHT REQUIRING A HARDWARE 
RESET TO RECOVER, which of course is by rebooting back to a 2.4 
kernel.

The diff between this driver in kernel-2.4.22-pre10 and the one in 
test2-mm2 is several kilobytes, so *somebody* has been working on it, 
but they not leaving much of a trail, or even apparently adding their 
names to the roll call.

Frankly, from the lack of support by Advansys turned Connectcom turned 
now by way of a bankruptcy into Initio, and the well meaning but 
don't always work suggestions from this group, I'm about to import 
the 2.4.22-pre10 version, header and all, and see what pukes because 
the 2.2-2.4 version has worked flawlessly for quite some time, at 
least 5 or 6 years and I've worn out several tape drives with it.

I even posted a patch here that MADE IT WORK, based on Randy Dunlaps 
first suggestion, but its not been propagated to Linus that I know 
of.  I guess it wasn't a proper patch, but when I tried the next 
suggestions to "make it better", I was then 2 steps short of square 
one in that it was broken again, and this time it couldn't even find 
my tape drive and its robot in between bus resets.

You could say I'm frustrated.  Like everyone else on this list, I'm 
tired of the machine, when not doing anything else except munching on 
a seti packet, has a half a gig of ram xosview says isn't all used 
and it still takes 20 to 30 seconds to launch mozilla when running a 
2.4 kernel.  This is after all, an athlon running at 1400 mhz and 
seti is running at a nice of 20.  2.4 has turned this machine into a 
one legged sick dog, one that needs to be put out of its misery.

IE on a 1.2 ghz winderz box is up and running in 1 second flat.  I saw 
it yesterday at the neighbors.

Does anyone know what became of Bob Frey?  He was at turbolinux.com.?? 
at one time, but google finds no references < 2 years old.

-- 
Cheers, Gene
AMD K6-III@500mhz 320M
Athlon1600XP@1400mhz  512M
99.27% setiathome rank, not too shabby for a WV hillbilly
Yahoo.com attornies please note, additions to this message
by Gene Heskett are:
Copyright 2003 by Maurice Eugene Heskett, all rights reserved.

