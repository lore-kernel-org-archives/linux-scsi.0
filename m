From: Jens Axboe <axboe@suse.de>
Subject: Re: Bounce buffer usage
Date: Fri, 1 Nov 2002 17:01:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021101160145.GN8428@suse.de>
References: <8D43EFD7CCBDB24980134BE078C227E7012B70B3@xcm.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8D43EFD7CCBDB24980134BE078C227E7012B70B3@xcm.ad.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Infante, Jon" <Jon.Infante@Emulex.Com>
Cc: linux-scsi@vger.kernel.org

On Fri, Nov 01 2002, Infante, Jon wrote:
> < It requires a driver that uses the pci dma api properly.
> Where can I find information on this api and its proper usage?

Documentation/DMA-mapping.txt

Basically you want drivers that use pci_map_sg and/or pci_map_page.

-- 
Jens Axboe

