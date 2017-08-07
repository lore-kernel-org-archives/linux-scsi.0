From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] st: fix blk_get_queue usage
Date: Mon, 07 Aug 2017 13:40:20 -0400
Message-ID: <yq1d1879szf.fsf@oracle.com>
References: <1501591374-11229-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36108 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751775AbdHGRkr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2017 13:40:47 -0400
In-Reply-To: <1501591374-11229-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Tue, 1 Aug 2017 14:42:54 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Kai =?utf-8?Q?M?= =?utf-8?Q?=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Bodo Stroesser <bstroesser@ts.fujitsu.com>, Hannes Reinecke <hare@suse.com>


Hannes,

> If blk_queue_get() in st_probe fails, disk->queue must not be set to
> SDp->request_queue, as that would result in put_disk() dropping a not
> taken reference.
>
> Thus, disk->queue should be set only after a successful
> blk_queue_get().

Applied to 4.13/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
