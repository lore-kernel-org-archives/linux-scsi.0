From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: PATCH: atp870u DMA mask
Date: Fri, 11 Mar 2005 14:46:37 +0000
Message-ID: <1110552396.17740.63.camel@localhost.localdomain>
References: <1110550674.15927.61.camel@localhost.localdomain>
	 <1110552058.9917.18.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from clock-tower.bc.nu ([81.2.110.250]:15256 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP id S263345AbVCKOs1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2005 09:48:27 -0500
In-Reply-To: <1110552058.9917.18.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Gwe, 2005-03-11 at 14:40, Arjan van de Ven wrote:
> > -        if (!pci_set_dma_mask(pdev, 0xFFFFFFUL)) {
> > +        if (!pci_set_dma_mask(pdev, 0xFFFFFFFFUL)) {
> isn't it still an F short?
> And... why not use the DMA_32_BIT or whatever define.. it's there for
> exactly this reason :)

No its 32bit not 36bit DMA capable. As to DMA_32_BIT - I didn't know
about it, I'll go take a look for some examples.

