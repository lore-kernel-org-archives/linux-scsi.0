From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] be2iscsi: switch to pci_alloc_irq_vectors
Date: Fri, 20 Jan 2017 19:26:24 -0500
Message-ID: <yq1lgu5gswf.fsf@oracle.com>
References: <1484324988-30962-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41454 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752229AbdAUA0d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jan 2017 19:26:33 -0500
In-Reply-To: <1484324988-30962-1-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Fri, 13 Jan 2017 17:29:48 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> And get automatic MSI-X affinity for free.

Jitendra?

-- 
Martin K. Petersen	Oracle Linux Engineering
