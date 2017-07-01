From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] qla2xxx: Fix NVMe entry_type for iocb packet on BE system
Date: Sat, 01 Jul 2017 17:22:46 -0400
Message-ID: <yq1h8yvvom1.fsf@oracle.com>
References: <20170701023253.8362-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30892 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752006AbdGAVWz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Jul 2017 17:22:55 -0400
In-Reply-To: <20170701023253.8362-1-himanshu.madhani@cavium.com> (Himanshu
        Madhani's message of "Fri, 30 Jun 2017 19:32:53 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org


Himanshu,

> This patch fixes incorrect assignment for entry_type field for Continuation
> Type iocb packet on BE system. This was caught by -Woverflow warning on BE
> system compilation.
>
> For Continuation Type iocb driver needs to write complete 32 bit value to
> initialize other field members in stucture to 0.
>
> Following warning is seen on BE system compile: 
>
> drivers/scsi/qla2xxx/qla_nvme.c: In function 'qla2x00_start_nvme_mq':
> include/uapi/linux/byteorder/big_endian.h:32:26: warning: large integer
> implicitly truncated to unsigned type [-Woverflow]
>  #define __cpu_to_le32(x) ((__force __le32)__swab32((x)))

Applied to 4.13/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
