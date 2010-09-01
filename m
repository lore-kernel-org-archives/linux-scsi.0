From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 3/3] mpt2sas: Bump driver version 06.100.00.03
Date: Wed, 1 Sep 2010 15:39:38 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED704B0A367@inbmail01.lsi.com>
References: <20100804083746.GD13442@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:57252 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753789Ab0IAKJr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2010 06:09:47 -0400
In-Reply-To: <20100804083746.GD13442@lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

James,

Any update on my patch set submission?

Thanks,
Kashyap

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Kashyap, Desai
> Sent: Wednesday, August 04, 2010 2:08 PM
> To: linux-scsi@vger.kernel.org
> Cc: James.Bottomley@HansenPartnership.com; Moore, Eric; Prakash, Sathya
> Subject: [PATCH 3/3] mpt2sas: Bump driver version 06.100.00.03
> 
> Bump version to 06.100.00.03
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> ---
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h
> b/drivers/scsi/mpt2sas/mpt2sas_base.h
> index 3f390de..0b7e810 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.h
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
> @@ -69,11 +69,11 @@
>  #define MPT2SAS_DRIVER_NAME		"mpt2sas"
>  #define MPT2SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
>  #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
> -#define MPT2SAS_DRIVER_VERSION		"06.100.00.00"
> +#define MPT2SAS_DRIVER_VERSION		"06.100.00.03"
>  #define MPT2SAS_MAJOR_VERSION		06
>  #define MPT2SAS_MINOR_VERSION		100
>  #define MPT2SAS_BUILD_VERSION		00
> -#define MPT2SAS_RELEASE_VERSION		00
> +#define MPT2SAS_RELEASE_VERSION		03
> 
>  /*
>   * Set MPT2SAS_SG_DEPTH value based on user input.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
