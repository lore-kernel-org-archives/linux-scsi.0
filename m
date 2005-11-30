From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 5/5] aacraid: Check scsi_bios_ptabe return code
	(Updated)
Date: Wed, 30 Nov 2005 20:47:22 +0100
Message-ID: <1133380042.2825.62.camel@laptopd505.fenrus.org>
References: <1133375802.2288.25.camel@markh1.pdx.osdl.net>
	 <20051130191400.GD19001@infradead.org>
	 <1133379795.2288.32.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:30355 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751566AbVK3Tr1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 14:47:27 -0500
In-Reply-To: <1133379795.2288.32.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>

On Wed, 2005-11-30 at 11:43 -0800, Mark Haverkamp wrote:
> On Wed, 2005-11-30 at 19:14 +0000, Christoph Hellwig wrote:
> > On Wed, Nov 30, 2005 at 10:36:42AM -0800, Mark Haverkamp wrote:
> > > Received from Mark Salyzyn.
> > > 
> > > scsi_bios_ptable return value is not being checked in aac_biosparm.
> > 
> > should probably go into 2.6.15 after the usual trivial codingstyle fix..
> > 
> > >  	buf = scsi_bios_ptable(bdev);
> > > +	if(buf == NULL)
> > > +		return 0;
> > 
> > 	if (!buf)
> > 		return 0;
> OK, here is the updated patch:

I think your space bar is defective on your keyboard

>  	buf = scsi_bios_ptable(bdev);
> +	if(!buf)
> +		return 0;

in linux we put a space between the if and the ()'s



