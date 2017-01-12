From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] vmw_pvscsi: switch to pci_alloc_irq_vectors
Date: Wed, 11 Jan 2017 22:31:32 -0500
Message-ID: <yq1y3yhnecr.fsf@oracle.com>
References: <1479448958-6653-1-git-send-email-hch@lst.de>
        <yq17f7mp7gc.fsf@sermon.lab.mkp.net>
        <20170108150751.GA10308@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50779 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750819AbdALDcR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2017 22:32:17 -0500
In-Reply-To: <20170108150751.GA10308@infradead.org> (Christoph Hellwig's
        message of "Sun, 8 Jan 2017 07:07:51 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jgill@vmware.com, Christoph Hellwig <hch@lst.de>, pv-drivers@vmware.com, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> And simply the interrupt handler by splitting the INTx case
Christoph> that needs to deal with shared interrupts into a separate
Christoph> helper.

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
