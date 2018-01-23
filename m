From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] qla2xxx: Fix logo flag for qlt_free_session_done()
Date: Mon, 22 Jan 2018 20:08:10 -0500
Message-ID: <yq1607tidqd.fsf@oracle.com>
References: <20180122200420.19516-1-himanshu.madhani@cavium.com>
        <20180122200420.19516-3-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54844 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751253AbeAWBIQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jan 2018 20:08:16 -0500
In-Reply-To: <20180122200420.19516-3-himanshu.madhani@cavium.com> (Himanshu
        Madhani's message of "Mon, 22 Jan 2018 12:04:20 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org


Himanshu,

> Commit 3515832cc61467bfb87191a30401de1700e9956a fixed the target
> re-login after session relogin is complete, but missed out the
> qlt_free_session_done() path.
>
> This patch clears send_els_logo flag in qlt_free_session_done() callback.

Applied to 4.16/scsi-queue. And please run checkpatch before sending.

-- 
Martin K. Petersen	Oracle Linux Engineering
