From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] qla4xxx: switch to pci_alloc_irq_vectors
Date: Wed, 07 Dec 2016 18:59:31 -0500
Message-ID: <yq1twafqoik.fsf@sermon.lab.mkp.net>
References: <1481032610-31274-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36227 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933751AbcLGX7k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2016 18:59:40 -0500
In-Reply-To: <1481032610-31274-1-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Tue, 6 Dec 2016 14:56:50 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Nilesh.Javali@cavium.com, QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> And simplify the MSI-X logic in general - just request the
Christoph> two vectors directly instead of going through an indirection
Christoph> table.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
