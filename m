From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] qla2xxx: Add Block Multi Queue functionality.
Date: Fri, 4 Nov 2016 16:00:17 -0700
Message-ID: <20161104230017.GA19038@infradead.org>
References: <1478277213-3848-1-git-send-email-himanshu.madhani@cavium.com>
 <1478277213-3848-4-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39814 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754066AbcKDXAW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2016 19:00:22 -0400
Content-Disposition: inline
In-Reply-To: <1478277213-3848-4-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: himanshu.madhani@cavium.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, himanshu.madhani@qlogic.com

On Fri, Nov 04, 2016 at 09:33:32AM -0700, himanshu.madhani@cavium.com wrote:
> From: Michael Hernandez <michael.hernandez@cavium.com>
> 
> Tell the SCSI layer how many hardware queues we have based on the
> number of max queue pairs created. The number of max queue pairs
> created will depend on number of MSI X vector count or number of CPU's
> in a system.

Anf for that you must use pci_alloc_irq_vectors with the
PCI_IRQ_AFFINITY flag for all new code.  Please rework that code to use
that.
