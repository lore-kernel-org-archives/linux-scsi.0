From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: PATCH: atp870u DMA mask
Date: Fri, 11 Mar 2005 15:40:57 +0100
Message-ID: <1110552058.9917.18.camel@laptopd505.fenrus.org>
References: <1110550674.15927.61.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from pentafluge.infradead.org ([213.146.154.40]:44747 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S263337AbVCKOlE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2005 09:41:04 -0500
In-Reply-To: <1110550674.15927.61.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org

On Fri, 2005-03-11 at 14:17 +0000, Alan Cox wrote:
> Noted by James Bottomley
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> --- drivers/scsi/atp870u.c.old	2005-03-11 14:14:53.015465656 +0000
> +++ drivers/scsi/atp870u.c	2005-03-11 14:15:24.950610776 +0000
> @@ -2634,7 +2634,7 @@
>  	if (pci_enable_device(pdev))
>  		return -EIO;
>  
> -        if (!pci_set_dma_mask(pdev, 0xFFFFFFUL)) {
> +        if (!pci_set_dma_mask(pdev, 0xFFFFFFFFUL)) {
isn't it still an F short?
And... why not use the DMA_32_BIT or whatever define.. it's there for
exactly this reason :)

