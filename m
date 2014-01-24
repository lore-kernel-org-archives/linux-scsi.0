From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 5/6] megaraid_sas_fusion: Return correct error value in
 megasas_get_ld_map_info()
Date: Fri, 24 Jan 2014 08:45:36 +0000
Message-ID: <f523d66236884d3f95f3e096cb6f3baf@BN1PR07MB247.namprd07.prod.outlook.com>
References: <1389867936-118685-1-git-send-email-hare@suse.de>
 <1389867936-118685-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:48126
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751268AbaAXIpu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2014 03:45:50 -0500
In-Reply-To: <1389867936-118685-6-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Adam Radford <aradford@gmail.com>

ACK this patch.

` Kashyap

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Thursday, January 16, 2014 3:56 PM
> To: James Bottomley
> Cc: linux-scsi@vger.kernel.org; Hannes Reinecke; Desai, Kashyap; Adam
> Radford
> Subject: [PATCH 5/6] megaraid_sas_fusion: Return correct error value in
> megasas_get_ld_map_info()
> 
> When no HBA is found we should be returning '-ENXIO' to be consistent with
> the other return values.
> 
> Cc: Kashyap Desai <kashyap.desai@lsi.com>
> Cc: Adam Radford <aradford@gmail.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index be6de80..c2dc033 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -726,7 +726,7 @@ megasas_get_ld_map_info(struct megasas_instance
> *instance)
> 
>  	if (!fusion) {
>  		megasas_return_cmd(instance, cmd);
> -		return 1;
> +		return -ENXIO;
>  	}
> 
>  	dcmd = &cmd->frame->dcmd;
> --
> 1.7.12.4
> 

