From: Mark Lord <lsml@rtr.ca>
Subject: Re: [PATCH] QStor SATA/RAID driver for 2.6.9-rc3
Date: Thu, 07 Oct 2004 16:17:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4165A45D.2090200@rtr.ca>
References: <4161A06D.8010601@rtr.ca> <416547B6.5080505@rtr.ca> <20041007150709.B12688@infradead.org> <4165624C.5060405@rtr.ca> <416565DB.4050006@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpu1185.adsl.bellglobal.com ([207.236.110.166]:53437 "EHLO
	mail.rtr.ca") by vger.kernel.org with ESMTP id S268051AbUJGUTW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Oct 2004 16:19:22 -0400
In-Reply-To: <416565DB.4050006@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Mark Lord <lkml@rtr.ca>, Christoph Hellwig <hch@infradead.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Jeff Garzik wrote:
>
> We don't add hooks on the _hope_ that _future_ code will (a) use the 
> hooks and (b) be GPL'd.

Sure we do.  All of the time.

All of the other RAID drivers in the kernel have ioctl() hooks
for external code to control driver interfaces and settings.
Except with that kind of interface, we never get an open-source
version of that external code.

With exported symbols to support a GPL source-code supplement,
we get to see the code for all of it.  In this case, that code
is still being written, but it will be GPL in the end, simply
because it will be a kernel module, which by definition is subject
to the GPL.

This module will NOT be submitted to the stock kernel initially,
though, so you won't see it on lkml for some time.  That's because
of the hoops that vendors must jump through (repeatedly) just to
provide good open-source kernel support.

Given all of the fuss over this core driver (qstor.{ch}),
there is simply no way the vendor wants to go through it all again
for their RAID management module.  So sure, it will be GPL and
given away in source form (website, installation CD, etc..),
but it won't appear here simply because we're making too hard
for them to do so.

The exports are needed if we want that component to be open source.
Otherwise, they'll be replaced by ioctl()s like all of the other
drivers, and that part of the source code may then never be released.

Cheers
-- 
Mark Lord
(hdparm keeper & the original "Linux IDE Guy")
