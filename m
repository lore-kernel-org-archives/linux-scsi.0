From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/3] qla2xxx: Indicate out-of-memory with -ENOMEM
Date: Thu, 31 Mar 2016 09:30:41 +0200
Message-ID: <749c8a5ae53c4e76f0c4853c53518360@suse.de>
References: <56FC6049.3090303@sandisk.com> <56FC6061.80403@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36167 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbcCaHam (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2016 03:30:42 -0400
In-Reply-To: <56FC6061.80403@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2016-03-31 01:25, Bart Van Assche wrote:
> In the Linux kernel it is preferred to return a meaningful error code
> instead of -1. This patch does not change the behavior of the caller of
> qla82xx_pinit_from_rom().
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Quinn Tran <quinn.tran@qlogic.com>
> Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>
> Cc: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/qla2xxx/qla_nx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c 
> b/drivers/scsi/qla2xxx/qla_nx.c
> index b6b4cfd..54380b4 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -1229,7 +1229,7 @@ qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
>  	if (buf == NULL) {
>  		ql_log(ql_log_fatal, vha, 0x010c,
>  		    "Unable to allocate memory.\n");
> -		return -1;
> +		return -ENOMEM;
>  	}
> 
>  	for (i = 0; i < n; i++) {

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
