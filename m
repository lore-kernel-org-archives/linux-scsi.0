From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bnx2fc: Fix check in SCSI completion handler when reqeust has already timed out.
Date: Tue, 30 Jan 2018 21:26:42 -0500
Message-ID: <yq1o9lag3vh.fsf@oracle.com>
References: <20180124160706.32700-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:42092 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752254AbeAaC0u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jan 2018 21:26:50 -0500
In-Reply-To: <20180124160706.32700-1-chad.dupuis@cavium.com> (Chad Dupuis's
        message of "Wed, 24 Jan 2018 08:07:06 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@cavium.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com


Chad,

> When a request times out we set the io_req flag BNX2FC_FLAG_IO_COMPL so
> that if a subsequent completion comes in on that task ID we will ignore
> it.  The issue is that in the check for this flag there is a missing
> return so we will continue to process a request which may have already
> been returned to the ownership of the SCSI layer.  This can cause
> unpredictable results.

Applied to 4.16/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
