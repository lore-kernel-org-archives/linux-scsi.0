From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: How to replace bus_to_virt()?
Date: Wed, 3 May 2006 21:11:03 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0605032109110.5865@poirot.grange>
References: <4454CF35.7010803@s5r6.in-berlin.de> <1146412215.20760.10.camel@laptopd505.fenrus.org>
 <44554AFE.30804@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:65436 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1750723AbWECTLF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2006 15:11:05 -0400
In-Reply-To: <44554AFE.30804@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 1 May 2006, Stefan Richter wrote:

> Arjan van de Ven wrote:
> > On Sun, 2006-04-30 at 16:52 +0200, Stefan Richter wrote:
> > > is there a *direct* future-proof replacement for bus_to_virt()?
> > > 
> > > It appears there are already architectures which do not define a
> > > bus_to_virt() funtion or macro. If there isn't a direct replacement, is
> > > there at least a way to detect at compile time whether bus_to_virt()
> > > exists?
> > 
> > 
> > I'd go one step further: given a world with iommu's, and multiple pci
> > domains etc, how can you know there even IS such a translation possible
> > (without first having set it up from the other direction)?
> 
> Well, we actually do set it up from the other direction. But in a way that
> does not work with IOMMUs...
> 
> AFAIU, the patch "dc395x: dynamically map scatter-gather for PIO" [1] by
> Guennadi Liakhovetski is dealing with the same issue. I am not yet clear
> whether I could adopt this method for sbp2.
> [1] http://marc.theaimsgroup.com/?l=linux-scsi&t=114400790300004

I would be, obviously, interested to hear any results with that one.

Thanks
Guennadi
---
Guennadi Liakhovetski
