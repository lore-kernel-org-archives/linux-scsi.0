From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V6 2/3] dma-mapping: Rework dma_get_cache_alignment()
        function
Date: Tue, 19 Sep 2017 17:02:52 +0200
Message-ID: <20170919150252.GA23540@lst.de>
References: <1505811161-25246-1-git-send-email-chenhc@lemote.com> <1505811161-25246-2-git-send-email-chenhc@lemote.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1505811161-25246-2-git-send-email-chenhc@lemote.com>
Sender: stable-owner@vger.kernel.org
To: Huacai Chen <chenhc@lemote.com>
Cc: Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>  	mdev->limits.reserved_mtts = ALIGN(mdev->limits.reserved_mtts * mdev->limits.mtt_seg_size,
> -					   dma_get_cache_alignment()) / mdev->limits.mtt_seg_size;
> +					   dma_get_cache_alignment(NULL)) / mdev->limits.mtt_seg_size;
>  
>  	mdev->mr_table.mtt_table = mthca_alloc_icm_table(mdev, init_hca->mtt_base,

Please pass the actually relevant struct device for each call.
