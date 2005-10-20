From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Thu, 20 Oct 2005 09:45:39 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C048F0E9C@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:40070 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932209AbVJTPp7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 11:45:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>, Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Thursday, October 20, 2005 9:29 AM,  Luben Tuikov wrote:
 
> >  That's why I need the local_attached flag as an internal
> > helper - it's not actually exposed to userland so the implementation
> 
> 1) LSI does have SMP pass through.
> 2) You absolutely do not need to represent all phys on the domain,
> which is, as I said, a completely _crazy_ idea.  Look, even 
> SDI doesn't
> want you to do that.  What SDI wants you to do is issue SMP out.
> LSI does have SMP pass through in FW so use that.
> 3) All you care about is SDI, and SDI has a _spec_.  Your job is
> twofold:
> 	- implement drivers/scsi/sdi.c so we can all use it,
> 	- implement the implementation/hw dependent way to
> 	access SDI functionality for Fusion as described above
> 	where I mention that this would be implementation dependent
> 	(dispatching to).
> 

Thanks Luben - My concern is converting our SDI/CSMI ioctls
into what is acceptable in mainstream kernel.  Agreed with Luben,
all the expander data gathering, and configuration can be done 
in user space, which is what is being done by the HP application
folks which are currently using our internal CSMI enabled drivers.
 
I added expander support a couple rev's back since none of the 
non-direct attached sas/sata devices were not scanned and reported
to the block layer above.  This was a problem when our sas driver 
was converted to work with sas_transport.

Best Regards,
Eric Moore

