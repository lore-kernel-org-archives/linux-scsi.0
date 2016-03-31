From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 3/5] scsi_transport_iscsi: Remove set-but-not-used
 variables
Date: Thu, 31 Mar 2016 10:01:29 +0200
Message-ID: <d8da8f5f56d7b51c605700ec9676caf1@suse.de>
References: <56FC1A3B.4040704@sandisk.com> <56FC1A8F.1030504@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37559 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbcCaIBb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2016 04:01:31 -0400
In-Reply-To: <56FC1A8F.1030504@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2016-03-30 20:27, Bart Van Assche wrote:
> Avoid that building with W=1 causes gcc to report warnings about
> set-but-not-used variables.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c
> b/drivers/scsi/scsi_transport_iscsi.c
> index 4414816..446781d 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2067,13 +2067,10 @@ EXPORT_SYMBOL_GPL(iscsi_alloc_session);
> 
>  int iscsi_add_session(struct iscsi_cls_session *session, unsigned int
> target_id)
>  {
> -	struct Scsi_Host *shost = iscsi_session_to_shost(session);
> -	struct iscsi_cls_host *ihost;
>  	unsigned long flags;
>  	int id = 0;
>  	int err;
> 
> -	ihost = shost->shost_data;
>  	session->sid = atomic_add_return(1, &iscsi_session_nr);
> 
>  	if (target_id == ISCSI_MAX_TARGET) {

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
