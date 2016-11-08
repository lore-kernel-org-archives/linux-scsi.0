From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] aacraid: switch to pci_alloc_irq_vectors
Date: Tue, 8 Nov 2016 15:58:59 +0100
Message-ID: <20161108145859.GC12817@lst.de>
References: <1478589090-74217-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41896 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751296AbcKHO7A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Nov 2016 09:59:00 -0500
Content-Disposition: inline
In-Reply-To: <1478589090-74217-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Adaptec OEM Raid Solutions <aacraid@microsemi.com>

> @@ -1246,7 +1246,6 @@ struct aac_dev
>  	u32			max_msix;	/* max. MSI-X vectors */
>  	u32			vector_cap;	/* MSI-X vector capab.*/
>  	int			msi_enabled;	/* MSI/MSI-X enabled */
> -	struct msix_entry	msixentry[AAC_MAX_MSIX];
>  	struct aac_msix_ctx	aac_msix[AAC_MAX_MSIX]; /* context */

With a bit more work we should be able to get rid of the aac_msix
array as well.  I had actually started looking into that but got
dragged away.
