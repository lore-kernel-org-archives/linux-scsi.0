From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Revert "sd: remove __data_len hack for WRITE SAME"
Date: Wed, 25 Jan 2017 21:56:28 -0500
Message-ID: <yq1r33qa5r7.fsf@oracle.com>
References: <48f53712-569e-d5c3-7269-d0eeb481f8ee@sandisk.com>
        <20170125222015.GA1422@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47443 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752453AbdAZC4z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2017 21:56:55 -0500
In-Reply-To: <20170125222015.GA1422@lst.de> (Christoph Hellwig's message of
        "Wed, 25 Jan 2017 23:20:15 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Thanks Bart, and sorry for messing this up.  Acked-by:
Christoph> Christoph Hellwig <hch@lst.de>

Jens: Since this came in via your tree would you mind reverting it? I'd
prefer to avoid rebasing my fixes branch.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
