From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 09/33] x86-64: update iommu/dma mapping functions to sg
	helpers
Date: Tue, 17 Jul 2007 13:05:03 +0200
Message-ID: <20070717110502.GO5195@kernel.dk>
References: <11845792671245-git-send-email-jens.axboe@oracle.com> <11845792681830-git-send-email-jens.axboe@oracle.com> <20070717110312.GD18721@rhun.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:6313 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbXGQLFi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jul 2007 07:05:38 -0400
Content-Disposition: inline
In-Reply-To: <20070717110312.GD18721@rhun.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, ak@suse.de

On Tue, Jul 17 2007, Muli Ben-Yehuda wrote:
> On Mon, Jul 16, 2007 at 11:47:23AM +0200, Jens Axboe wrote:
> 
> > This prepares x86-64 for sg chaining support.
> > 
> > Additional improvements/fixups for pci-gart from
> > Benny Halevy <bhalevy@panasas.com>
> > 
> > Cc: ak@suse.de
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > ---
> >  arch/x86_64/kernel/pci-calgary.c |   25 ++++++++------
> >  arch/x86_64/kernel/pci-gart.c    |   63 ++++++++++++++++++++-----------------
> >  arch/x86_64/kernel/pci-nommu.c   |    5 ++-
> 
> Calgary and nommu bits are:
> 
> Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>

Great, thanks!

> FYI, here's the Calgary diff on top of the outstanding Calgary
> changes.

When are these bits being merged into mainline? I'll hang on to this
version for helping me rebase the arch bits of chained sglists once that
happens.

-- 
Jens Axboe

