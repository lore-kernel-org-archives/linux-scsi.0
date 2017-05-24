From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 30/31] scsi: virtio: Remove code that zeroes
 driver-private command data
Date: Wed, 24 May 2017 08:14:43 +0200
Message-ID: <ef73e928-26af-53d4-0e60-719c47c979ce@suse.de>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
 <20170524003420.5381-31-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60882 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S936309AbdEXGOp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 May 2017 02:14:45 -0400
In-Reply-To: <20170524003420.5381-31-bart.vanassche@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, "Michael S . Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>

On 05/24/2017 02:34 AM, Bart Van Assche wrote:
> Since the SCSI core zeroes driver-private command data, remove
> that code from the virtio driver.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/virtio_scsi.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index f8dbfeee6c63..dc2e97c543a5 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -547,7 +547,6 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
>  	dev_dbg(&sc->device->sdev_gendev,
>  		"cmd %p CDB: %#02x\n", sc, sc->cmnd[0]);
>  
> -	memset(cmd, 0, sizeof(*cmd));
>  	cmd->sc = sc;
>  
>  	BUG_ON(sc->cmd_len > VIRTIO_SCSI_CDB_SIZE);
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
