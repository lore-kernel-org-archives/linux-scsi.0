From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 04/11] megaraid_sas : Firmware crash dump feature support
Date: Thu, 11 Sep 2014 13:02:42 -0400
Message-ID: <20140911170242.GB17140@redhat.com>
References: <201409061328.s86DS6lO012975@palmhbs0.lsi.com>
 <540F22A2.3040906@redhat.com>
 <55ba5d7cdee7dbcce18dc1a2bbbefc03@mail.gmail.com>
 <94D0CD8314A33A4D9D801C0FE68B402958C70F51@G9W0745.americas.hpqcorp.net>
 <54106E28.1030807@redhat.com>
 <20140910154643.GC2166@redhat.com>
 <a5608d878571884cb460c7c36a2082c9@mail.gmail.com>
 <54118594.5040307@redhat.com>
 <CAHsXFKH2REAYauW5=Tp=eqaeBxve6rZU3ocXcnpVg2P=72VTQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbaIKREk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Sep 2014 13:04:40 -0400
Content-Disposition: inline
In-Reply-To: <CAHsXFKH2REAYauW5=Tp=eqaeBxve6rZU3ocXcnpVg2P=72VTQw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>
Cc: Tomas Henzl <thenzl@redhat.com>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Sumit Saxena <sumit.saxena@avagotech.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, jbottomley@parallels.com, aradford <aradford@gmail.com>, Michal Schmidt <mschmidt@redhat.com>, amirv@mellanox.com, Jens Axboe <axboe@kernel.dk>, scameron@beardog.cce.hp.com

On Thu, Sep 11, 2014 at 10:09:27PM +0530, Kashyap Desai wrote:

[..]
> > OK, just keep in mind that the is_kdump_kernel() is not yet in mainline.
> 
> Sure I read that part, but when I check kernel source I found
> is_kdump_kernel() is available.
> 
> http://lxr.free-electrons.com/source/include/linux/crash_dump.h#L55
> Let's do one thing - We will submit a separate patch for this to avoid
> any confusion.

is_kdump_kernel() has been there for long time just that it was not
exported. Now a patch is sitting in dave miller's tree to export it
and make it available to drivers.

Thanks
Vivek
