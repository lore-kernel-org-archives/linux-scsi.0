From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: [patch 10/11] drivers/scsi/: Use the DMA_{64,32}BIT_MASK constants
Date: 07 Mar 2005 05:14:16 -0500
Message-ID: <yq0ekerepaf.fsf@jaguar.mkp.net>
References: <20050306222721.1E3391F208@trashy.coderock.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from [192.139.46.150] ([192.139.46.150]:21945 "EHLO jaguar.mkp.net")
	by vger.kernel.org with ESMTP id S261733AbVCGKOh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2005 05:14:37 -0500
In-Reply-To: <20050306222721.1E3391F208@trashy.coderock.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: domen@coderock.org
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, tklauser@nuerscht.ch

>>>>> "domen" == domen  <domen@coderock.org> writes:

domen> Use the DMA_{64,32}BIT_MASK constants from dma-mapping.h when
domen> calling pci_set_dma_mask() or pci_set_consistent_dma_mask() See
domen> http://marc.theaimsgroup.com/?t=108001993000001&r=1&w=2 for
domen> details

Why?

It's ugly and really serves no purpose except for obfuscation.

Rejected for qla1280

Jes
