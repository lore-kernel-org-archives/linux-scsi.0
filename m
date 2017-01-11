From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/15] virtio_blk: avoid DMA to stack for the sense
        buffer
Date: Wed, 11 Jan 2017 09:43:06 +0100
Message-ID: <20170111084306.GA6913@lst.de>
References: <1484060780-15592-1-git-send-email-hch@lst.de> <1484060780-15592-2-git-send-email-hch@lst.de> <20170111082646.GA6286@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34207 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756243AbdAKInI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Jan 2017 03:43:08 -0500
Content-Disposition: inline
In-Reply-To: <20170111082646.GA6286@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Wed, Jan 11, 2017 at 09:26:46AM +0100, Johannes Thumshirn wrote:
> Isn't that one already queued in Jens' tree?

Yes, it's now queued up.  Patch 2 was submitted as well and should
hopefully go into the next 4.10 RC.
