From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] csiostor: switch to pci_alloc_irq_vectors
Date: Fri, 20 Jan 2017 19:27:02 -0500
Message-ID: <yq1h94tgsvd.fsf@oracle.com>
References: <1484325046-31032-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41585 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752229AbdAUA1K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jan 2017 19:27:10 -0500
In-Reply-To: <1484325046-31032-1-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Fri, 13 Jan 2017 17:30:46 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, hariprasad@chelsio.com, praveenm@chelsio.com

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> And get automatic MSI-X affinity for free.

Chelsio folks: Please review and test!

-- 
Martin K. Petersen	Oracle Linux Engineering
