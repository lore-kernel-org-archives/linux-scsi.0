From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 5/5] BNX2I - minor code cleanup and update driver version
Date: Wed, 09 Dec 2009 20:46:16 -0600
Message-ID: <4B2060F8.3090904@cs.wisc.edu>
References: <1260214839.31468.100.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57309 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210AbZLJCqU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Dec 2009 21:46:20 -0500
In-Reply-To: <1260214839.31468.100.camel@anilgv-desktop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, mchan@broadcom.com, poswald@novell.com

Anil Veerabhadrappa wrote:
>     * Removed duplicate function call and not-so-useful comment line
> 
> Signed-off-by: Anil Veerabhadrappa <anilgv@broadcom.com>
> ---
>  drivers/scsi/bnx2i/bnx2i_init.c  |    4 ++--
>  drivers/scsi/bnx2i/bnx2i_iscsi.c |    2 --
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
> index ad551c5..1e111ac 100644
> --- a/drivers/scsi/bnx2i/bnx2i_init.c
> +++ b/drivers/scsi/bnx2i/bnx2i_init.c
> @@ -17,8 +17,8 @@ static struct list_head adapter_list = LIST_HEAD_INIT(adapter_list);
>  static u32 adapter_count;
>  
>  #define DRV_MODULE_NAME		"bnx2i"
> -#define DRV_MODULE_VERSION	"2.0.1e"
> -#define DRV_MODULE_RELDATE	"June 22, 2009"
> +#define DRV_MODULE_VERSION	"2.1.0"
> +#define DRV_MODULE_RELDATE	"Dec 06, 2009"
>  
>  static char version[] __devinitdata =
>  		"Broadcom NetXtreme II iSCSI Driver " DRV_MODULE_NAME \
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> index 070118a..54dc251 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -485,7 +485,6 @@ static int bnx2i_setup_cmd_pool(struct bnx2i_hba *hba,
>  		struct iscsi_task *task = session->cmds[i];
>  		struct bnx2i_cmd *cmd = task->dd_data;
>  
> -		/* Anil */
>  		task->hdr = &cmd->hdr;
>  		task->hdr_max = sizeof(struct iscsi_hdr);
>  
> @@ -765,7 +764,6 @@ struct bnx2i_hba *bnx2i_alloc_hba(struct cnic_dev *cnic)
>  	hba->pci_svid = hba->pcidev->subsystem_vendor;
>  	hba->pci_func = PCI_FUNC(hba->pcidev->devfn);
>  	hba->pci_devno = PCI_SLOT(hba->pcidev->devfn);
> -	bnx2i_identify_device(hba);
>  
>  	bnx2i_identify_device(hba);
>  	bnx2i_setup_host_queue_size(hba, shost);

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

