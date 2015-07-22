From: James Smart <james.smart@avagotech.com>
Subject: Re: [PATCH] lpfc: Use && instead of & for boolean expression
Date: Wed, 22 Jul 2015 11:47:20 -0400
Message-ID: <55AFBB08.106@avagotech.com>
References: <20150722105322.00004f4b@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:36059 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934408AbbGVPrm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jul 2015 11:47:42 -0400
Received: by pdjr16 with SMTP id r16so143085840pdj.3
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2015 08:47:41 -0700 (PDT)
In-Reply-To: <20150722105322.00004f4b@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>, linux-scsi@vger.kernel.org

Reviewed-by: James Smart <james.smart@avagotech.com>

Thanks

-- james


On 7/22/2015 4:53 AM, Sebastian Herbszt wrote:
> Use logical instead of bitwise AND.
>
> Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
> ---
>
> diff -urp a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2015-07-05 22:18:43.933739150 +0200
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2015-07-22 10:31:14.240209475 +0200
> @@ -701,7 +701,7 @@ lpfc_work_done(struct lpfc_hba *phba)
>   								HA_RXMASK));
>   			}
>   		}
> -		if ((phba->sli_rev == LPFC_SLI_REV4) &
> +		if ((phba->sli_rev == LPFC_SLI_REV4) &&
>   				 (!list_empty(&pring->txq)))
>   			lpfc_drain_txq(phba);
>   		/*

