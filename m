From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] qlogicpti: Fix compiler warnings
Date: Wed, 23 Nov 2016 20:25:52 -0500 (EST)
Message-ID: <20161123.202552.1154659754872541108.davem@davemloft.net>
References: <1479936597-29061-1-git-send-email-tushar.n.dave@oracle.com>
        <1479941859.2417.28.camel@HansenPartnership.com>
        <f551b4db-610a-441d-e01d-1be258f7408e@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <f551b4db-610a-441d-e01d-1be258f7408e@oracle.com>
Sender: sparclinux-owner@vger.kernel.org
To: tushar.n.dave@oracle.com
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, thomas.tai@oracle.com, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: tndave <tushar.n.dave@oracle.com>
Date: Wed, 23 Nov 2016 17:08:23 -0800

> As per my understanding, I think, all DMA map/unmap go through
> ATU (iommu) in sun4v sparc. To guarantee that driver doesn't get DMA
> address beyond its addressable range , driver must set dma mask before
> requesting any DMA mapping!
> 
> I will investigate further and send v2.
> 
> Thanks for the review.

This is an SBUS driver, it's not going to execute on any sun4v
system.
