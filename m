From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] lpfc: fix printk format warning
Date: Tue, 24 Oct 2006 07:46:28 -0400
Message-ID: <453DFD14.5060500@emulex.com>
References: <20061023214713.cfff635b.randy.dunlap@oracle.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:16005 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030388AbWJXLqv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Oct 2006 07:46:51 -0400
In-Reply-To: <20061023214713.cfff635b.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: scsi <linux-scsi@vger.kernel.org>, jejb <james.bottomley@steeleye.com>, akpm <akpm@osdl.org>

ack...

-- james s

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix printk format warning:
> drivers/scsi/lpfc/lpfc_attr.c:597: warning: long long unsigned int format, uint64_t arg (arg 4)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
> 
>  drivers/scsi/lpfc/lpfc_attr.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletion(-)
> 
> --- linux-2619-rc3-pv.orig/drivers/scsi/lpfc/lpfc_attr.c
> +++ linux-2619-rc3-pv/drivers/scsi/lpfc/lpfc_attr.c
> @@ -594,7 +594,8 @@ lpfc_soft_wwpn_show(struct class_device 
>  {
>  	struct Scsi_Host *host = class_to_shost(cdev);
>  	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
> -	return snprintf(buf, PAGE_SIZE, "0x%llx\n", phba->cfg_soft_wwpn);
> +	return snprintf(buf, PAGE_SIZE, "0x%llx\n",
> +			(unsigned long long)phba->cfg_soft_wwpn);
>  }
>  
>  
> 
> 
> ---
> 
