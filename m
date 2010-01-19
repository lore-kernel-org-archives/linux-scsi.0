From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH] lpfc: two branches the same in lpfc_decode_firmware_rev()
Date: Tue, 19 Jan 2010 17:41:06 -0500
Message-ID: <4B563502.6070908@emulex.com>
References: <4B5329AD.9010100@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:13962 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753934Ab0ASWl1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2010 17:41:27 -0500
In-Reply-To: <4B5329AD.9010100@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>

Acked-by:  James Smart <james.smart@emulex.com>

-- james s



Roel Kluin wrote:
> Regardless of the flag state, the branches execute the same code
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/scsi/lpfc/lpfc_ct.c |    7 +------
>  1 files changed, 1 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
> index 0ebcd9b..bf7bf62 100644
> --- a/drivers/scsi/lpfc/lpfc_ct.c
> +++ b/drivers/scsi/lpfc/lpfc_ct.c
> @@ -1843,12 +1843,7 @@ lpfc_decode_firmware_rev(struct lpfc_hba *phba, char *fwrevision, int flag)
>  		c  = (rev & 0x0000ff00) >> 8;
>  		b4 = (rev & 0x000000ff);
>  
> -		if (flag)
> -			sprintf(fwrevision, "%d.%d%d%c%d ", b1,
> -				b2, b3, c, b4);
> -		else
> -			sprintf(fwrevision, "%d.%d%d%c%d ", b1,
> -				b2, b3, c, b4);
> +		sprintf(fwrevision, "%d.%d%d%c%d", b1, b2, b3, c, b4);
>  	}
>  	return;
>  }
> 
