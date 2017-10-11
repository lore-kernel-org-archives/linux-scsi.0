From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: cxgb4i: fix Tx skb leak
Date: Wed, 11 Oct 2017 14:28:14 -0400
Message-ID: <yq1a80xfsjl.fsf@oracle.com>
References: <1507730587-6655-1-git-send-email-varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33092 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752483AbdJKS2T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Oct 2017 14:28:19 -0400
In-Reply-To: <1507730587-6655-1-git-send-email-varun@chelsio.com> (Varun
        Prakash's message of "Wed, 11 Oct 2017 19:33:07 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, indranil@chelsio.com


Varun,

> In case of connection reset Tx skb queue can have some skbs which are
> not transmitted so purge Tx skb queue in release_offload_resources()
> to avoid skb leak.

Applied to 4.15/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
