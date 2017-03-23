From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/6] ipr: Fix missed EH wakeup
Date: Thu, 23 Mar 2017 12:04:29 -0400
Message-ID: <yq160j0dlo2.fsf@oracle.com>
References: <20170315215837.5146A13603C@b03ledav002.gho.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40026 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751404AbdCWQEi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Mar 2017 12:04:38 -0400
In-Reply-To: <20170315215837.5146A13603C@b03ledav002.gho.boulder.ibm.com>
        (Brian King's message of "Wed, 15 Mar 2017 16:58:36 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com

Brian King <brking@linux.vnet.ibm.com> writes:

> Following a command abort or device reset, ipr's EH handlers wait
> for the commands getting aborted to get sent back from the adapter
> prior to returning from the EH handler. This fixes up some cases
> where the completion handler was not getting called, which would
> have resulted in the EH thread waiting until it timed out, greatly
> extending EH time.

Applied to 4.12/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
