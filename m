From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V7 6/8] scsi: sd_zbc: Initialize device request queue zoned data
Date: Wed, 08 Nov 2017 18:41:08 -0500
Message-ID: <yq160akxrsb.fsf@oracle.com>
References: <20171108081118.7632-1-damien.lemoal@wdc.com>
        <20171108081118.7632-7-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18927 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753071AbdKHXlP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2017 18:41:15 -0500
In-Reply-To: <20171108081118.7632-7-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Wed, 8 Nov 2017 17:11:16 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>


Damien,

> wait for the disk capacity and number of zones to stabilize on the
> second revalidation pass to allocate and initialize the bitmaps.

Stabilize how?

-- 
Martin K. Petersen	Oracle Linux Engineering
