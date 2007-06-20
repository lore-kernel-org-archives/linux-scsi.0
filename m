From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fix req->cmd == INT cases
Date: Wed, 20 Jun 2007 13:22:47 +0100
Message-ID: <20070620122247.GA4443@infradead.org>
References: <4677FD50.2090803@panasas.com> <20070619171610.GH18863@kernel.dk> <4679072C.2010604@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:59832 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbXFTMWu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jun 2007 08:22:50 -0400
Content-Disposition: inline
In-Reply-To: <4679072C.2010604@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 01:53:32PM +0300, Boaz Harrosh wrote:
> Jens Axboe wrote:
> > 
> > If you look at most of the code, it's inside ifdef debug statements or
> > comments most of them. So I don't think you can base any removal
> > suggestion on that.
> > 
> > The patch itself looks fine though, if you send one that isn't mangled
> > I'll apply it to the 2.6.23 branch.
> > 
> Sorry new Thunderbird Installation. I forgot it does that.
> 
>  - I have unearthed very old bugs in stale drivers that still
>    used request->cmd as a READ|WRITE int
>  - This patch is maybe a proof that these drivers have not been
>    used for a long time. Should they be removed completely?
> 
> Drivers that currently do not work for sure:
>  drivers/acorn/block/fd1772.c
>  drivers/acorn/block/mfmhd.c

Afaik these are old arm26 driver, and that port is dead and should
probably be removed from the tree entirely.

>  drivers/cdrom/aztcd.c
>  drivers/cdrom/cm206.c
>  drivers/cdrom/gscd.c
>  drivers/cdrom/mcdx.c
>  drivers/cdrom/optcd.c
>  drivers/cdrom/sjcd.c

These are old cdrom drivers that are broken in various ways and probably
should be killed off aswell.
