From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] hpsa: use pci_alloc_irq_vectors and automatic irq affinity
Date: Sat, 12 Nov 2016 10:14:40 -0500
Message-ID: <yq1mvh4k9wf.fsf@sermon.lab.mkp.net>
References: <1478716942-6335-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42411 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752223AbcKLPOz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Nov 2016 10:14:55 -0500
In-Reply-To: <1478716942-6335-1-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Wed, 9 Nov 2016 10:42:22 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: don.brace@microsemi.com, hare@suse.de, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> This patch converts over hpsa to use the
Christoph> pci_alloc_irq_vectors including the PCI_IRQ_AFFINITY flag
Christoph> that automatically assigns spread out irq affinity to the I/O
Christoph> queues.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
