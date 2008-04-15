From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Tue, 15 Apr 2008 00:18:28 -0700
Message-ID: <20080415001828.b0c9ed64.akpm@linux-foundation.org>
References: <47E875AD.1000901@rtr.ca>
	<47E88A13.70808@zytor.com>
	<47E90019.3050006@rtr.ca>
	<47E90458.7030801@zytor.com>
	<47E9383F.3050908@rtr.ca>
	<20080325192515.GA24234@suse.de>
	<47E99A02.7040903@rtr.ca>
	<47E99EBE.7010708@gmail.com>
	<3ae72650803271229h6e188de1t81ccfb64e5d3a214@mail.gmail.com>
	<47EBF7D0.6000901@zytor.com>
	<e9c3a7c20804111625w68b21b24p6fbd85864713d62f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753414AbYDOHT2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Apr 2008 03:19:28 -0400
In-Reply-To: <e9c3a7c20804111625w68b21b24p6fbd85864713d62f@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <htejun@gmail.com>, Mark Lord <lkml@rtr.ca>, Greg KH <gregkh@suse.de>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 11 Apr 2008 16:25:32 -0700 "Dan Williams" <dan.j.williams@intel.com> wrote:

> >  It doesn't really seem to be to belong under class at all.  I would suggest
> > /sys/dev/char/ and /sys/dev/block/, for char and block respectively.
> >
> 
> This thread fizzled out without a patch... here goes:
> 
> ...
>
> sysfs: add /sys/dev/{char,block} to lookup sysfs path by major:minor

Crickets are chirping and I can't remember what the conclusion to all this
was.  In fact the thread was more than ten-deep so I probably fell asleep.

I queued it up so that others cannot do the same ;)
