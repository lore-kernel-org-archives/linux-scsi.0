From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/10] mpt3sas: Removing unused macro "MPT_DEVICE_TLR_ON"
Date: Mon, 24 Oct 2016 16:47:49 +0200
Message-ID: <e2606c21-cb01-11c4-c4f7-a8192797e245@suse.de>
References: <1476966018-10457-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1476966018-10457-5-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476966018-10457-5-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On 10/20/2016 02:20 PM, Suganath Prabu S wrote:
> Removing macro "MPT_DEVICE_TLR_ON" defined in header file as its unused
>
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.h | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
> index 4221a4d..e923c91 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -375,7 +375,6 @@ struct MPT3SAS_TARGET {
>   * per device private data
>   */
>  #define MPT_DEVICE_FLAGS_INIT		0x01
> -#define MPT_DEVICE_TLR_ON		0x02
>
>  #define MFG_PAGE10_HIDE_SSDS_MASK	(0x00000003)
>  #define MFG_PAGE10_HIDE_ALL_DISKS	(0x00)
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
