From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: PS3: sg chaining support
Date: Wed, 18 Jul 2007 08:33:58 +0200
Message-ID: <20070718063357.GK5625@kernel.dk>
References: <Pine.LNX.4.62.0707171806100.29326@pademelon.sonytel.be> <469D3224.50608@am.sony.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:5096 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764487AbXGRGe0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jul 2007 02:34:26 -0400
Content-Disposition: inline
In-Reply-To: <469D3224.50608@am.sony.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, linux-scsi@vger.kernel.org

On Tue, Jul 17 2007, Geoff Levand wrote:
> Hi Jens.
> 
> Geert Uytterhoeven wrote:
> > ---------- Forwarded message ----------
> > Date: Mon, 16 Jul 2007 11:47:26 +0200
> > From: Jens Axboe <jens.axboe@oracle.com>
> > To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
> > Cc: Jens Axboe <jens.axboe@oracle.com>, paulus@samba.org
> > Subject: [PATCH 12/33] PPC: sg chaining support
> > 
> > This updates the ppc iommu/pci dma mappers to sg chaining.
> > 
> > Cc: paulus@samba.org
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > ---
> >  arch/powerpc/kernel/dma_64.c            |    5 +++--
> >  arch/powerpc/kernel/ibmebus.c           |   11 ++++++-----
> >  arch/powerpc/kernel/iommu.c             |   18 +++++++++++-------
> >  arch/powerpc/platforms/ps3/system-bus.c |    5 +++--
> >  include/asm-powerpc/dma-mapping.h       |    2 +-
> >  include/asm-powerpc/scatterlist.h       |    2 ++
> >  6 files changed, 26 insertions(+), 17 deletions(-)
> 
> I'm wondering what the status of this work is.  The patch I've
> seen no longer applies to ps3/system-bus.c.  A rebase to
> linux-2.6.git a5fcaa210626a79465321e344c91a6a7dc3881fa is below,
> but untested, as I don't have the other patches to do the build.

I rebased the tree yesterday to resolve that conflict, it's in the
sglist-arch branch now. The result is identical to yours.

Shall I take this as an acked-by?

-- 
Jens Axboe

