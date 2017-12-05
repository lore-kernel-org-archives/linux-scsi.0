From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 00/22]  qla2xxx: Bug fixes for 4.15-rc2
Date: Mon, 04 Dec 2017 21:24:39 -0500
Message-ID: <yq1k1y16heg.fsf@oracle.com>
References: <20171204224517.3409-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38325 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752143AbdLEEFE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Dec 2017 23:05:04 -0500
In-Reply-To: <20171204224517.3409-1-himanshu.madhani@cavium.com> (Himanshu
        Madhani's message of "Mon, 4 Dec 2017 14:44:55 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org


Himanshu,

>  drivers/scsi/qla2xxx/qla_def.h     |  49 ++++----
>  drivers/scsi/qla2xxx/qla_gs.c      | 230 ++++++++++++++++++++++++++++++-------
>  drivers/scsi/qla2xxx/qla_init.c    |  69 +++++++++--
>  drivers/scsi/qla2xxx/qla_iocb.c    |  13 ---
>  drivers/scsi/qla2xxx/qla_isr.c     |   7 +-
>  drivers/scsi/qla2xxx/qla_mbx.c     |   3 +-
>  drivers/scsi/qla2xxx/qla_mid.c     |  42 ++++---
>  drivers/scsi/qla2xxx/qla_os.c      |  78 ++++++++++---
>  drivers/scsi/qla2xxx/qla_target.c  |  60 +++++++---
>  drivers/scsi/qla2xxx/qla_version.h |   2 +-
>  10 files changed, 405 insertions(+), 148 deletions(-)

This looks pretty big for a series of bug fixes. Are all these patches
really candidates for 4.15 and stable backports all the way back to
4.10?

-- 
Martin K. Petersen	Oracle Linux Engineering
