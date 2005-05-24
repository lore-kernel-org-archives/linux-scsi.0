From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Tue, 24 May 2005 09:08:56 +0200
Message-ID: <20050524070856.GV9855@suse.de>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave> <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de> <4292CF5D.90809@pobox.com> <4292D275.8070409@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:32690 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261366AbVEXHJU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 03:09:20 -0400
Content-Disposition: inline
In-Reply-To: <4292D275.8070409@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

On Tue, May 24 2005, Hannes Reinecke wrote:
> Jeff Garzik wrote:
> [ .. ]
> > 
> > Longer term, SATA PM through SCSI will have three facets:
> > 
> > * Device PM.  This is best handled by the device class driver (sd/sr/st).
> > 
> > * Bus PM.  This is best handled by the transport class driver (need to
> > write for SATA and SAS).
> > 
> > * Host PM.  This is handled in the obvious manner, using existing PM
> > driver hooks.  PCI D0/D3, etc.
> > 
> > I can describe how this will look when libata is divorced from SCSI, if
> > you would like, too...
> 
> Divorced from SCSI? Care to elaborate?

libata being a scsi citizen was just a temporary solution, Jeff has
promised to turn it into a real block driver for years :)

-- 
Jens Axboe

