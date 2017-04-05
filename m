From: Christoph Hellwig <hch@lst.de>
Subject: Re: ->retries fixups V2
Date: Wed, 5 Apr 2017 20:16:05 +0200
Message-ID: <20170405181605.GA9702@lst.de>
References: <20170405171812.19911-1-hch@lst.de> <20170405180653.GA5548@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58518 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933848AbdDESQH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 5 Apr 2017 14:16:07 -0400
Content-Disposition: inline
In-Reply-To: <20170405180653.GA5548@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Apr 05, 2017 at 12:06:53PM -0600, Jens Axboe wrote:
> On Wed, Apr 05 2017, Christoph Hellwig wrote:
> > This series fixes a few lose bits in terms of how nvme uses ->retries,
> > including fixing it for non-PCIe transports.  While at it I noticed that
> > nvme and scsi use the field in entirely different ways, and no other
> > driver uses it at all.  So I decided to move it into the nvme_request and
> > scsi_request structures instead.
> > 
> > Changes since V1:
> >  - better changelog for one patch
> >  - move the new retries field to the end of struct nvme_request
> 
> Applied for 4.12. If we do the below on my box, we remove the (now) 2
> holes from struct request and shrink it 8 bytes.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
