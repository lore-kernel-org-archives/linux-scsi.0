From: Mark Greer <mgreer@animalcreek.com>
Subject: Re: [PATCH V9 1/4] dma-mapping: Rework dma_get_cache_alignment()
Date: Tue, 24 Oct 2017 12:11:56 -0700
Message-ID: <20171024191156.GA11341@animalcreek.com>
References: <1508742767-28366-1-git-send-email-chenhc@lemote.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38065 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751280AbdJXTL5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Oct 2017 15:11:57 -0400
Content-Disposition: inline
In-Reply-To: <1508742767-28366-1-git-send-email-chenhc@lemote.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Huacai Chen <chenhc@lemote.com>
Cc: Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>, James Hogan <james.hogan@imgtec.com>, linux-mips@linux-mips.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org, "Michael S . Tsirkin" <mst@redhat.com>, Pawel Osciak <pawel@osciak.com>, Kyungmin Park <kyungmin.park@samsung.com>, Michael Chan <michael.chan@broadcom.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ivan Mikhaylov <ivan@ru.ibm.com>, Tariq Toukan <tariqt@mellanox.com>

On Mon, Oct 23, 2017 at 03:12:44PM +0800, Huacai Chen wrote:
> Make dma_get_cache_alignment() to accept a 'dev' argument. As a result,
> it can return different alignments due to different devices' I/O cache
> coherency.
> 
> Currently, ARM/ARM64 and MIPS support coherent & noncoherent devices
> co-exist. This may be extended in the future, so add a new function
> pointer (i.e, get_cache_alignment) in 'struct dma_map_ops' as a generic
> solution.
> 
> Cc: stable@vger.kernel.org
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Pawel Osciak <pawel@osciak.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Michael Chan <michael.chan@broadcom.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Ivan Mikhaylov <ivan@ru.ibm.com>
> Cc: Tariq Toukan <tariqt@mellanox.com>
> Cc: Andy Gross <agross@codeaurora.org>
> Cc: Mark A. Greer <mgreer@animalcreek.com>
> Cc: Robert Baldyga <r.baldyga@hackerion.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---

For the mpsc stuff:

Acked-by: Mark Greer <mgreer@animalcreek.com>
