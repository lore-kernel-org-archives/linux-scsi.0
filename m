From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 4/7] block: Define zoned block device operations
Date: Tue, 27 Sep 2016 23:45:10 -0400
Message-ID: <yq1h990znzt.fsf@sermon.lab.mkp.net>
References: <1475025757-6340-1-git-send-email-damien.lemoal@hgst.com>
        <1475025757-6340-5-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29678 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750949AbcI1DpZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2016 23:45:25 -0400
In-Reply-To: <1475025757-6340-5-git-send-email-damien.lemoal@hgst.com> (Damien
        Le Moal's message of "Wed, 28 Sep 2016 10:22:34 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@hgst.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>, Shaun Tancheff <shaun.tancheff@seagate.com>

>>>>> "Damien" == Damien Le Moal <damien.lemoal@hgst.com> writes:

Damien> Define REQ_OP_ZONE_REPORT and REQ_OP_ZONE_RESET for handling
Damien> zones of host-managed and host-aware zoned block devices. With
Damien> with these two new operations, the total number of operations
Damien> defined reaches 8 and still fits with the 3 bits definition of
Damien> REQ_OP_BITS.

Nicer!

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
