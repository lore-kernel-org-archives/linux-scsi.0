From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: ioctls, etc. (was Re: [PATCH 1/4] sas: add flag for locally attached PHYs)
Date: Sat, 22 Oct 2005 10:23:39 -0700 (PDT)
Message-ID: <20051022172339.3775.qmail@web31803.mail.mud.yahoo.com>
References: <435A05DD.7040003@s5r6.in-berlin.de>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31803.mail.mud.yahoo.com ([68.142.207.66]:14977 "HELO
	web31803.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1750796AbVJVRXj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Oct 2005 13:23:39 -0400
In-Reply-To: <435A05DD.7040003@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Luben Tuikov <luben_tuikov@adaptec.com>, andrew.patterson@hp.com, Christoph Hellwig <hch@lst.de>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, jejb@steeleye.com, Linus Torvalds <torvalds@osdl.org>

--- Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> 
> Will cmd_per_lun, sg_tablesize, max_sectors, dma_boundary, 
> use_clustering ever have to be adjusted specifically for a SAS hardware?

No hardware SAS chip I know of needs any of those legacy limitations.
Neither BCM8603 nor Fusion MPT.

Those limitations are purely Parallel SCSI.

I just included it, to show proof of concept -- when the architecure and
layering is correct, how easy it is to do it.  But you're right, it is
not needed.

> Obviuosly none of this is required _at the moment_. IOW neither the 
> introduction of a sas_ha_hw_profile nor a pass-through of 
> scsi_host_template down to SAS interconnect drivers is required right 
> now. So why do one or the other now? Isn't it a sensible rule to not 
> solve problems now which do not exist yet?

This is exactly the rule I followed when developing the SAS Transport
Layer for Linux.  Furthermore, _that_ rule, to never overengineer, I learned
from Linux.  Sadly the politics are too deep and that rule applies only
to what is convenient, at least in Linux SCSI.

   Luben


-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
