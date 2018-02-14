From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scmd_eh_abort_handler(): Add a comment
Date: Tue, 13 Feb 2018 21:41:02 -0500
Message-ID: <yq14lmkpa2p.fsf@oracle.com>
References: <20180212183805.23579-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:41918 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966382AbeBNClQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2018 21:41:16 -0500
In-Reply-To: <20180212183805.23579-1-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Mon, 12 Feb 2018 10:38:05 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>


Bart,

> After the patch that introduced this function was posted on the
> linux-scsi mailing list an explanation was posted why this patch
> is correct. Since that explanation contains important information,
> add a summary of it above the code that explanation applies to.
> See also http://www.spinics.net/lists/linux-scsi/msg106326.html.

Applied to 4.17/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
