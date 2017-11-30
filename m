From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 16/22] qla2xxx: Fix scan state field for fcport
Date: Thu, 30 Nov 2017 17:20:06 +0100
Message-ID: <bbe82464-b4a8-e026-7cab-ea266eda7fb4@suse.de>
References: <20171130034047.15070-1-himanshu.madhani@cavium.com>
 <20171130034047.15070-17-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57552 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751267AbdK3QUH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Nov 2017 11:20:07 -0500
In-Reply-To: <20171130034047.15070-17-himanshu.madhani@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On 11/30/2017 04:40 AM, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> Add correct value of scan_state field indicating state
> of the FC port
> 
> Fixes: 726b85487067d ("qla2xxx: Add framework for async fabric discovery")
> Cc: <stable@vger.kernel.org> # 4.10+
> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 2a6242d97a7e..1c219998ab60 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -5812,6 +5812,7 @@ static fc_port_t *qlt_get_port_database(struct scsi_qla_host *vha,
>  		tfcp->port_type = fcport->port_type;
>  		tfcp->supported_classes = fcport->supported_classes;
>  		tfcp->flags |= fcport->flags;
> +		tfcp->scan_state = QLA_FCPORT_FOUND;
>  
>  		del = fcport;
>  		fcport = tfcp;
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
