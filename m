From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 10/10] mpt2sas: Bump version 04.100.01.00
Date: Thu, 28 Jan 2010 17:50:44 +0530
Message-ID: <1C9608B8A4CD534FB19C7C7543CBB24901290B9D08@inbmail02.lsi.com>
References: <20091216132654.GK31161@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:47772 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752146Ab0A1MUz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jan 2010 07:20:55 -0500
In-Reply-To: <20091216132654.GK31161@lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

James,

Any remarks for this patch set?

Thanks,
Kashyap

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Kashyap, Desai
> Sent: Wednesday, December 16, 2009 6:57 PM
> To: linux-scsi@vger.kernel.org
> Cc: James.Bottomley@HansenPartnership.com; Moore, Eric; Prakash, Sathya
> Subject: [PATCH 10/10] mpt2sas: Bump version 04.100.01.00
> 
> 
> Version upgraded to 04.100.01.00.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> Reviewed-by: Eric Moore <eric.moore@lsi.com>
> ---
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h
> b/drivers/scsi/mpt2sas/mpt2sas_base.h
> index 67b831e..b0c8c05 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.h
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
> @@ -69,10 +69,10 @@
>  #define MPT2SAS_DRIVER_NAME		"mpt2sas"
>  #define MPT2SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
>  #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
> -#define MPT2SAS_DRIVER_VERSION		"03.100.03.00"
> -#define MPT2SAS_MAJOR_VERSION		03
> +#define MPT2SAS_DRIVER_VERSION		"04.100.01.00"
> +#define MPT2SAS_MAJOR_VERSION		04
>  #define MPT2SAS_MINOR_VERSION		100
> -#define MPT2SAS_BUILD_VERSION		03
> +#define MPT2SAS_BUILD_VERSION		01
>  #define MPT2SAS_RELEASE_VERSION		00
> 
>  /*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
