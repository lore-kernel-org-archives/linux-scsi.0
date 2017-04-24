From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/1] aacraid: pci_alloc_consistent() failures on ARM64
Date: Mon, 24 Apr 2017 18:30:57 -0400
Message-ID: <yq1h91dh1zy.fsf@oracle.com>
References: <1491389056-15543-1-git-send-email-mahesh.rajashekhara@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19535 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S978884AbdDXWbH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 18:31:07 -0400
In-Reply-To: <1491389056-15543-1-git-send-email-mahesh.rajashekhara@microsemi.com>
        (Mahesh Rajashekhara's message of "Wed, 5 Apr 2017 16:14:16 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
Cc: Dave Carroll <david.carroll@microsemi.com>, linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>


> There were pci_alloc_consistent() failures on ARM64 platform.
> Use dma_alloc_coherent() with GFP_KERNEL flag DMA memory allocations.

Somebody please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
