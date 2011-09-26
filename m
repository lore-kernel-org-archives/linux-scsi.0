From: "Jack Wang" <jack_wang@usish.com>
Subject: Re: [PATCH] libsas: fix warnings when checking sata/stp protocol
Date: Mon, 26 Sep 2011 08:48:26 +0800
Message-ID: <BC3378113C6840C28E9ACA1767507ED2@usish.com.cn>
References: <20110924010830.5292.26480.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:35042 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab1IZAsF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Sep 2011 20:48:05 -0400
In-Reply-To: <20110924010830.5292.26480.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Williams' <dan.j.williams@intel.com>, linux-scsi@vger.kernel.org
Cc: 'Xiangliang Yu' <yuxiangl@marvell.com>

It's OK for me.

[PATCH] libsas: fix warnings when checking sata/stp protocol
> 
> Several sas drivers legitimately check the protocol against the union of
> SAS_PROTOCOL_SATA and SAS_PROTOCOL_STP.  Provide a SAS_PROTOCOL_STP_ALL
> to silence warnings like:
> 
> drivers/scsi/pm8001/pm8001_sas.c:438:3: warning: case value '5' not in
> enumerated type 'enum sas_protocol' [-Wswitch]
> drivers/scsi/mvsas/mv_sas.c:798:2: warning: case value '5' not in
enumerated
> type 'enum sas_protocol' [-Wswitch]
> drivers/scsi/mvsas/mv_sas.c:1783:2: warning: case value '5' not in
enumerated
> type 'enum sas_protocol' [-Wswitch]
> drivers/scsi/mvsas/mv_sas.c:1886:2: warning: case value '5' not in
enumerated
> type 'enum sas_protocol' [-Wswitch]
> drivers/scsi/isci/request.c:3565:2: warning: case value '5' not in
enumerated
> type 'enum sas_protocol' [-Wswitch]
> 
> Cc: Xiangliang Yu <yuxiangl@marvell.com>
> Cc: Jack Wang <jack_wang@usish.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  include/scsi/sas.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/scsi/sas.h b/include/scsi/sas.h
> index 9038d40..3a00297 100644
> --- a/include/scsi/sas.h
> +++ b/include/scsi/sas.h
> @@ -108,6 +108,7 @@ enum sas_protocol {
>  	SAS_PROTOCOL_STP		= 0x04,
>  	SAS_PROTOCOL_SSP		= 0x08,
>  	SAS_PROTOCOL_ALL		= 0x0E,
> +	SAS_PROTOCOL_STP_ALL		=
SAS_PROTOCOL_STP|SAS_PROTOCOL_SATA,
>  };
> 
>  /* From the spec; local phys only */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

