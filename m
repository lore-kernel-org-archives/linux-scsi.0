From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_debug: Add support for injecting SCSI_MLQUEUE_HOST_BUSY
Date: Thu, 07 Dec 2017 21:51:20 -0500
Message-ID: <yq1y3mesziv.fsf@oracle.com>
References: <20171207225618.3116-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46498 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752523AbdLHCvh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Dec 2017 21:51:37 -0500
In-Reply-To: <20171207225618.3116-1-bart.vanassche@wdc.com> (Bart Van Assche's
        message of "Thu, 7 Dec 2017 14:56:18 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>


Bart,

> Although it is important to be able to trigger the code in the SCSI
> core for SCSI_MLQUEUE_HOST_BUSY handling, currently it is
> nontrivial to trigger that code. Hence this patch that adds a new
> error injection option to the scsi_debug driver for making the
> .queue_rq() implementation of this driver return
> SCSI_MLQUEUE_HOST_BUSY.

Applied to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
