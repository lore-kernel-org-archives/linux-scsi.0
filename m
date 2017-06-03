From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qedf: Check if sense buffer has been allocated during completion.
Date: Fri, 02 Jun 2017 20:40:42 -0400
Message-ID: <yq1r2z1hpit.fsf@oracle.com>
References: <20170602190205.10009-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18810 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbdFCAkv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2017 20:40:51 -0400
In-Reply-To: <20170602190205.10009-1-chad.dupuis@cavium.com> (Chad Dupuis's
        message of "Fri, 2 Jun 2017 12:02:05 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dupuis, Chad" <chad.dupuis@cavium.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com


Chad,

> sc_cmd->sense_buffer is not guaranteed to be allocated so we need to
> sc_cmd->check
> if the pointer is NULL before trying to copy anything into it.

Applied to 4.13/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
