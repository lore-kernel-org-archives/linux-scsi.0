From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] blk-mq: export blk_mq_map_queues
Date: Tue, 01 Nov 2016 11:53:18 -0400
Message-ID: <yq1lgx319jl.fsf@sermon.lab.mkp.net>
References: <1478009569-19026-1-git-send-email-hch@lst.de>
        <1478009569-19026-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42990 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750926AbcKAPxc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2016 11:53:32 -0400
In-Reply-To: <1478009569-19026-2-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Tue, 1 Nov 2016 08:12:47 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: martin.petersen@oracle.com, don.brace@microsemi.com, axboe@kernel.dk, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> This will allow SCSI to have a single blk_mq_ops structure
Christoph> that either lets the LLDD map the queues to PCIe MSIx vectors
Christoph> or use the default.

Jens, any objection to me funneling this change through the SCSI tree?

-- 
Martin K. Petersen	Oracle Linux Engineering
