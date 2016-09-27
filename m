From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Avoid that toggling use_blk_mq triggers a memory leak
Date: Mon, 26 Sep 2016 20:59:44 -0400
Message-ID: <yq1r3862m4f.fsf@sermon.lab.mkp.net>
References: <e76485aa-8e04-c6a7-8bcb-67b2ae569a60@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28061 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754904AbcI0A7z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2016 20:59:55 -0400
In-Reply-To: <e76485aa-8e04-c6a7-8bcb-67b2ae569a60@sandisk.com> (Bart Van
        Assche's message of "Thu, 22 Sep 2016 14:20:54 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart> This patch avoids that the following memory leak is triggered if
Bart> use_blk_mq is disabled after a SCSI host has been allocated by the
Bart> ib_srp driver and before the same SCSI host is freed:

Applied to 4.8/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
