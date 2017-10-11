From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: libcxgbi: simplify task->hdr allocation for mgmt cmds
Date: Wed, 11 Oct 2017 14:28:32 -0400
Message-ID: <yq160blfsj3.fsf@oracle.com>
References: <1507730601-6702-1-git-send-email-varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35229 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752483AbdJKS2h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Oct 2017 14:28:37 -0400
In-Reply-To: <1507730601-6702-1-git-send-email-varun@chelsio.com> (Varun
        Prakash's message of "Wed, 11 Oct 2017 19:33:21 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, indranil@chelsio.com


Varun,

> In case of mgmt cmds task->hdr is dereferenced after transmitting the
> pdu in iscsi_tcp_task_xmit() to handle this case current code
> increments the Tx skb reference count and frees the skb in
> cxgbi_cleanup_task(), in some error cases this results in skb leak.
>
> To fix this in case of mgmt cmds allocate a separate buffer for iSCSI
> hdr and free this buffer in cxgbi_cleanup_task().

Applied to 4.15/scsi-queue. Thanks again!

-- 
Martin K. Petersen	Oracle Linux Engineering
