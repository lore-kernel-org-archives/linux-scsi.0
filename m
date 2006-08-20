From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: Bugs on Linux 2.6.18-rc2 sg code?
Date: Sun, 20 Aug 2006 10:01:10 +0100
Message-ID: <20060820090110.GA18927@flint.arm.linux.org.uk>
References: <8202f4270608101843r7df002d2l40e03eca3271b050@mail.gmail.com> <44E6388D.1000206@torque.net> <44E68F76.4010702@torque.net> <8202f4270608200051p688f4654ub6aecb604e0152f1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:58642 "EHLO
	caramon.arm.linux.org.uk") by vger.kernel.org with ESMTP
	id S1751702AbWHTJBV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Aug 2006 05:01:21 -0400
Content-Disposition: inline
In-Reply-To: <8202f4270608200051p688f4654ub6aecb604e0152f1@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fajun Chen <fajunchen@gmail.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org, akpm@osdl.org

On Sun, Aug 20, 2006 at 01:51:33AM -0600, Fajun Chen wrote:
> I've tested mmap code in both 2.6.15.4 and 2.6.18-rc2 with
> sg_vma_nopage() from 2.6.15.4, this particular sg mmap bug seems to be
> fixed?$B!%!!#S#i#n#c#e!!#y#o#u#r!!#p#a#t#c#h!!#f#o#r!!#2!%#6!%#1#8!]#r#c#4!!#i#s!!essentially not different

This is unreadable...

> from 2.6.15.4 (the only difference is sg->offset, which is always 0
> for sg mmap or indirect IO),  this should fix the problem.  I'll test
> your patch next week to confirm it anyway.
> 
> I would like to also report a potential cache coherency issue on sg
> when running on some processors other than i386.  I ran into cache
> coherency issue on ARM XScale Iop80321.

I no longer touch SCSI, partly because the only SCSI based systems I
have are extremely (10 years) old now.  All my SCSI knowledge is based
on ancient 2.4 code and is no longer relevant.

> Existing sg code for direct IO:

I don't think direct-IO has ever been tested and debugged on ARM either.
I wouldn't know where to start with direct-IO - never used and never
looked at it.

And more importantly (for me), I'd rather not get into another squabble
with James over cache coherency ideas, so I want to stay well away from
cache coherency and block devices, thanks.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:  2.6 Serial core
