From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/11] scsi: don't force tagged_supported in drivers
Date: Tue, 4 Nov 2014 11:34:26 +0100
Message-ID: <20141104103426.GA19154@lst.de>
References: <1415087656-9491-1-git-send-email-hch@lst.de> <1415087656-9491-11-git-send-email-hch@lst.de> <CAD+HZHUu_yw7x2GxHdnnGCktneihSX+C-8=yHVa1A3E7BGp10A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51237 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbaKDKec (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 05:34:32 -0500
Content-Disposition: inline
In-Reply-To: <CAD+HZHUu_yw7x2GxHdnnGCktneihSX+C-8=yHVa1A3E7BGp10A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <xjtuwjp@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

On Tue, Nov 04, 2014 at 09:16:30AM +0100, Jack Wang wrote:
> > diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
> > index 56d698a..89e8b68 100644
> > --- a/drivers/scsi/libsas/sas_scsi_host.c
> > +++ b/drivers/scsi/libsas/sas_scsi_host.c
> > @@ -945,7 +945,6 @@ int sas_slave_configure(struct scsi_device *scsi_dev)
> >                 SAS_DPRINTK("device %llx, LUN %llx doesn't support "
> >                             "TCQ\n", SAS_ADDR(dev->sas_addr),
> >                             scsi_dev->lun);
> > -               scsi_dev->tagged_supported = 0;
> >                 scsi_adjust_queue_depth(scsi_dev, 1);
> >         }
> Hi Christoph,
> 
> The commit msg doesn't match for above, is it intentional ?

It's a force off in a branch where it's already guaranteed to be off,
but I'll update the description to include this hunk.
