From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: libcxgbi: add check for valid cxgbi_task_data
Date: Mon, 24 Jul 2017 22:16:39 -0400
Message-ID: <yq1inih1cs8.fsf@oracle.com>
References: <1500820292-21893-1-git-send-email-varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41081 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755392AbdGYCQq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2017 22:16:46 -0400
In-Reply-To: <1500820292-21893-1-git-send-email-varun@chelsio.com> (Varun
        Prakash's message of "Sun, 23 Jul 2017 20:01:32 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, indranil@chelsio.com


Varun,

> In error case it is possible that ->cleanup_task() gets called without
> calling ->alloc_pdu() in this case cxgbi_task_data is not valid, so
> add a check for for valid cxgbi_task_data in cxgbi_cleanup_task().

Applied to 4.13/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
