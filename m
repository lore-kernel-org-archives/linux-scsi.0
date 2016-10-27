From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 05/11] mpt3sas: Bump driver version as "14.100.00.00"
Date: Thu, 27 Oct 2016 10:55:17 +0200
Message-ID: <040b99f4-d2f2-39a2-b257-2a7fcb1e4118@suse.de>
References: <1477469082-32395-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1477469082-32395-6-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477469082-32395-6-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On 10/26/2016 10:04 AM, Suganath Prabu S wrote:
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
> index e923c91..6f03a86 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -73,8 +73,8 @@
>  #define MPT3SAS_DRIVER_NAME		"mpt3sas"
>  #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
>  #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
> -#define MPT3SAS_DRIVER_VERSION		"13.100.00.00"
> -#define MPT3SAS_MAJOR_VERSION		13
> +#define MPT3SAS_DRIVER_VERSION		"14.100.00.00"
> +#define MPT3SAS_MAJOR_VERSION		14
>  #define MPT3SAS_MINOR_VERSION		100
>  #define MPT3SAS_BUILD_VERSION		0
>  #define MPT3SAS_RELEASE_VERSION	00
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
