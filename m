From: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Subject: RE: [ANNOUNCE][PATCH 2.6.11 2/3] megaraid_sas: Announcing new mod
	 ule  for LSI Logic's SAS based MegaRAID controllers
Date: Wed, 9 Mar 2005 17:47:27 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570230CC22@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Received: from mail0.lsil.com ([147.145.40.20]:6602 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262410AbVCIWsC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2005 17:48:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: 'Arjan van de Ven' <arjan@infradead.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "'Matt_Domsch@Dell.com'" <Matt_Domsch@Dell.com>, Andrew Morton <akpm@osdl.org>

>
>Even for kernels with a 64bit dma_addr_t you can get 32bit dma 
>addresses
>only.  As a start check whether the pci_set_dma_mask for the 64bit mask
>failed - in that case you can always use 32bit SGLs.
>

Please help me understand: If dma_addr_t is 64 bit, I will get 64bit 
addresses in scatterlist regardless the outcome of pci_set_dma_mask, 
won't I? These addresses may have valid or null high addresses. My idea
was to have 32(64) bit SGLs for 32(64) bit dma_addr_t.

Thanks,
Sreenivas
