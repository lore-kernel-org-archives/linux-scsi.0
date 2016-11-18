From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] aacraid: switch to pci_alloc_irq_vectors
Date: Thu, 17 Nov 2016 20:30:25 -0500
Message-ID: <yq1vavl7exa.fsf@sermon.lab.mkp.net>
References: <1478589090-74217-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29638 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751471AbcKRBam (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2016 20:30:42 -0500
In-Reply-To: <1478589090-74217-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Tue, 8 Nov 2016 08:11:30 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Adaptec OEM Raid Solutions <aacraid@microsemi.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Use pci_alloc_irq_vectors and drop the hand-crafted interrupt
Hannes> affinity routines.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
