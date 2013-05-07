From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V5 12/12] pm80xx: thermal, sas controller config and
 error handling update
Date: Mon, 06 May 2013 23:10:21 -0700
Message-ID: <1367907021.1868.76.camel@dabdike>
References: <5187DC25.3060207@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45617 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752603Ab3EGGKX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 May 2013 02:10:23 -0400
In-Reply-To: <5187DC25.3060207@pmc-sierra.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anand <anandkumar_santhanam@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, sakthivel.sk@hcl.com, Sangeetha.Gnanasekaran@pmcs.com, Harry.Yang@pmcs.com, Rich.Bono@pmcs.com, xjtuwjp@gmail.com, Vishwanath.Maram@pmcs.com

On Mon, 2013-05-06 at 09:36 -0700, Anand wrote:
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
> index 0c15627..ea127b6 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.h
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.h
[...]
> @@ -996,6 +1020,23 @@ struct ssp_coalesced_comp_resp {
>  
>  /* new outbound structure for spcv - ends */
>  
> +/* brief data structure for SAS protocol timer configuration page.
> + *
> + */
> +struct SASProtocolTimerConfig{
> +    __le32 pageCode;                        /* 0 */
> +    __le32 MST_MSI;                         /* 1 */
> +    __le32 STP_SSP_MCT_TMO;                 /* 2 */
> +    __le32 STP_FRM_TMO;                     /* 3 */
> +    __le32 STP_IDLE_TMO;                    /* 4 */
> +    __le32 OPNRJT_RTRY_INTVL;               /* 5 */
> +    __le32 Data_Cmd_OPNRJT_RTRY_TMO;        /* 6 */
> +    __le32 Data_Cmd_OPNRJT_RTRY_THR;        /* 7 */
> +    __le32 MAX_AIP;                         /* 8 */
> +} __attribute__((packed, aligned(4)));

This is wrongly aligned using spaces instead of tabs ... since the rest
of the file is OK, you cut and pasted this from somewhere.
checkpatch.pl warns about this stuff, please use it.

James


