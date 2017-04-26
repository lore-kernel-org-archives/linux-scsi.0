From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/1] aacraid: pci_alloc_consistent() failures on ARM64
Date: Wed, 26 Apr 2017 18:28:58 -0400
Message-ID: <yq1inlqajmd.fsf@oracle.com>
References: <1491389056-15543-1-git-send-email-mahesh.rajashekhara@microsemi.com>
        <20170425070721.GA13214@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38040 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031539AbdDZW3b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Apr 2017 18:29:31 -0400
In-Reply-To: <20170425070721.GA13214@infradead.org> (Christoph Hellwig's
        message of "Tue, 25 Apr 2017 00:07:21 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, Dave Carroll <david.carroll@microsemi.com>, linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>


Christoph,

> The indentation is weird, and you're also adding memsets of the
> allocations which is a behavior change.  Please take a look at the the
> attached version that fixes this up.

Applied to 4.12/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
