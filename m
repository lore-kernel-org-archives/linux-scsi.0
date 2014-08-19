From: Meelis Roos <mroos@linux.ee>
Subject: Re: Sym2 scsi hang on boot on sparc64
Date: Tue, 19 Aug 2014 17:37:00 +0300 (EEST)
Message-ID: <alpine.SOC.1.00.1408191736190.7767@math.ut.ee>
References: <alpine.SOC.1.00.1408191420150.4929@math.ut.ee> <1408451668.2645.2.camel@jarvis>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:33530 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273AbaHSOiJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2014 10:38:09 -0400
In-Reply-To: <1408451668.2645.2.camel@jarvis>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

> On Tue, 2014-08-19 at 14:25 +0300, Meelis Roos wrote:
> > 3.16 scsi worked fine, 3.17-rc1 misbehaves on 3 of my sparc64 test 
> > machines. E220R and E420R are with onboard 5c3875, V210 is with onboarc 
> > 53c1010 and all behave the same. Any ideas whre to dig deeper? bisection 
> > might be nontrivial, because of sparc64 changes that are OK on 3.17-rc1 
> > again - but is possible if nothing else helps.
> 
> We've got a parisc with an 875 as a root SCSI bus ... I haven't got
> around to building for it yet, but I might find time to try today.

Same on parisc:

sym0: <1010-66> rev 0x1 at pci 0000:20:01.0 irq 22
sym0: PA-RISC Firmware, ID 7, Fast-80, LVD, parity checking
sym0: SCSI BUS has been reset.
scsi host0: sym-2.2.3
random: nonblocking pool is initialized

and hangs here. So hopefully it is reproducible for you.

-- 
Meelis Roos (mroos@linux.ee)
