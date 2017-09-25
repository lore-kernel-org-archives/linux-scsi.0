From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V3 1/2] scsi: sd: Fix sd_config_write_same()
Date: Mon, 25 Sep 2017 15:39:51 -0400
Message-ID: <yq1wp4mftyw.fsf@oracle.com>
References: <20170905115536.2896-1-damien.lemoal@wdc.com>
        <20170905115536.2896-2-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50720 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965176AbdIYTkE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Sep 2017 15:40:04 -0400
In-Reply-To: <20170905115536.2896-2-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Tue, 5 Sep 2017 20:55:35 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>


Damien,

> Reporting a maximum number of blocks that is not aligned on the device
> physical size would cause a large write same request to be split into
> physically unaligned chunks by __blkdev_issue_write_zeroes() and
> __blkdev_issue_write_same(), even if the caller of these functions
> took care to align its request to physical sectors.

Applied to 4.15/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
