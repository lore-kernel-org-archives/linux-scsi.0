From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bnx2fc: Fix hung task messages when a cleanup response is not received during abort.
Date: Wed, 15 Nov 2017 18:45:36 -0500
Message-ID: <yq1mv3nqf6n.fsf@oracle.com>
References: <20171115150606.10994-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25323 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751240AbdKOXpq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Nov 2017 18:45:46 -0500
In-Reply-To: <20171115150606.10994-1-chad.dupuis@cavium.com> (Chad Dupuis's
        message of "Wed, 15 Nov 2017 07:06:06 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@cavium.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com


Chad,

> If a cleanup task is not responded to while we are in
> bnx2fc_abts_cleanup, it will hang the SCSI error handler since we use
> wait_for_completion instead of wait_for_completion_timeout.  So, use
> wait_for_completion_timeout so that we don't hang the SCSI error
> handler thread forever.

Applied to 4.15/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
