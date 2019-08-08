From: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH v3 1/8] scsi: core: fix the dma_max_mapping_size call
Date: Thu, 8 Aug 2019 12:23:19 +0200
Message-ID: <20190808102319.d4wdcp3sfcjqdk44@sirius.home.kraxel.org>
References: <20190808093702.29512-1-kraxel@redhat.com>
 <20190808093702.29512-2-kraxel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190808093702.29512-2-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dri-devel@lists.freedesktop.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, open list <linux-kernel@vger.kernel.org>, tzimmermann@suse.de, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 08, 2019 at 11:36:55AM +0200, Gerd Hoffmann wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> We should only call dma_max_mapping_size for devices that have a DMA mask
> set, otherwise we can run into a NULL pointer dereference that will crash
> the system.
> 
> Also we need to do right shift to get the sectors from the size in bytes,
> not a left shift.

Oops, that wasn't meant to be re-sent, sorry.

drm-misc-next maintainers: any chance for a backmerge to pick up this fix,
so I don't have to carry it in my branches?

thanks,
  Gerd
