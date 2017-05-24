From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 21/31] scsi: Move most of scsi_init_command() into
 scsi_initialize_rq()
Date: Wed, 24 May 2017 08:09:02 +0200
Message-ID: <527d29a6-f4a8-b84f-4fec-47b4f0b96bf3@suse.de>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
 <20170524003420.5381-22-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170524003420.5381-22-bart.vanassche@sandisk.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/24/2017 02:34 AM, Bart Van Assche wrote:
> Move the initializations that only have to be performed once and
> not every time a request is prepared from scsi_init_command()
> into scsi_initialize_rq(). This patch also moves the
> jiffies_at_alloc assignment such that it gets back the meaning it
> had before commit e9c787e65c0c, namely the value of the jiffies
> counter at request allocation time.
> 
> Fixes: commit e9c787e65c0c ("scsi: allocate scsi_cmnd structures as part of struct request")
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_lib.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
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
