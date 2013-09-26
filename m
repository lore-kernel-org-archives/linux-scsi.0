From: "Sangeetha Gnanasekaran" <Sangeetha.Gnanasekaran@pmcs.com>
Subject: RE: [PATCH V2 01/10] pm80xx: Device id changes to support series 8 controllers.
Date: Thu, 26 Sep 2013 01:48:56 -0700
Message-ID: <E5DEE6F468524847995699AD11E8088501EDC908@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
References: <5243C5AD.3030607@pmc-sierra.com> <5243D6B1.1060906@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:48458 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756363Ab3IZJHL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Sep 2013 05:07:11 -0400
Content-class: urn:content-classes:message
In-Reply-To: <5243D6B1.1060906@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <xjtuwjp@gmail.com>
Cc: linux-scsi@vger.kernel.org, Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>, Viswas G <Viswas.G@pmcs.com>, Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>

We will modify and send updated patch.

-----Original Message-----
From: Jack Wang [mailto:xjtuwjp@gmail.com] 
Sent: Thursday, September 26, 2013 12:10 PM
To: Anand Kumar Santhanam
Cc: linux-scsi@vger.kernel.org; Sangeetha Gnanasekaran; Nikith
Ganigarakoppal; Viswas G
Subject: Re: [PATCH V2 01/10] pm80xx: Device id changes to support
series 8 controllers.

snip
>  	 */
>  	payload.ase_sh_lm_slr_phyid = cpu_to_le32(SPINHOLD_DISABLE |
>  			LINKMODE_AUTO | LINKRATE_15 |
> -			LINKRATE_30 | LINKRATE_60 | phy_id);
> +			LINKRATE_30 | LINKRATE_60 | LINKRATE_120 |
phy_id);
Is it safe to set 12g linkrate support also on 6g, if so, then :

Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>

>  	/* SSC Disable and SAS Analog ST configuration */
>  	/**
>  	payload.ase_sh_lm_slr_phyid =
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h
b/drivers/scsi/pm8001/pm80xx_hwi.h
> index 2b760ba..9a9116d 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.h
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.h
> @@ -168,6 +168,7 @@
>  #define LINKRATE_15			(0x01 << 8)
>  #define LINKRATE_30			(0x02 << 8)
>  #define LINKRATE_60			(0x06 << 8)
> +#define LINKRATE_120			(0x08 << 8)
>  
>  /* Thermal related */
>  #define	THERMAL_ENABLE			0x1
> @@ -1223,10 +1224,10 @@ typedef struct SASProtocolTimerConfig
SASProtocolTimerConfig_t;
>  
>  /* MSGU CONFIGURATION TABLE*/
>  
> -#define SPCv_MSGU_CFG_TABLE_UPDATE		0x01
> -#define SPCv_MSGU_CFG_TABLE_RESET		0x02
> -#define SPCv_MSGU_CFG_TABLE_FREEZE		0x04
> -#define SPCv_MSGU_CFG_TABLE_UNFREEZE		0x08
> +#define SPCv_MSGU_CFG_TABLE_UPDATE		0x001
> +#define SPCv_MSGU_CFG_TABLE_RESET		0x002
> +#define SPCv_MSGU_CFG_TABLE_FREEZE		0x004
> +#define SPCv_MSGU_CFG_TABLE_UNFREEZE		0x008
>  #define MSGU_IBDB_SET				0x00
>  #define MSGU_HOST_INT_STATUS			0x08
>  #define MSGU_HOST_INT_MASK			0x0C
> 

