From: Bradley Grove <bgrove@attotech.com>
Subject: Re: [PATCH 16/29] scsi: esas2r: constify pci_device_id.
Date: Thu, 10 Aug 2017 14:59:22 -0400
Message-ID: <46cd43a7-a246-ac67-ef54-97b19571908e@attotech.com>
References: <1501404036-9005-1-git-send-email-arvind.yadav.cs@gmail.com>
 <1501404036-9005-6-git-send-email-arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501404036-9005-6-git-send-email-arvind.yadav.cs@gmail.com>
Content-Language: en-MW
Sender: linux-kernel-owner@vger.kernel.org
To: Arvind Yadav <arvind.yadav.cs@gmail.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, mdr@sgi.com, hare@suse.com, aacraid@adaptec.com, matthew@wil.cx, fthain@telegraphics.com.au, schmitzmic@gmail.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, gotom@debian.or.jp, mrochs@linux.vnet.ibm.com, QLogic-Storage-Upstream@cavium.com, jinpu.wang@profitbricks.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



Looks good.

Acked-by: Bradley Grove <bgrove@attotech.com>


On 07/30/2017 04:40 AM, Arvind Yadav wrote:
> pci_device_id are not supposed to change at runtime. All functions
> working with pci_device_id provided by <linux/pci.h> work with
> const pci_device_id. So mark the non-const structs as const.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
> ---
>   drivers/scsi/esas2r/esas2r_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
> index f2e9d8a..81f226b 100644
> --- a/drivers/scsi/esas2r/esas2r_main.c
> +++ b/drivers/scsi/esas2r/esas2r_main.c
> @@ -309,7 +309,7 @@ MODULE_PARM_DESC(interrupt_mode,
>   		 "Defines the interrupt mode to use.  0 for legacy"
>   		 ", 1 for MSI.  Default is MSI (1).");
>   
> -static struct pci_device_id
> +static const struct pci_device_id
>   	esas2r_pci_table[] = {
>   	{ ATTO_VENDOR_ID, 0x0049,	  ATTO_VENDOR_ID, 0x0049,
>   	  0,
> 




This electronic transmission and any attachments hereto are intended only for the use of the individual or entity to which it is addressed and may contain confidential information belonging to ATTO Technology, Inc. If you have reason to believe that you are not the intended recipient, you are hereby notified that any disclosure, copying, distribution or the taking of any action in reliance on the contents of this electronic transmission is strictly prohibited. If you have reason to believe that you have received this transmission in error, please notify ATTO immediately by return e-mail and delete and destroy this communication.   
