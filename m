From: "Ju, Seokmann" <sju@lsil.com>
Subject: RE: [patch 10/11] drivers/scsi/: Use the DMA_{64,32}BIT_MASK cons
	tants
Date: Mon, 7 Mar 2005 13:57:00 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703662728@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Received: from mail0.lsil.com ([147.145.40.20]:44694 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261226AbVCGS5U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2005 13:57:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'domen@coderock.org'" <domen@coderock.org>, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, tklauser@nuerscht.ch

On Sunday, March 06, 2005 5:27 PM, Domen wrote
> Use the DMA_{64,32}BIT_MASK constants from dma-mapping.h
> when calling pci_set_dma_mask() or pci_set_consistent_dma_mask()
Megaraid driver has this change and patch for this will be submitted as
committed.

Thanks,

Seokmann
LSI Logic Corporation
