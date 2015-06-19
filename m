From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 09/20] [SCSI] mpt3sas: MPI 2.5 Rev J (2.5.5) specification and 2.00.34 header files
Date: Fri, 19 Jun 2015 16:27:39 -0400
Message-ID: <yq1egl7bg04.fsf@sermon.lab.mkp.net>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1434102153-38581-10-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36271 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbbFSU2L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2015 16:28:11 -0400
In-Reply-To: <1434102153-38581-10-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Fri, 12 Jun 2015 15:12:21 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org

>>>>> Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

> @@ -1334,9 +1336,17 @@ typedef struct _MPI2_CONFIG_PAGE_BIOS_1 {
>  	*PTR_MPI2_CONFIG_PAGE_BIOS_1,
>  	Mpi2BiosPage1_t, *pMpi2BiosPage1_t;
>  
> -#define MPI2_BIOSPAGE1_PAGEVERSION                      (0x05)
> +#define MPI2_BIOSPAGE1_PAGEVERSION                      (0x06)
>  
>  /*values for BIOS Page 1 BiosOptions field */
> +#define MPI2_BIOSPAGE1_OPTIONS_X86_DISABLE_BIOS		    (0x00000400)

Looks like you may have some bad whitespace here ^^^.

> +
> +#define MPI2_BIOSPAGE1_OPTIONS_MASK_REGISTRATION_UEFI_BSD	(0x00000300)
> +#define MPI2_BIOSPAGE1_OPTIONS_USE_BIT0_REGISTRATION_UEFI_BSD	(0x00000000)
> +#define MPI2_BIOSPAGE1_OPTIONS_FULL_REGISTRATION_UEFI_BSD	(0x00000100)
> +#define MPI2_BIOSPAGE1_OPTIONS_ADAPTER_REGISTRATION_UEFI_BSD	(0x00000200)
> +#define MPI2_BIOSPAGE1_OPTIONS_DISABLE_REGISTRATION_UEFI_BSD	(0x00000300)

Otherwise OK.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
