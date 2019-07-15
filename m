From: Christoph Hellwig <hch@lst.de>
Subject: Re: properly communicate queue limits to the DMA layer v2
Date: Mon, 15 Jul 2019 18:58:23 +0200
Message-ID: <20190715165823.GA10029@lst.de>
References: <20190617122000.22181-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190617122000.22181-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 17, 2019 at 02:19:52PM +0200, Christoph Hellwig wrote:
> Hi Martin,
> 
> we've always had a bit of a problem communicating the block layer
> queue limits to the DMA layer, which needs to respect them when
> an IOMMU that could merge segments is used.  Unfortunately most
> drivers don't get this right.  Oddly enough we've been mostly
> getting away with it, although lately dma-debug has been catching
> a few of those issues.

Ping?  What happened to this set of bug fixes?
