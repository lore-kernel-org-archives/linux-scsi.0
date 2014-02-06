From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/15] blk-mq: support at_head inserations for
 blk_execute_rq
Date: Thu, 6 Feb 2014 08:17:10 -0800
Message-ID: <20140206161710.GB16916@infradead.org>
References: <20140205124118.332902571@bombadil.infradead.org>
 <20140205124152.477413324@bombadil.infradead.org>
 <CAFR8uedLQyX7aFsuOs4UFYE=sYUOG+jpPMOQzqOW4f_RQGsf2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57994 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaBFQRR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2014 11:17:17 -0500
Content-Disposition: inline
In-Reply-To: <CAFR8uedLQyX7aFsuOs4UFYE=sYUOG+jpPMOQzqOW4f_RQGsf2g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Feb 05, 2014 at 06:27:38PM -0800, Muthu Kumar wrote:
> Currently its not used by any drivers. Are we sure we don't need it
> public? If sure, please remove the EXPORT_SYMBOL() for it.

Drivers shouldn't use it, it's a low-level interface.  As mentioned in
the intro this is not quite a coherent series yet, but I'll post the
blk-mq patches in a slightly nicer form agains Jens' tree soon.

