From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 8/8] scsi/pmcraid: Use sgl_alloc_order() and
 sgl_free_order()
Date: Mon, 6 Nov 2017 08:11:11 +0100
Message-ID: <6d5afd7d-3bf5-b829-cb7c-4cbcf9a9d849@suse.de>
References: <20171103222339.26540-1-bart.vanassche@wdc.com>
 <20171103222339.26540-9-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171103222339.26540-9-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Herbert Xu <herbert@gondor.apana.org.au>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
List-Id: linux-scsi@vger.kernel.org

On 11/03/2017 11:23 PM, Bart Van Assche wrote:
> Use the sgl_alloc_order() and sgl_free_order() functions instead
> of open coding these functions.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: linux-scsi@vger.kernel.org
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
> ---
>  drivers/scsi/Kconfig   |  1 +
>  drivers/scsi/pmcraid.c | 43 ++++---------------------------------------
>  drivers/scsi/pmcraid.h |  2 +-
>  3 files changed, 6 insertions(+), 40 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
