From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] vmw_pvscsi: switch to pci_alloc_irq_vectors
Date: Tue, 29 Nov 2016 11:38:27 -0500
Message-ID: <yq17f7mp7gc.fsf@sermon.lab.mkp.net>
References: <1479448958-6653-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49843 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751774AbcK2Qie (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Nov 2016 11:38:34 -0500
In-Reply-To: <1479448958-6653-1-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Fri, 18 Nov 2016 07:02:38 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgill@vmware.com
Cc: Christoph Hellwig <hch@lst.de>, pv-drivers@vmware.com, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> And simply the interrupt handler by splitting the INTx case
Christoph> that needs to deal with shared interrupts into a separate
Christoph> helper.

Jim: Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
