From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V5 03/11] [SCSI] aacraid: Change interrupt mode to MSI for
 series-6 controller
Date: Thu, 23 Jul 2015 16:38:39 +0200
Message-ID: <55B0FC6F.2020506@redhat.com>
References: <1437583757-5449-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <1437583757-5449-4-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbbGWOim (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jul 2015 10:38:42 -0400
In-Reply-To: <1437583757-5449-4-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rajinikanth.pandurangan@pmcs.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, harry.yang@pmcs.com, rich.bono@pmcs.com, mahesh.rajashekhara@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com

On 22.7.2015 18:49, rajinikanth.pandurangan@pmcs.com wrote:
> From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
> 
> Description:
>         This change always sets MSI interrupt mode for series-6 controller.
> Note: For series 6 family, MSIx is not supported.
> 
> Changes from V2:
> Only Subject & description change.
> 
> Reviewed by:
>  Tomas Henzl <thenzl@redhat.com>,
I haven't noticed this before, but in V2 I haven't reviewed
this patch, I have asked you for a change which hasn't
been followed.
Please remove my 'Reviewed by' tag.
-tm


>  Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>,
>  Johannes Thumshirn <jthumshirn@suse.de>
> 
> Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
> ---
>  drivers/scsi/aacraid/src.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
> index b147341..eb07b3d 100644
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

