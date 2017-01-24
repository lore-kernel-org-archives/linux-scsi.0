From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 09/16] scsi: remove gfp_flags member in scsi_host_cmd_pool
Date: Tue, 24 Jan 2017 13:08:22 +0100
Message-ID: <20170124120822.GD3609@linux-x5ow.site>
References: <1485185361-29786-1-git-send-email-hch@lst.de>
 <1485185361-29786-10-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34473 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750767AbdAXMI0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Jan 2017 07:08:26 -0500
Content-Disposition: inline
In-Reply-To: <1485185361-29786-10-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Mon, Jan 23, 2017 at 04:29:14PM +0100, Christoph Hellwig wrote:
> When using the slab allocator we already decide at cache creation time if
> an allocation comes from a GFP_DMA pool using the SLAB_CACHE_DMA flag,
> and there is no point passing the kmalloc-family only GFP_DMA flag to
> kmem_cache_alloc.  Drop all the infrastructure for doing so.
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
