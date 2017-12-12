From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla2xxx: Suppress gcc 7 fall-through warnings
Date: Mon, 11 Dec 2017 21:50:57 -0500
Message-ID: <yq18te8r75a.fsf@oracle.com>
References: <20171208000246.19617-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:56070 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751663AbdLLC5I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Dec 2017 21:57:08 -0500
In-Reply-To: <20171208000246.19617-1-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Thu, 7 Dec 2017 16:02:46 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Himanshu Madhani <himanshu.madhani@cavium.com>, Quinn Tran <quinn.tran@cavium.com>, Hannes Reinecke <hare@suse.com>


Bart,

> Avoid that building with gcc 7 and W=1 triggers warnings similar
> to the following:
/scsi/qla2xxx/qla_isr.c:1189:27: warning: this statement may fall through [-Wimplicit-fallthrough=]

Applied to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
