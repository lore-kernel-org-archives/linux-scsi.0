From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/6] qla2xxx: Fix a locking imbalance in qlt_24xx_handle_els()
Date: Tue, 06 Feb 2018 19:29:33 -0500
Message-ID: <yq1a7wl3amq.fsf@oracle.com>
References: <20180124003351.2616-1-bart.vanassche@wdc.com>
        <20180124003351.2616-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33638 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932106AbeBGA3k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Feb 2018 19:29:40 -0500
In-Reply-To: <20180124003351.2616-2-bart.vanassche@wdc.com> (Bart Van Assche's
        message of "Tue, 23 Jan 2018 16:33:46 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Himanshu Madhani <himanshu.madhani@cavium.com>, linux-scsi@vger.kernel.org, Quinn Tran <quinn.tran@cavium.com>


Bart,

> Ensure that upon return the tgt->ha->tgt.sess_lock spin lock is
> unlocked no matter which code path is taken through this function.
> This was detected by sparse.

Applied to 4.16/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
