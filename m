From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] DVD-RAM rewritable again
Date: 04 Aug 2004 05:35:47 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1091619347.5681.6.camel@patibmrh9>
References: <1091568097.3644.27.camel@patibmrh9><20040804045839.GA8139@suse.
	de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:13745 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264299AbUHDLg1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Aug 2004 07:36:27 -0400
In-Reply-To: <20040804045839.GA8139@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org, Marcelo Tosatti <marcelo.tosatti@cyclades.com>, John McKell <McKellj@iomega.com>

> > @@ -536,6 +536,8 @@ static int cdrom_open_write(struct cdrom
> >  	if (CDROM_CAN(CDC_RAM) &&
> >  	    !CDROM_CAN(CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R)) 
> >  		ret = cdrom_ram_open_write(cdi);
> > +	else if (CDROM_CAN(CDC_DVD_RAM))
> > +		ret = 0;
> ...
> That looks fine!

Good to hear, I was not certain.

Can I/ should I do anything more to help, ... before we begin the 2.4.28
work of making USB DVD-RAM discs also rewritable, same as USB Iomega REV
discs?

Pat LaVarre

P.S. I notice kernel.org changing in parallel with this thread:

--- http://www.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.27.log
...
Summary of changes from v2.4.27-rc4 to v2.4.27-rc5
...
Marcelo Tosatti:
  o Revert DVD-RW write support for now: axboe@suse.de|ChangeSet|20040606235035|46544
  o Cset exclude: axboe@suse.de|ChangeSet|20040607195639|57919
...
---

Me the kernelnewbie, I don't yet know how to click thru to a ChangeSet
to see specifically what these summaries mean.

