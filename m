From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH 6/8] kernel-doc: fix scsi docbook
Date: Sun, 3 Feb 2008 20:22:30 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0802032014450.2108@shark.he.net>
References: <Pine.LNX.4.64.0802031445490.3021@shark.he.net>
 <1202085030.3318.132.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:46876 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754285AbYBDEWd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 Feb 2008 23:22:33 -0500
Received: from shark.he.net ([66.160.160.2]) by xenotime.net for <linux-scsi@vger.kernel.org>; Sun, 3 Feb 2008 20:22:31 -0800
In-Reply-To: <1202085030.3318.132.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>, linux-scsi@vger.kernel.org, akpm@linux-foundation.org

On Sun, 3 Feb 2008, James Bottomley wrote:

> On Sun, 2008-02-03 at 15:06 -0800, Randy.Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Add missing function parameter descriptions.
> > Make function short description fit on one line as required.
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > ---
> >   drivers/scsi/scsi.c |    5 +++--
> >   1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > --- linux-2.6.24-git12.orig/drivers/scsi/scsi.c
> > +++ linux-2.6.24-git12/drivers/scsi/scsi.c
> > @@ -969,9 +969,10 @@ void starget_for_each_device(struct scsi
> >   EXPORT_SYMBOL(starget_for_each_device);
> > 
> >   /**
> > - * __starget_for_each_device  -  helper to walk all devices of a target
> > - *				 (UNLOCKED)
> > + * __starget_for_each_device - helper to walk all devices of a target (UNLOCKED)
> >    * @starget:	target whose devices we want to iterate over.
> > + * @data:	parameter for callback @fn()
> > + * @fn:		callback function that is invoked for each device
> >    *
> >    * This traverses over each device of @starget.  It does _not_
> >    * take a reference on the scsi_device, so the whole loop must be
> ^^^^^
> I have this, but it's a bit mysterious: something added an extra space
> to the non +/- lines making the patch reject.  I pulled it out by hand
> and it applied fine.

Thanks.  I think that I had a pine config error that caused the problem.
Should be fixed now.

-- 
~Randy
