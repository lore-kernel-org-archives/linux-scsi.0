From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qedi: Drop cqe response during connection recovery
Date: Mon, 22 Jan 2018 19:24:40 -0500
Message-ID: <yq1wp09ifqv.fsf@oracle.com>
References: <20180119065209.30927-1-manish.rangankar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38648 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbeAWAYv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jan 2018 19:24:51 -0500
In-Reply-To: <20180119065209.30927-1-manish.rangankar@cavium.com> (Manish
        Rangankar's message of "Thu, 18 Jan 2018 22:52:09 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Manish Rangankar <manish.rangankar@cavium.com>
Cc: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com, linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com


Manish,

> We get stuck in the loop when firmware sends a cqe response
> during connection recovery.

Applied to 4.16/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
