From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/5] megaraid_sas: switch to pci_alloc_irq_vectors
Date: Mon, 14 Nov 2016 13:33:04 +0100
Message-ID: <20161114123304.GB14653@lst.de>
References: <1478857492-4581-1-git-send-email-hare@suse.de> <1478857492-4581-2-git-send-email-hare@suse.de> <7d5dca7d9f030cb76de03d90a8b02340@mail.gmail.com> <30690328-e04f-7f41-d2d0-6d05c41b3290@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48826 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932258AbcKNMdG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Nov 2016 07:33:06 -0500
Content-Disposition: inline
In-Reply-To: <30690328-e04f-7f41-d2d0-6d05c41b3290@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Fri, Nov 11, 2016 at 03:59:05PM +0100, Hannes Reinecke wrote:
> You are right; irq affinity only makes sense for MSI-X.
> I'll be fixing it up.

It works for multi-MSI and MSI-X.  And even for single-MSI or
INTx it's harmless as it will be ignored if only a single
vector is present.
