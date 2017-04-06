From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/5] nvme: move ->retries setup to nvme_setup_cmd
Date: Thu, 6 Apr 2017 10:55:16 +0200
Message-ID: <20170406085513.GC3768@linux-x5ow.site>
References: <20170405171812.19911-1-hch@lst.de>
 <20170405171812.19911-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170405171812.19911-2-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 05, 2017 at 07:18:08PM +0200, Christoph Hellwig wrote:
> ->retries is counting the number of times a command is resubmitted, and
> be cleared on the first time we see the command.  We currently don't do
> that for non-PCIe command, which is easily fixed by moving the setup
> to common code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Thanks a lot.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
