From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND PATCH 1/2] scsi: bnx2fc: Use zeroing allocator rather than allocator/memset
Date: Wed, 10 Jan 2018 16:35:41 -0500
Message-ID: <yq1373dwg5u.fsf@oracle.com>
References: <1515488812-22664-1-git-send-email-himanshujha199640@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47942 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751366AbeAJVfy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jan 2018 16:35:54 -0500
In-Reply-To: <1515488812-22664-1-git-send-email-himanshujha199640@gmail.com>
        (Himanshu Jha's message of "Tue, 9 Jan 2018 14:36:51 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Jha <himanshujha199640@gmail.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com, chad.dupuis@cavium.com, Manish.Rangankar@cavium.com


Himanshu,

> Use dma_zalloc_coherent instead of dma_alloc_coherent followed by
> memset 0.

Applied to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
