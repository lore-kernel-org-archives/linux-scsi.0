From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: Re: [PATCH] DVD-RAM rewritable again
Date: Wed, 4 Aug 2004 08:57:23 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040804115723.GB9653@logos.cnet>
References: <20040804045839.GA8139@suse.de> <1091619347.5681.6.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:45443 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261375AbUHDMaI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Aug 2004 08:30:08 -0400
Content-Disposition: inline
In-Reply-To: <1091619347.5681.6.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org, John McKell <McKellj@iomega.com>

On Wed, Aug 04, 2004 at 05:35:47AM -0600, Pat LaVarre wrote:
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
> 
> Pat LaVarre
> 
> P.S. I notice kernel.org changing in parallel with this thread:
> 
> --- http://www.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.27.log
> ...
> Summary of changes from v2.4.27-rc4 to v2.4.27-rc5
> ...
> Marcelo Tosatti:
>   o Revert DVD-RW write support for now: axboe@suse.de|ChangeSet|20040606235035|46544
>   o Cset exclude: axboe@suse.de|ChangeSet|20040607195639|57919
> ...
> ---
> 
> Me the kernelnewbie, I don't yet know how to click thru to a ChangeSet
> to see specifically what these summaries mean.

Go to http://linux.bkbits.net/linux-2.4 then you can easily see the changesets... 

