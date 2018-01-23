From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] qla2xxx: Fix warning reported for req_que_no in qla24xx_async_cmd()
Date: Mon, 22 Jan 2018 20:04:27 -0500
Message-ID: <yq1a7x5idwk.fsf@oracle.com>
References: <20180122200420.19516-1-himanshu.madhani@cavium.com>
        <20180122200420.19516-2-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:41988 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751253AbeAWBEe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jan 2018 20:04:34 -0500
In-Reply-To: <20180122200420.19516-2-himanshu.madhani@cavium.com> (Himanshu
        Madhani's message of "Mon, 22 Jan 2018 12:04:19 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org


Himanshu,

> This patch fixes following sparse warning
>
> drivers/scsi/qla2xxx/qla_init.c:1570:44: sparse: incorrect type in assignment
> (different base types)

Amended the original commit. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
