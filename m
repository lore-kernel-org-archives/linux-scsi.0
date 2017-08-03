From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 13/13] mpt3sas: Update mpt3sas driver version.
Date: Thu, 3 Aug 2017 08:45:01 +0200
Message-ID: <9d885102-815d-b68c-52df-a408af927d91@suse.de>
References: <1500038560-11231-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1500038560-11231-14-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1500038560-11231-14-git-send-email-suganath-prabu.subramani@broadcom.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On 07/14/2017 03:22 PM, Suganath Prabu S wrote:
> Updated mpt3sas driver version to 15.101.00.00
> 
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
> index b7855c8..b705199 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -74,9 +74,9 @@
>  #define MPT3SAS_DRIVER_NAME		"mpt3sas"
>  #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
>  #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
> -#define MPT3SAS_DRIVER_VERSION		"15.100.00.00"
> +#define MPT3SAS_DRIVER_VERSION		"15.101.00.00"
>  #define MPT3SAS_MAJOR_VERSION		15
> -#define MPT3SAS_MINOR_VERSION		100
> +#define MPT3SAS_MINOR_VERSION		101
>  #define MPT3SAS_BUILD_VERSION		0
>  #define MPT3SAS_RELEASE_VERSION	00
>  
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
