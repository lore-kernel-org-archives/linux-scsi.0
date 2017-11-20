From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v15 5/5] PCI: Remove PCI pool macro functions
Date: Mon, 20 Nov 2017 14:34:49 -0600
Message-ID: <20171120203449.GA16362@bhelgaas-glaptop.roam.corp.google.com>
References: <20171120193247.8187-1-romain.perier@gmail.com>
 <20171120193247.8187-6-romain.perier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171120193247.8187-6-romain.perier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Romain Perier <romain.perier@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Aviad Krawczyk <aviad.krawczyk@huawei.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org, dmaengine@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Romain Perier <romain.perier@collabora.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 20, 2017 at 08:32:47PM +0100, Romain Perier wrote:
> From: Romain Perier <romain.perier@collabora.com>
> 
> Now that all the drivers use dma pool API, we can remove the macro
> functions for PCI pool.
> 
> Signed-off-by: Romain Perier <romain.perier@collabora.com>
> Reviewed-by: Peter Senna Tschudin <peter.senna@collabora.com>

I already acked this once on Oct 24.  Please keep that ack and include
it in any future postings so I don't have to deal with this again.

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  include/linux/pci.h | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 96c94980d1ff..d03b4a20033d 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1324,15 +1324,6 @@ int pci_set_vga_state(struct pci_dev *pdev, bool decode,
>  #include <linux/pci-dma.h>
>  #include <linux/dmapool.h>
>  
> -#define	pci_pool dma_pool
> -#define pci_pool_create(name, pdev, size, align, allocation) \
> -		dma_pool_create(name, &pdev->dev, size, align, allocation)
> -#define	pci_pool_destroy(pool) dma_pool_destroy(pool)
> -#define	pci_pool_alloc(pool, flags, handle) dma_pool_alloc(pool, flags, handle)
> -#define	pci_pool_zalloc(pool, flags, handle) \
> -		dma_pool_zalloc(pool, flags, handle)
> -#define	pci_pool_free(pool, vaddr, addr) dma_pool_free(pool, vaddr, addr)
> -
>  struct msix_entry {
>  	u32	vector;	/* kernel uses to write allocated vector */
>  	u16	entry;	/* driver uses to specify entry, OS writes */
> -- 
> 2.14.1
> 
