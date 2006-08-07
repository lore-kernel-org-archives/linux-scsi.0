From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 3/4] aacraid: Check for unlikely errors
Date: Mon, 7 Aug 2006 07:51:13 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F02AC7458@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:51115 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1750794AbWHGLvO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2006 07:51:14 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

During adapter reset.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org] 
> Sent: Friday, August 04, 2006 11:25 AM
> To: Mark Haverkamp
> Cc: James Bottomley; Salyzyn, Mark; linux-scsi
> Subject: Re: [PATCH 3/4] aacraid: Check for unlikely errors
> 
> 
> On Thu, Aug 03, 2006 at 08:03:07AM -0700, Mark Haverkamp wrote:
> > Received from Mark Salyzyn
> > 
> > The enclosed patch cleans up some code fragments, adds some paranoia
> > (unproven causes of potential driver failures). 
> > 
> > Signed-off-by: Mark Haverkamp <markh@osdl.org>
> > ---
> > 
> > --- scsi-misc-aac.orig/drivers/scsi/aacraid/aachba.c	
> 2006-07-31 14:33:27.000000000 -0700
> > +++ scsi-misc-aac/drivers/scsi/aacraid/aachba.c	
> 2006-07-31 14:33:51.000000000 -0700
> > @@ -489,6 +489,8 @@
> >  	unsigned instance;
> >  
> >  	fsa_dev_ptr = dev->fsa_dev;
> > +	if (!fsa_dev_ptr)
> > +		return -ENOMEM;
> 
> How could this (and the fsa_dev_ptr in all other places) ever be null?
> 
> 
