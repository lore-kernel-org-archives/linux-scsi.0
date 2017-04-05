From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 5/5] block, scsi: move the retries field to struct
 scsi_request
Date: Wed, 5 Apr 2017 16:46:56 +0200
Message-ID: <20170405144656.GR3941@linux-x5ow.site>
References: <20170405141856.1862-1-hch@lst.de>
 <20170405141856.1862-6-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170405141856.1862-6-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 05, 2017 at 04:18:56PM +0200, Christoph Hellwig wrote:
> Instead of bloating the generic struct request with it.
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
