From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: Re: [PATCH 2/4] dpt_i2o: move from virt_to_bus/bus_to_virt to
	dma_alloc_coherent
Date: Fri, 02 May 2008 14:15:04 +0200
Message-ID: <1209730504.11360.61.camel@localhost.localdomain>
References: <20080501230632.GA19832@xs4all.net>
	 <200805021325.30504.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1634 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761432AbYEBMOo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 08:14:44 -0400
In-Reply-To: <200805021325.30504.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-scsi@vger.kernel.org


On Fri, 2008-05-02 at 13:25 +0200, Rolf Eike Beer wrote:
> Miquel van Smoorenburg wrote:
> > [PATCH 2/4] dpt_i2o: move from virt_to_bus/bus_to_virt to
> > dma_alloc_coherent
> >
> > Remove virt_to_bus/bus_to_virt code from dpt_i2o, and use
> > dma_alloc_coherent() / dma_free_coherent().
> >
> > *==========================================================================
> >== */
> >
> > +static inline u32 dma_high(dma_addr_t addr)
> > +{
> > +	return upper_32_bits(addr);
> > +}
> > +
> > +static inline u32 dma_low(dma_addr_t addr)
> > +{
> > +	return (u32)addr;
> > +}
> > +
> 
> Just use these instructions directly, no need to introduce functions for that.

I think it makes it more readable. They are inline functions (used like
macro's, really), there's no overhead. Is this against the kernel
codingstyle ?

Mike.

