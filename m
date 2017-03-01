From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] Separate zone requests from medium access requests
Date: Tue, 28 Feb 2017 21:52:31 -0500
Message-ID: <yq160jtu2s0.fsf@oracle.com>
References: <20170228102535.15966-1-damien.lemoal@wdc.com>
        <20170228160259.GA22755@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23772 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750957AbdCACxq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2017 21:53:46 -0500
In-Reply-To: <20170228160259.GA22755@lst.de> (Christoph Hellwig's message of
        "Tue, 28 Feb 2017 17:02:59 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> I don't really like this too much - this is too many SCSI
Christoph> specifics for the block layer to care.  Maybe using bios for
Christoph> the zone ops was a mistake after all, and we should just have
Christoph> operations in struct block_device instead..

Yeah, I'm afraid I don't like this either.

Short term I still think we should adjust in sd. And then maybe longer
term revisit whether these hybrid commands should be something other
than bios.

-- 
Martin K. Petersen	Oracle Linux Engineering
