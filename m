From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V6 2/3] dma-mapping: Rework
        dma_get_cache_alignment()function
Date: Thu, 21 Sep 2017 16:36:27 +0200
Message-ID: <20170921143627.GA18424@lst.de>
References: <1505811161-25246-1-git-send-email-chenhc@lemote.com> <1505811161-25246-2-git-send-email-chenhc@lemote.com> <20170919150252.GA23540@lst.de> <tencent_0C366F4D229840FF7D683E10@qq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <tencent_0C366F4D229840FF7D683E10@qq.com>
Sender: stable-owner@vger.kernel.org
To: =?utf-8?B?6ZmI5Y2O5omN?= <chenhc@lemote.com>
Cc: Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel <linux-kernel@vger.kernel.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, stable <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 21, 2017 at 12:28:25PM +0800, 陈华才 wrote:
> Hi, Christoph,
> 
> I have changed dma_get_cache_alignment's return value, and I don't know whether those drivers want to return ARCH_DMA_MINALIGN unconditionally. So I pass a NULL for those drivers, in order to keep their old behavior.

Per our documentation yes, they do want ARCH_DMA_MINALIGN.  Please
Cc all the driver maintainers on your updated patch so that they can
review it, though.
