From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/2] block: add support for discard limits
Date: Mon, 2 Nov 2009 13:39:36 +0100
Message-ID: <20091102123936.GV10727@kernel.dk>
References: <20091029150830.497006534@bombadil.infradead.org> <20091029151127.257902381@bombadil.infradead.org> <20091029190659.GW10727@kernel.dk> <20091030050333.GB17714@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:37887 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754762AbZKBMq4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Nov 2009 07:46:56 -0500
Content-Disposition: inline
In-Reply-To: <20091030050333.GB17714@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, mkp@mkp.net, matthew@wil.cx

On Fri, Oct 30 2009, Christoph Hellwig wrote:
> On Thu, Oct 29, 2009 at 08:06:59PM +0100, Jens Axboe wrote:
> > On Thu, Oct 29 2009, Christoph Hellwig wrote:
> > > To properly support discard on SCSI Arrays we need to take the discard
> > > granularity and the first aligned discard LBA into account.  This patch
> > > adds block limits for both of them, and trims down dicard requests to fit
> > > into these limits in blkdev_issue_discard.  We also make sure the alignment
> > > offset is properly adjust for partitions and add sysfs files to expose
> > > the limits to userspaced.
> > 
> > Except for a few typos, this looks good to me. I'll add it for 2.6.33.
> 
> It would be good if we could queue up this (or mkp's version) with the
> sd bits through the scsi tree - otherwise getting testing for the whole
> stack will be a pain.

Sure, fine with me. Feel free to add my acked-by.

-- 
Jens Axboe

