From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] until blockdev --setrw /dev/scd$n works
Date: 08 Dec 2003 10:10:31 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1070903431.2263.16.camel@patibmrh9>
References: <1070673881.2939.20.camel@patibmrh9>
	 <1070674338.2939.31.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <1070674338.2939.31.camel@patibmrh9>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, axboe@suse.de, patmans@us.ibm.com
List-Id: linux-scsi@vger.kernel.org

> > +		printk("lk 2.5 ide-cd.c would refuse write\n"); ...
> > +			printk("lk 2.5 sr.c would refuse write\n"); ...
> > +			printk("lk 2.5 cdrom.c would refuse write\n"); ...
> ...
> 2) I have two pre-production samples of the same device: one ATAPI, one
> USB.  Without my patch my ATAPI device never writes, and for my USB
> device I have to volunteer `blockdev --setrw` or `blockdev --setro`
> again after each disc insertion.

Ouch this English doesn't say what I mean.  Instead I should have said:

a) cdrom.ko refuses to pass thru writes unless patched.

b) sr_mod.ko refuses to pass thru writes unless patched.

c) ide-cd.ko refuses to pass thru writes unless patched or asked via
ioctl e.g. via blockdev --setrw.

I'm guessing the maintainers of cdrom.ko sr_mod.ko would accept a patch
to make blockdev --setrw work for those as well as it already does for
ide-cd.ko.

Pat LaVarre
