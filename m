From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 04/19] drivers/scsi/ahci: Use the DMA_{64,32}BIT_MASK constants
Date: Sun, 20 Feb 2005 12:39:16 -0500
Message-ID: <20050220173916.GB5495@havoc.gtf.org>
References: <20050220165530.GD14375@helium.tklauser.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from atlmail.prod.rxgsys.com ([64.74.124.160]:54921 "EHLO
	bastet.signetmail.com") by vger.kernel.org with ESMTP
	id S261495AbVBTRjZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Feb 2005 12:39:25 -0500
Content-Disposition: inline
In-Reply-To: <20050220165530.GD14375@helium.tklauser.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tobias Klauser <tklauser@nuerscht.ch>
Cc: kernel-janitors@lists.osdl.org, linux-scsi@vger.kernel.org

On Sun, Feb 20, 2005 at 05:55:30PM +0100, Tobias Klauser wrote:
> Hello,
> 
> Description: Use the DMA_{64,32}BIT_MASK constants from dma-mapping.h
> when calling pci_set_dma_mask() or pci_set_consistent_dma_mask()
> See http://marc.theaimsgroup.com/?t=108001993000001&r=1&w=2 for details

Please CC libata patches to (1) the person that maintains libata [me]
and (2) linux-ide@vger.kernel.org.

	Jeff



