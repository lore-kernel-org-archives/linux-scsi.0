From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: SAVE_DATA / RESTORE_POINTERS message confusion
Date: Mon, 30 Apr 2007 20:15:17 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0704301947570.15250@poirot.grange>
References: <Pine.LNX.4.60.0704292249200.4454@poirot.grange>
 <1177881499.3688.82.camel@mulgrave.il.steeleye.com>
 <20070429.143759.71876461.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37597 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1945895AbXD3SPT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Apr 2007 14:15:19 -0400
In-Reply-To: <20070429.143759.71876461.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Sun, 29 Apr 2007, David Miller wrote:

> From: James Bottomley <James.Bottomley@SteelEye.com>
> Date: Sun, 29 Apr 2007 16:18:19 -0500
> 
> > On Sun, 2007-04-29 at 22:56 +0200, Guennadi Liakhovetski wrote:
> > > 2. are they ever sent apart from when accompanying the DISCONNECT / 
> > > RESELECT?
> > 
> > I've never seen an occasion, no.
> 
> I have.
> 
> > > 3. if "yes" to 2 - can the RESTORE be used to "rewind" the pointer to a 
> > > value smaller than the current?
> > 
> > Theoretically, yes.  In practice, no device I've ever heard of has done
> > this.
> 
> I've seen a device do this, and ironically for an inquiry :-)

Ok, looking through t10 docs there seem to be quite a few functions for 
the SAVE DATA POINTERS / MODIFY DATA POINTER / RESTORE POINTERS (btw, even 
POINTER vs. POINTERS use was inconsistent between the spi5r06, s2-r10l, 
ana a random book I have) also apart from the usual DISCONNECT / RESELECT, 
like re-requesting command / data / status.

Is there a SCSI driver that does all this pointer management correctly? 
And that's easy enough to understand and use as an example? For example, 
tmscsim just would reject MODIFY DP. And for every RESTORE POINTERS with 
sg there would be a KERN_INFO printk...

Thanks
Guennadi
---
Guennadi Liakhovetski
