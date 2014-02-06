From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/15] blk-mq: support at_head inserations for
 blk_execute_rq
Date: Thu, 6 Feb 2014 09:10:23 -0800
Message-ID: <20140206171023.GA28625@infradead.org>
References: <20140205124118.332902571@bombadil.infradead.org>
 <20140205124152.477413324@bombadil.infradead.org>
 <CAFR8uedLQyX7aFsuOs4UFYE=sYUOG+jpPMOQzqOW4f_RQGsf2g@mail.gmail.com>
 <20140206161710.GB16916@infradead.org>
 <CAFR8uedQ2kHP6caUQewSixtRbOw7vWjyaJtK66ENbOVUJLXAag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58211 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbaBFRKb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2014 12:10:31 -0500
Content-Disposition: inline
In-Reply-To: <CAFR8uedQ2kHP6caUQewSixtRbOw7vWjyaJtK66ENbOVUJLXAag@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>

On Thu, Feb 06, 2014 at 09:05:10AM -0800, Muthu Kumar wrote:
> Alright then.. I will wait for that patch. BTW, is the scsi-mq work
> done on your git tree only or anyone else has their own git tree

For now I put out a git tree for those who don't like large patch
series.  Happy to take patches for it, but we'll have to see who
has the energy to keep the tree in the long run.

That being said I hope to feed patches into the upstream trees as
quickly as possible and thus only keep a small stack of patches around.
