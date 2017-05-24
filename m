From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: libcxgbi: fix skb use after free
Date: Tue, 23 May 2017 22:39:36 -0400
Message-ID: <yq1vaorugev.fsf@oracle.com>
References: <1494942824-2252-1-git-send-email-varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26977 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933113AbdEXCjm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2017 22:39:42 -0400
In-Reply-To: <1494942824-2252-1-git-send-email-varun@chelsio.com> (Varun
        Prakash's message of "Tue, 16 May 2017 19:23:44 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, indranil@chelsio.com


Varun,

> skb->data is assigned to task->hdr in cxgbi_conn_alloc_pdu(),
> skb gets freed after tx but task->hdr is still dereferenced in
> iscsi_tcp_task_xmit() to avoid this call skb_get() after allocating
> skb and free the skb in cxgbi_cleanup_task() or before allocating new
> skb in cxgbi_conn_alloc_pdu().

Applied to 4.12/scsi-fixes, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
