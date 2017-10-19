From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V8 1/5] dma-mapping: Rework dma_get_cache_alignment()
Date: Thu, 19 Oct 2017 17:09:21 +0200
Message-ID: <20171019150921.GB24204@lst.de>
References: <1508227542-13165-1-git-send-email-chenhc@lemote.com> <20171018172336.GA29358@animalcreek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171018172336.GA29358@animalcreek.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Greer <mgreer@animalcreek.com>
Cc: Huacai Chen <chenhc@lemote.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>, James Hogan <james.hogan@imgtec.com>, linux-mips@linux-mips.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, stable@vger.kernel.org, "Michael S . Tsirkin" <mst@mellanox.co.il>, Pawel Osciak <pawel@osciak.com>, Kyungmin Park <kyungmin.park@samsung.com>, Michael Chan <michael.chan@broadcom.com>, Benjamin Herrenschmidt <benh@kernel.cras>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 18, 2017 at 10:23:36AM -0700, Mark Greer wrote:
> >  #define	MPSC_RXR_ENTRIES	32
> > -#define	MPSC_RXRE_SIZE		dma_get_cache_alignment()
> > +#define	MPSC_RXRE_SIZE		dma_get_cache_alignment(dma_dev)
> 
> I would much prefer that you add a parameter to the macro to avoid forcing
> a non-flexible and non-obvious variable definition wherever it is used.
> What I mean is something like:
> 
> #define MPSC_RXRE_SIZE(d)		dma_get_cache_alignment(d)
> 
> Similarly for all of the other macros and where they're used.

Agreed.  Except for that the patch looks fine to me, though.
