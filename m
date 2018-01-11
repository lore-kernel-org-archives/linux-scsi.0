From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Change type of third __scsi_queue_insert() argument from int into bool
Date: Wed, 10 Jan 2018 23:13:32 -0500
Message-ID: <yq1bmi1t4lv.fsf@oracle.com>
References: <20180110224145.25986-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42242 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752922AbeAKERF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jan 2018 23:17:05 -0500
In-Reply-To: <20180110224145.25986-1-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Wed, 10 Jan 2018 14:41:45 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>


Bart,

> This patch does not change any functionality but makes the SCSI core
> source code slightly easier to read.

Applied to 4.16/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
