From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 07/31] scsi: Use blk_mq_rq_to_pdu() to convert a request
 to a SCSI command pointer
Date: Wed, 24 May 2017 09:50:44 +0200
Message-ID: <b90d97eb-1686-3f51-28b3-f714b56a4aad@suse.de>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
 <20170524003420.5381-8-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170524003420.5381-8-bart.vanassche@sandisk.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On 05/24/2017 02:33 AM, Bart Van Assche wrote:
> Since commit e9c787e65c0c ("scsi: allocate scsi_cmnd structures as
> part of struct request") struct request and struct scsi_cmnd are
> adjacent. This means that there is now an alternative to reading
> req->special to convert a pointer to a prepared request into a
> SCSI command pointer, namely by using blk_mq_rq_to_pdu(). Make
> this change where appropriate. Although this patch does not
> change any functionality, it slightly improves performance and
> slightly improves readability.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> ---

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>


-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
