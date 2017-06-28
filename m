From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] fnic: Zero io_cmpl_skip on fw reset completion
Date: Tue, 27 Jun 2017 21:42:26 -0400
Message-ID: <yq1y3scyjjx.fsf@oracle.com>
References: <1498524383-32398-1-git-send-email-satishkh@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27797 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752010AbdF1Bmc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jun 2017 21:42:32 -0400
In-Reply-To: <1498524383-32398-1-git-send-email-satishkh@cisco.com> (Satish
        Kharat's message of "Mon, 26 Jun 2017 17:46:23 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satish Kharat <satishkh@cisco.com>
Cc: linux-scsi@vger.kernel.org, Sesidhar Baddela <sebaddel@cisco.com>


Satish,

> io_cmpl_skip keep track of number of completions to skip when stats
> are reset. If a fw_reset happens immediately after stats reset it
> could put it out of sync so need to reset io_cmpl_skip when fw reset
> is completed.

Applied patches 1-4 to 4.13/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
