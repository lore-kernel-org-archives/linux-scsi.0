From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] block: add support for discard limits
Date: Fri, 30 Oct 2009 01:03:33 -0400
Message-ID: <20091030050333.GB17714@infradead.org>
References: <20091029150830.497006534@bombadil.infradead.org> <20091029151127.257902381@bombadil.infradead.org> <20091029190659.GW10727@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56990 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbZJ3FD3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2009 01:03:29 -0400
Content-Disposition: inline
In-Reply-To: <20091029190659.GW10727@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, mkp@mkp.net, matthew@wil.cx

On Thu, Oct 29, 2009 at 08:06:59PM +0100, Jens Axboe wrote:
> On Thu, Oct 29 2009, Christoph Hellwig wrote:
> > To properly support discard on SCSI Arrays we need to take the discard
> > granularity and the first aligned discard LBA into account.  This patch
> > adds block limits for both of them, and trims down dicard requests to fit
> > into these limits in blkdev_issue_discard.  We also make sure the alignment
> > offset is properly adjust for partitions and add sysfs files to expose
> > the limits to userspaced.
> 
> Except for a few typos, this looks good to me. I'll add it for 2.6.33.

It would be good if we could queue up this (or mkp's version) with the
sd bits through the scsi tree - otherwise getting testing for the whole
stack will be a pain.

