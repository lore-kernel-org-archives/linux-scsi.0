From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] DVD-RAM rewritable again
Date: Wed, 4 Aug 2004 13:38:30 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040804113829.GJ10340@suse.de>
References: <20040804045839.GA8139@suse.de> <1091619347.5681.6.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:27838 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S264307AbUHDLkJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2004 07:40:09 -0400
Content-Disposition: inline
In-Reply-To: <1091619347.5681.6.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org, Marcelo Tosatti <marcelo.tosatti@cyclades.com>, John McKell <McKellj@iomega.com>

On Wed, Aug 04 2004, Pat LaVarre wrote:
> > > @@ -536,6 +536,8 @@ static int cdrom_open_write(struct cdrom
> > >  	if (CDROM_CAN(CDC_RAM) &&
> > >  	    !CDROM_CAN(CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R)) 
> > >  		ret = cdrom_ram_open_write(cdi);
> > > +	else if (CDROM_CAN(CDC_DVD_RAM))
> > > +		ret = 0;
> > ...
> > That looks fine!
> 
> Good to hear, I was not certain.
> 
> Can I/ should I do anything more to help, ... before we begin the 2.4.28
> work of making USB DVD-RAM discs also rewritable, same as USB Iomega REV
> discs?

Prepare a patch against current 2.4.27-rc5 with everything, test it, and
then we can send it to Marcelo when 2.4.28 opens.

-- 
Jens Axboe

