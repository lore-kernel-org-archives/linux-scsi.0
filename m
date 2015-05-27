From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 3/9] [SCSI] aacraid: Enable MSI interrupt for series-6
 controller
Date: Wed, 27 May 2015 16:42:05 +0200
Message-ID: <5565D7BD.1000706@redhat.com>
References: <1431562378-8514-1-git-send-email-rajinikanth.pandurangan@pmcs.com> <1431562378-8514-4-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbbE0OmI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 May 2015 10:42:08 -0400
In-Reply-To: <1431562378-8514-4-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rajinikanth.pandurangan@pmcs.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, harry.yang@pmcs.com, rich.bono@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com

On 05/14/2015 02:12 AM, rajinikanth.pandurangan@pmcs.com wrote:
> From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
> 
> Description:
> 	Enable MSI interrupt mode for series-6 controller.
> 
> Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
> ---
>  drivers/scsi/aacraid/src.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
> index b0204d0..ae494c5 100644
> --- a/drivers/scsi/aacraid/src.c
> +++ b/drivers/scsi/aacraid/src.c
> @@ -742,7 +742,7 @@ int aac_src_init(struct aac_dev *dev)
>  	if (dev->comm_interface != AAC_COMM_MESSAGE_TYPE1)
>  		goto error_iounmap;
>  
> -	dev->msi = aac_msi && !pci_enable_msi(dev->pdev);
> +	dev->msi = !pci_enable_msi(dev->pdev);
>  
>  	dev->aac_msix[0].vector_no = 0;
>  	dev->aac_msix[0].dev = dev;
> 
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Cheers,
Tomas

