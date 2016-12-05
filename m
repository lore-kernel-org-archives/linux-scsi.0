From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 3/6] qla2xxx: Utilize
 pci_alloc_irq_vectors/pci_free_irq_vectors calls.
Date: Mon, 5 Dec 2016 08:09:11 -0800
Message-ID: <20161205160911.GC11206@infradead.org>
References: <1480715097-13611-1-git-send-email-himanshu.madhani@cavium.com>
 <1480715097-13611-4-git-send-email-himanshu.madhani@cavium.com>
 <91f64303-4677-7740-4c3e-7a0c71f7faca@suse.de>
 <20161205125430.GA23221@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45361 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbcLEQJO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 11:09:14 -0500
Content-Disposition: inline
In-Reply-To: <20161205125430.GA23221@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Himanshu Madhani <himanshu.madhani@cavium.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

On Mon, Dec 05, 2016 at 04:54:30AM -0800, Christoph Hellwig wrote:
> It shouldn't be required in the end, but keeping the switch to the

s/shouldn't/should/

> new IRQ helpers from the change to the affinity assignment separate
> makes sense.

But I can't see the switch anywhere else in the series, so yes,
it should be added somewhere.  And the horrible affinity notifications
for the target code need to go away as well.
