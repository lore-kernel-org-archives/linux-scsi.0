From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] gdth driver for 2.4.23-pre4
Date: Thu, 8 Jan 2004 14:19:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <C2CB6D8BA015124783C0EB9B33D24FFD048036@otcexc01.otc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([216.52.22.10]:40075 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S264411AbUAHTTZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2004 14:19:25 -0500
List-Id: linux-scsi@vger.kernel.org
To: 'Xose Vazquez Perez' <xose@wanadoo.es>, 'Christoph Hellwig' <hch@infradead.org>
Cc: 'linux-scsi' <linux-scsi@vger.kernel.org>, 'Tosatti' <marcelo.tosatti@cyclades.com>

Time and priority is the enemy ... not the maintainers, gatekeepers,
volunteeers or the vendors.

There are currently three effective code bases a vendor driver maintainer is
to submit to Distribution, 2.4.* and 2.6.*. OEMs and Channel, the vendor's
customers, only concern themselves about Distributions.

Give me a guess as to where 99% of the noise that enters my cube results
from?

With the Distributions producing errata kernels at a breakneck pace (12
different errata kernels over Christmas break), testers bombarding us with
problem reports to distill to root cause, sometimes the job gets kind of
overwhelming.

I only try to do my best to ensure that all the mindshare of improvements
and enhancements that result from OEM, Channel, internal testing gets into
all trees. Let's just assume that *this* submission is a request for
comment, which was what I had in mind, and not a flashpoint. Soon, or rather
as soon as I can get to it, I will try to produce bite size diffs for each
class of fix to be taken each on their own merit in an effort to synchronize
the 2.4.* tree with the 2.6.* and Distribution trees.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Xose Vazquez Perez
Sent: Thursday, January 08, 2004 1:47 PM
To: Christoph Hellwig
Cc: linux-scsi; Tosatti
Subject: Re: [PATCH] gdth driver for 2.4.23-pre4

Christoph Hellwig wrote:

> The update doesn't look like critical fixes.  

gdth not, but ask in Linux-Poweredge@dell.com about _aacraid_ driver
stability and search in bugzilla.redhat.com about it. Or ask too to
dpt_i2o or fusion customers

> And if the vendors don't want to update their drivers that's the best
> sign for possible customers to buy other hardware instead..

the truth is that they update the driver and the patch is real.
But nobody cares for it.

who is guilty?  linux kernel maintainers or vendor driver maintainer ?

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
