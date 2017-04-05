From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 4/5] nvme: move the retries count to struct nvme_request
Date: Wed, 5 Apr 2017 16:45:56 +0200
Message-ID: <20170405144556.GQ3941@linux-x5ow.site>
References: <20170405141856.1862-1-hch@lst.de>
 <20170405141856.1862-5-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48060 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755336AbdDEOqA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 5 Apr 2017 10:46:00 -0400
Content-Disposition: inline
In-Reply-To: <20170405141856.1862-5-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Apr 05, 2017 at 04:18:55PM +0200, Christoph Hellwig wrote:
> The way NVMe uses this field is entirely different from the older
> SCSI/BLOCK_PC usage, so move it into struct nvme_request.
> 
> Also reduce the size of the file to a unsigned char so that we leave space
> for additional smaller fields that will appear soon.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
