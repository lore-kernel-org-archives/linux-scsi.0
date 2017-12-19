From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla2xxx: Fix smatch warning in qla25xx_delete_{rsp|req}_que
Date: Mon, 18 Dec 2017 22:39:01 -0500
Message-ID: <yq1fu87jsiy.fsf@oracle.com>
References: <20171217000509.6129-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46546 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933461AbdLSDjJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Dec 2017 22:39:09 -0500
In-Reply-To: <20171217000509.6129-1-himanshu.madhani@cavium.com> (Himanshu
        Madhani's message of "Sat, 16 Dec 2017 16:05:09 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org


Himanshu,

> This patch fixes following warnings reported by smatch
>
> drivers/scsi/qla2xxx/qla_mid.c:586 qla25xx_delete_req_que()
> error: we previously assumed 'req' could be null (see line 580)
>
> drivers/scsi/qla2xxx/qla_mid.c:602 qla25xx_delete_rsp_que()
> error: we previously assumed 'rsp' could be null (see line 596)

Applied to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
