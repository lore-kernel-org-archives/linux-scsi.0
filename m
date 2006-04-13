From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] dc395x: dynamically map scatter-gather for PIO (take 2)
Date: Thu, 13 Apr 2006 23:02:04 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0604132256490.4711@poirot.grange>
References: <Pine.LNX.4.60.0604022004520.17410@poirot.grange>
 <20060413132932.31871824.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38573 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S932467AbWDMVCI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Apr 2006 17:02:08 -0400
In-Reply-To: <20060413132932.31871824.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Sebastian@schnapsleichen.de, roubert@df.lth.se, lenehan@twibble.org

On Thu, 13 Apr 2006, Randy.Dunlap wrote:

> On Sun, 2 Apr 2006 21:57:43 +0200 (CEST) Guennadi Liakhovetski wrote:
> 
> > Hello all,
> > 
> > This time I really mean it:-)
> 
> Hi Guennadi,
> James pointed me at this patch since I have aha152x also having
> problems with using page_address() while trying to do PIO.
> I see a NULL pointer during a data-out phase.  I'll attempt
> to use the kmap_atomic() support that you have added in the
> aha152x driver.

Would be great to put these functions under some more extensive testing! 
I also want to use them in tmscsim, but there I do not have a test case 
for PIO:-(

> > + * scsi_kmap_atomic_sg - find and atomically map an sg-elemnt
> 
> s/elemnt/element/

Thanks.

> > +/**
> > + * scsi_kunmap_atomic_sg - atomically unmap a virtual address, previously
> > + *			   mapped with scsi_kmap_atomic_sg
> 
> First line of function kernel-doc must be just one line long.  Sorry.  :(
> You can add more descriptive text after the parameter(s) plus one
> blank line if you want to do it that way.

Sure, thanks. I'll do the necessary modifications in the next version of 
the patch. I'd wait a bit more to see if there are some more comments.

Regards
Guennadi
---
Guennadi Liakhovetski
