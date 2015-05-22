From: Rajinikanth Pandurangan <Rajinikanth.Pandurangan@pmcs.com>
Subject: RE: [PATCH 3/9] [SCSI] aacraid: Enable MSI interrupt for series-6
 controller
Date: Fri, 22 May 2015 23:46:37 +0000
Message-ID: <E34C6B6293F0214497D0C55B92526C05B697A023@BBYEXM01.pmc-sierra.internal>
References: <1431562378-8514-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <1431562378-8514-4-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <555F31B0.3090103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:47076 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757136AbbEVXqj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 May 2015 19:46:39 -0400
In-Reply-To: <555F31B0.3090103@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>, Achim Leubner <Achim.Leubner@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>

Hello Tomas,

As the function aac_src_init() itself specific to Series-6 controller, change applicable only to series-6.

Thanks,
-Raj P.

-----Original Message-----
From: Tomas Henzl [mailto:thenzl@redhat.com] 
Sent: Friday, May 22, 2015 6:40 AM
To: Rajinikanth Pandurangan; jbottomley@parallels.com; linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com; Harry Yang; Rich Bono; Achim Leubner; Murthy Bhat
Subject: Re: [PATCH 3/9] [SCSI] aacraid: Enable MSI interrupt for series-6 controller

On 05/14/2015 02:12 AM, rajinikanth.pandurangan@pmcs.com wrote:
> From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
> 
> Description:
> 	Enable MSI interrupt mode for series-6 controller.
aac_msi is a driver option, how is it related to series-6 controller?
Tomas
> 
> Signed-off-by: Rajinikanth Pandurangan 
> <rajinikanth.pandurangan@pmcs.com>
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

