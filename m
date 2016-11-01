From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: expose queue the queue mapping for SCSI drivers V2
Date: Tue, 01 Nov 2016 13:37:46 -0400
Message-ID: <yq1vaw7yuc5.fsf@sermon.lab.mkp.net>
References: <1478009569-19026-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16836 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751387AbcKARh5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2016 13:37:57 -0400
In-Reply-To: <1478009569-19026-1-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Tue, 1 Nov 2016 08:12:46 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: martin.petersen@oracle.com, don.brace@microsemi.com, axboe@kernel.dk, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> In 4.9 I've added support in the interrupt layer to
Christoph> automatically assign the interrupt affinity at interrupt
Christoph> allocation time, and expose that information to blk-mq.

Christoph> This series extents that so that SCSI driver can pass on the
Christoph> information as well.  The SCSI part is fairly trivial,
Christoph> although we need to also export the default queue mapping
Christoph> function in blk-mq to keep things simple.

Christoph> I've also converted over the smartpqi driver as an example as
Christoph> it's the easiest of the multiqueue SCSI drivers to convert.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
