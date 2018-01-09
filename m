From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: libcxgbi: use GFP_ATOMIC in cxgbi_conn_alloc_pdu()
Date: Mon, 08 Jan 2018 21:46:14 -0500
Message-ID: <yq11sizpx55.fsf@oracle.com>
References: <1515080057-24553-1-git-send-email-varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39118 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754049AbeAICqY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jan 2018 21:46:24 -0500
In-Reply-To: <1515080057-24553-1-git-send-email-varun@chelsio.com> (Varun
        Prakash's message of "Thu, 4 Jan 2018 21:04:17 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, indranil@chelsio.com


Varun,

> For mgmt cmds ->alloc_pdu() can be called from atomic
> context so use GFP_ATOMIC instead of GFP_KERNEL.

Applied to 4.16/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
