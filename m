From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 9/9] bsg: split handling of SCSI CDBs vs transport requeues
Date: Mon, 23 Oct 2017 03:17:29 -0400
Message-ID: <yq17evmmiye.fsf@oracle.com>
References: <20171003104845.10417-1-hch@lst.de>
        <20171003104845.10417-10-hch@lst.de>
        <20171019155933.GE26185@bblock-ThinkPad-W530>
        <20171020162630.GA14277@lst.de>
        <20171020164727.GA26380@bblock-ThinkPad-W530>
        <yq1bmkymlss.fsf@oracle.com> <20171023062949.GA16978@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46012 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbdJWHRj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2017 03:17:39 -0400
In-Reply-To: <20171023062949.GA16978@lst.de> (Christoph Hellwig's message of
        "Mon, 23 Oct 2017 08:29:49 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Benjamin Block <bblock@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, Jens Axboe <axboe@kernel.dk>


Christoph,

>> Yes, I expected the bsg bits to go through Jens' tree.
>
> Ok, then I misremembered it, and we'll have to delay the remaining
> patches until the next merge window, as they depend on the previous
> ones.

I don't mind taking them through SCSI if Jens agrees.

-- 
Martin K. Petersen	Oracle Linux Engineering
