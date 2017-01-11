From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/15] block/bsg: move queue creation into
        bsg_setup_queue
Date: Wed, 11 Jan 2017 09:45:12 +0100
Message-ID: <20170111084512.GA6937@lst.de>
References: <1484060780-15592-1-git-send-email-hch@lst.de> <1484060780-15592-15-git-send-email-hch@lst.de> <20170111084218.GB6286@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34216 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751607AbdAKIpO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Jan 2017 03:45:14 -0500
Content-Disposition: inline
In-Reply-To: <20170111084218.GB6286@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Wed, Jan 11, 2017 at 09:42:44AM +0100, Johannes Thumshirn wrote:
> On Tue, Jan 10, 2017 at 04:06:19PM +0100, Christoph Hellwig wrote:
> > Simply the boilerplate code needed for bsg nodes a bit.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> 
> that reminds me of posting my SAS bsg-lib patch...

Yes.  Having SAS use bsg-lib, and bsg-lib switched away from abusing
struct request_queue would make this series a lot cleaner.

So maybe we should get that into the scsi tree for 4.10 together
with the prep patches in this series as a priority and defer the actual
struct request changes once again.  That should also give us some more
time to sort out the dm-mpath story..
