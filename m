From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Remove Scsi_Host.uspace_req_q
Date: Tue, 05 Sep 2017 08:19:38 -0400
Message-ID: <yq1h8whs5gl.fsf@oracle.com>
References: <20170831235906.19451-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36326 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750805AbdIEMTu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2017 08:19:50 -0400
In-Reply-To: <20170831235906.19451-1-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Thu, 31 Aug 2017 16:59:06 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>


Bart,

> A patch I wrote myself several years ago removed SCSI target support
> from the code under drivers/scsi. That patch removed the code that
> sets uspace_req_q to a non-NULL value. Hence also remove the code that
> depends on uspace_req_q != NULL.

Applied to 4.14/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
