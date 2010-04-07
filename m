From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 11/11] mpt2sas: Bump version 05.100.00.00
Date: Thu, 8 Apr 2010 01:42:08 +0530
Message-ID: <1C9608B8A4CD534FB19C7C7543CBB249020E3FDB8C@inbmail02.lsi.com>
References: <20100317105825.GL21264@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:59866 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750763Ab0DGUMY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Apr 2010 16:12:24 -0400
In-Reply-To: <20100317105825.GL21264@lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James,

Any feedback on mpt2sas patches?

Thanks,
Kashyap

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Kashyap, Desai
> Sent: Wednesday, March 17, 2010 4:29 PM
> To: linux-scsi@vger.kernel.org
> Cc: James.Bottomley@HansenPartnership.com; Moore, Eric; Prakash, Sathya
> Subject: [PATCH 11/11] mpt2sas: Bump version 05.100.00.00
> 
> Upgraded version string.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> ---
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h
> b/drivers/scsi/mpt2sas/mpt2sas_base.h
> index 9cf0104..454a74a 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.h
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
> @@ -69,11 +69,11 @@
>  #define MPT2SAS_DRIVER_NAME		"mpt2sas"
>  #define MPT2SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
>  #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
> -#define MPT2SAS_DRIVER_VERSION		"04.100.01.02"
> -#define MPT2SAS_MAJOR_VERSION		04
> +#define MPT2SAS_DRIVER_VERSION		"05.100.00.00"
> +#define MPT2SAS_MAJOR_VERSION		05
>  #define MPT2SAS_MINOR_VERSION		100
> -#define MPT2SAS_BUILD_VERSION		01
> -#define MPT2SAS_RELEASE_VERSION		02
> +#define MPT2SAS_BUILD_VERSION		00
> +#define MPT2SAS_RELEASE_VERSION		00
> 
>  /*
>   * Set MPT2SAS_SG_DEPTH value based on user input.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
