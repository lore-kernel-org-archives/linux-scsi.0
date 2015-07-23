From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V5 11/11] [SCSI] aacraid: Requests at least 2 MSIx in
 pci_enable_msix_range()
Date: Thu, 23 Jul 2015 14:55:05 +0200
Message-ID: <55B0E429.2090805@redhat.com>
References: <1437583757-5449-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <1437583757-5449-12-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176AbbGWMzI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jul 2015 08:55:08 -0400
In-Reply-To: <1437583757-5449-12-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rajinikanth.pandurangan@pmcs.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, harry.yang@pmcs.com, rich.bono@pmcs.com, mahesh.rajashekhara@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com

On 22.7.2015 18:49, rajinikanth.pandurangan@pmcs.com wrote:
> From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
> 
> Description:
>         In MSIx mode, we need at least 2 vectors.
> 
> Changes from V4:
> 	Newly created for V5 based on review comment.
> 
> Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

> ---
>  drivers/scsi/aacraid/comminit.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
> index a02cfb3..0e954e3 100644
> --- a/drivers/scsi/aacraid/comminit.c
> +++ b/drivers/scsi/aacraid/comminit.c
> @@ -366,7 +366,7 @@ void aac_define_int_mode(struct aac_dev *dev)
>  
>  	if (msi_count > 1 &&
>  	    pci_find_capability(dev->pdev, PCI_CAP_ID_MSIX)) {
> -		min_msix = 1;
> +		min_msix = 2;
>  		i = pci_enable_msix_range(dev->pdev,
>  				    dev->msixentry,
>  				    min_msix,
> 

