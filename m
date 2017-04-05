From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/5] nvme: move the retries count to struct nvme_request
Date: Wed, 5 Apr 2017 17:25:11 +0200
Message-ID: <20170405152511.GA6435@lst.de>
References: <20170405141856.1862-1-hch@lst.de> <20170405141856.1862-5-hch@lst.de> <20170405151430.GS20181@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57810 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755631AbdDEPZN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 5 Apr 2017 11:25:13 -0400
Content-Disposition: inline
In-Reply-To: <20170405151430.GS20181@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Apr 05, 2017 at 11:14:30AM -0400, Keith Busch wrote:
> On Wed, Apr 05, 2017 at 04:18:55PM +0200, Christoph Hellwig wrote:
> > The way NVMe uses this field is entirely different from the older
> > SCSI/BLOCK_PC usage, so move it into struct nvme_request.
> > 
> > Also reduce the size of the file to a unsigned char so that we leave space
> > for additional smaller fields that will appear soon.
> 
> What new fields can we expect? Why temporarily pad the middle of the
> struct instead of appending to the end? The "result" packed nicely
> on 64-bit, at least.

I've got another u8 and a u16 in pending patches.  That being said
moving it to the end might make sense.
