From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/8] bfa: fix calls to dma_set_mask_and_coherent()
Date: Mon, 18 Feb 2019 10:25:25 +0100
Message-ID: <20190218092525.GE5241@lst.de>
References: <20190218073426.111853-1-hare@suse.de> <20190218073426.111853-6-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190218073426.111853-6-hare@suse.de>
Sender: stable-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 18, 2019 at 08:34:23AM +0100, Hannes Reinecke wrote:
> The change to use dma_set_mask_and_coherent() incorrectly made a second
> call with the 32 bit DMA mask value when the call with the 64 bit DMA
> mask value succeeded.  This resulted in FC connections failing due
> to corrupted data buffers, and various other SCSI/FCP I/O errors.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
