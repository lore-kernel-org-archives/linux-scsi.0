From: "Ju, Seokmann" <sju@lsil.com>
Subject: RE: [PATCH 15/19] drivers/scsi/megaraid: Use the DMA_{64,32}BIT_M
	ASK constants
Date: Tue, 22 Feb 2005 08:46:49 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57036626CE@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Received: from mail0.lsil.com ([147.145.40.20]:28577 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262311AbVBVNrE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Feb 2005 08:47:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Tobias Klauser' <tklauser@nuerscht.ch>, kernel-janitors@lists.osdl.org
Cc: linux-scsi@vger.kernel.org, "Ju, Seokmann" <sju@lsil.com>

On Sunday, February 20, 2005 12:10 PM, Tobias wrote:
> Hello,
> 
> Description: Use the DMA_{64,32}BIT_MASK constants from dma-mapping.h
> when calling pci_set_dma_mask() or pci_set_consistent_dma_mask()
> See http://marc.theaimsgroup.com/?t=108001993000001&r=1&w=2 for details

Thanks for your input.

Next release driver will have this change included.

Thanks again.

Seokmann
LSI Logic Corporation.

