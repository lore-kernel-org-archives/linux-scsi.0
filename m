From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: libcxgbi: fix skb use after free
Date: Thu, 18 May 2017 21:36:59 -0400
Message-ID: <yq1lgpt4og4.fsf@oracle.com>
References: <1494942824-2252-1-git-send-email-varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24772 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932317AbdESBhJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2017 21:37:09 -0400
In-Reply-To: <1494942824-2252-1-git-send-email-varun@chelsio.com> (Varun
        Prakash's message of "Tue, 16 May 2017 19:23:44 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, indranil@chelsio.com


> skb->data is assigned to task->hdr in cxgbi_conn_alloc_pdu(),
> skb gets freed after tx but task->hdr is still dereferenced in
> iscsi_tcp_task_xmit() to avoid this call skb_get() after allocating
> skb and free the skb in cxgbi_cleanup_task() or before allocating new
> skb in cxgbi_conn_alloc_pdu().

Somebody please review!

https://patchwork.kernel.org/patch/9729239/

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
