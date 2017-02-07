From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] fnic: switch to pci_alloc_irq_vectors
Date: Mon, 06 Feb 2017 19:16:04 -0500
Message-ID: <yq14m06ua7v.fsf@oracle.com>
References: <1485957773-12133-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38152 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751694AbdBGAQM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 19:16:12 -0500
In-Reply-To: <1485957773-12133-1-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Wed, 1 Feb 2017 15:02:53 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Not a full cleanup for the IRQ code, for that we'd need to
Christoph> know if the max number of the various CQ types is going to
Christoph> stay 1 forever.

Satish: Please test and review!

-- 
Martin K. Petersen	Oracle Linux Engineering
